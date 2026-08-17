// ============================================================
// Oxalyn-64 CPU — 5-Aşamalı Pipeline RTL
//
// Pipeline Aşamaları:
//   IF  — Instruction Fetch  : mem'den komut oku
//   ID  — Instruction Decode : register oku, kontrol sinyalleri üret
//   EX  — Execute            : ALU işlemi, dal kararı
//   MEM — Memory Access      : LOAD/STORE/IN/OUT
//   WB  — Write Back         : sonucu register'a yaz
//
// Hazard Yönetimi:
//   Data Hazard   → EX→EX, MEM→EX, WB→EX forwarding
//   Load-Use      → 1 bubble (stall) + forwarding
//   Control Hazard→ dal/jump EX aşamasında çözülür, IF+ID flush (2 bubble)
//
// Bu RTL, sim.c ile ortak temel opcode'ları ve 0x20–0x2A uzantılarını
// uygular. FPU (0x2B–0x30), cache ve MMU henüz bu top-level CPU'ya bağlı
// değildir; ISA belgelerinde rezerve/gelecek özellik olarak işaretlenir.
// ============================================================
`timescale 1ns / 1ps

module oxalyn_cpu (
    input  wire        clk,
    input  wire        rst_n,
    // Bellek
    output reg  [15:0] mem_addr,
    output reg         mem_we,
    output reg  [63:0] mem_wdata,
    input  wire [63:0] mem_rdata,
    // G/Ç
    output reg  [7:0]  io_addr,
    output reg         io_we,
    output reg  [63:0] io_wdata,
    input  wire [63:0] io_rdata,
    // Harici kesme hattı (GPU/GPIO gibi çevre birimleri)
    input  wire        irq_external,
    // GPU DMA tamamlanma kesmesi
    input  wire        irq_dma,
    // UART durum kesmeleri (RX tamponu dolu / TX yeni byte kabul edebilir)
    input  wire        uart_irq_rx,
    input  wire        uart_irq_tx,
    // Durum
    output reg         halted,
    output reg  [63:0] cycles
);

// ── Opcode Sabitleri ─────────────────────────────────────
localparam OP_NOP    = 6'h00; localparam OP_ADD    = 6'h01;
localparam OP_SUB    = 6'h02; localparam OP_AND    = 6'h03;
localparam OP_OR     = 6'h04; localparam OP_XOR    = 6'h05;
localparam OP_SHL    = 6'h06; localparam OP_SHR    = 6'h07;
localparam OP_LOAD   = 6'h08; localparam OP_STORE  = 6'h09;
localparam OP_LI     = 6'h0A; localparam OP_JMP    = 6'h0B;
localparam OP_JZ     = 6'h0C; localparam OP_JNZ    = 6'h0D;
localparam OP_CALL   = 6'h0E; localparam OP_RET    = 6'h0F;
localparam OP_OUT    = 6'h10; localparam OP_IN     = 6'h11;
localparam OP_MUL    = 6'h1A; localparam OP_DIV    = 6'h1B;
localparam OP_ELOAD  = 6'h1C; localparam OP_ESTORE = 6'h1D;
localparam OP_RFLAGS = 6'h1E; localparam OP_HALT   = 6'h3F;
localparam OP_LUI    = 6'h20; localparam OP_JALR   = 6'h21;
localparam OP_CMPEQ  = 6'h22; localparam OP_CMPNE  = 6'h23;
localparam OP_CMPLT  = 6'h24; localparam OP_CMPLE  = 6'h25;
localparam OP_CMPLTU = 6'h26; localparam OP_CMPLEU = 6'h27;
localparam OP_BSET   = 6'h28; localparam OP_BCLR   = 6'h29;
localparam OP_BTEST  = 6'h2A;
localparam OP_ECALL  = 6'h12; localparam OP_ERET   = 6'h13;
localparam OP_CSRW   = 6'h14; localparam OP_CSRR   = 6'h15;
localparam OP_WFI    = 6'h1F;

// Donanım kesmesi CSR adresleri
localparam CSR_MEPC    = 6'h01;
localparam CSR_MCAUSE  = 6'h02;
localparam CSR_MTVEC   = 6'h03;
localparam CSR_MSTATUS = 6'h04;
localparam CSR_MIE     = 6'h20;
localparam CSR_MIP     = 6'h21;
localparam CSR_MTIMECMP= 6'h22;
localparam CSR_MTIME   = 6'h23;

localparam CAUSE_IRQ_TIMER = 64'h0000_0000_8000_0001;
// UART RX owns cause 0x80000002; keep legacy external sources distinct.
localparam CAUSE_IRQ_EXT   = 64'h0000_0000_8000_0004;
localparam CAUSE_IRQ_UART_RX = 64'h0000_0000_8000_0002;
localparam CAUSE_IRQ_UART_TX = 64'h0000_0000_8000_0003;
localparam CAUSE_IRQ_DMA = 64'h0000_0000_8000_0005;

// ── Register Dosyası ─────────────────────────────────────
reg [63:0] regs [0:31];
integer    gi;

// ── Program Counter ──────────────────────────────────────
reg [15:0] pc_if;   // IF aşaması PC (sonraki fetch adresi)

// ─────────────────────────────────────────────────────────
// IF/ID Pipeline Kaydı
// ─────────────────────────────────────────────────────────
reg [31:0] id_insn;
reg [15:0] id_pc;
reg        id_valid;

// ─────────────────────────────────────────────────────────
// ID/EX Pipeline Kaydı
// ─────────────────────────────────────────────────────────
reg [5:0]  ex_op;
reg [4:0]  ex_fd, ex_fa, ex_fb;
reg [63:0] ex_rv_fa, ex_rv_fb;  // register okunan değerler
reg [63:0] ex_rv_fd;            // CSRW için kaynak register değeri
reg [63:0] ex_imm;
reg [15:0] ex_pc;
reg        ex_valid;
reg        ex_reg_write;   // WB'de register'a yaz
reg        ex_mem_read;    // LOAD/IN
reg        ex_mem_write;   // STORE/OUT
reg        ex_is_branch;   // dal komutu
reg        ex_is_io;       // IO işlemi

// ─────────────────────────────────────────────────────────
// EX/MEM Pipeline Kaydı
// ─────────────────────────────────────────────────────────
reg [5:0]  mem_op;
reg [4:0]  mem_fd;
reg [63:0] mem_alu_result; // ALU çıkışı veya store verisi
reg [63:0] mem_store_data; // STORE/OUT için yazılacak veri
reg [15:0] mem_addr_r;     // bellek/IO adresi
reg        mem_valid;
reg        mem_reg_write;
reg        mem_mem_read;
reg        mem_mem_write;
reg        mem_is_io;
reg [15:0] mem_pc;

// ─────────────────────────────────────────────────────────
// MEM/WB Pipeline Kaydı
// ─────────────────────────────────────────────────────────
reg [4:0]  wb_fd;
reg [63:0] wb_data;        // register'a yazılacak değer
reg        wb_valid;
reg        wb_reg_write;

// Makine kesmesi durumu
reg [63:0] csr_mepc;
reg [63:0] csr_mcause;
reg [63:0] csr_mtvec;
reg [63:0] csr_mstatus;
reg [63:0] csr_mie;
reg [63:0] csr_mip;
reg [63:0] csr_mtimecmp;
reg        waiting_for_irq;
    // Architectural PC immediately after the WFI instruction.  The fetch
    // PC can be several instructions ahead because of the pipeline.
    reg [15:0] wfi_resume_pc;

wire timer_irq_pending = (csr_mtimecmp != 64'd0) &&
                          (cycles >= csr_mtimecmp);
wire dma_irq_pending = (irq_dma === 1'b1);
wire irq_pending = csr_mstatus[0] &&
                   ((csr_mie[0] && (csr_mip[0] || timer_irq_pending)) ||
                    (csr_mie[1] && (csr_mip[1] || irq_external)) ||
                    (csr_mie[2] && (csr_mip[2] || uart_irq_rx)) ||
                     (csr_mie[3] && (csr_mip[3] || uart_irq_tx)) ||
                     (csr_mie[4] && (csr_mip[4] || dma_irq_pending)));

function [63:0] csr_read;
    input [5:0] idx;
    begin
        case (idx)
            CSR_MEPC:     csr_read = csr_mepc;
            CSR_MCAUSE:   csr_read = csr_mcause;
            CSR_MTVEC:    csr_read = csr_mtvec;
            CSR_MSTATUS:  csr_read = csr_mstatus;
            CSR_MIE:      csr_read = csr_mie;
            CSR_MIP:      csr_read = csr_mip |
                                      {59'd0, dma_irq_pending, uart_irq_tx, uart_irq_rx,
                                       irq_external, timer_irq_pending};
            CSR_MTIMECMP: csr_read = csr_mtimecmp;
            CSR_MTIME:    csr_read = cycles;
            default:      csr_read = 64'd0;
        endcase
    end
endfunction

// ─────────────────────────────────────────────────────────
// Kontrol Sinyalleri
// ─────────────────────────────────────────────────────────
reg        stall;          // load-use hazard stall
reg        flush_if_id;    // kontrol hazard flush
reg        flush_id_ex;

// ─────────────────────────────────────────────────────────
// Forwarding Muxları için EX aşaması forward değerleri
// ─────────────────────────────────────────────────────────
reg [63:0] fw_fa, fw_fb;
reg [63:0] fw_fd;

// ─────────────────────────────────────────────────────────
// ID-Aşaması Dal Tahmincisi — Statik Geri Dal Tahmini
//   Geri yönlü dallar (imm < 0) "alınacak" olarak tahmin edilir.
//   Doğru tahmin → EX'te flush gerekmez (1-2 bubble tasarrufu).
// ─────────────────────────────────────────────────────────
reg        ex_was_predicted;   // dal daha önce ID'de öngörüldü mü?
reg [15:0] ex_pred_target_r;   // öngörülen dal hedefi
// ─────────────────────────────────────────────────────────
// ID Aşaması: Decode yardımcı wirelar
// ─────────────────────────────────────────────────────────
wire [5:0]  id_op      = id_insn[31:26];
wire [4:0]  id_fd      = id_insn[25:21];
wire [4:0]  id_fa      = id_insn[20:16];
wire [4:0]  id_fb      = id_insn[15:11];
wire [10:0] id_raw_imm = id_insn[10:0];
wire [63:0] id_imm     = {{53{id_raw_imm[10]}}, id_raw_imm};

// Register okuma (forwarding dahil WB aşamasından)
wire [63:0] id_rfa = (id_fa == 5'd0) ? 64'd0 :
                     (wb_valid && wb_reg_write && wb_fd == id_fa) ? wb_data :
                     regs[id_fa];
wire [63:0] id_rfb = (id_fb == 5'd0) ? 64'd0 :
                     (wb_valid && wb_reg_write && wb_fd == id_fb) ? wb_data :
                     regs[id_fb];
wire [63:0] id_rfd = (id_fd == 5'd0) ? 64'd0 :
                     (wb_valid && wb_reg_write && wb_fd == id_fd) ? wb_data :
                     regs[id_fd];

// Kontrol decode
wire id_is_reg_write = (id_op != OP_NOP && id_op != OP_HALT &&
                        id_op != OP_STORE && id_op != OP_ESTORE &&
                        id_op != OP_JMP && id_op != OP_JZ &&
                        id_op != OP_JNZ && id_op != OP_OUT &&
                        id_op != OP_CALL && id_op != OP_CSRW &&
                        id_op != OP_ERET && id_op != OP_WFI) && id_valid;
wire id_is_mem_read  = (id_op == OP_LOAD || id_op == OP_IN) && id_valid;
wire id_is_mem_write = (id_op == OP_STORE || id_op == OP_OUT) && id_valid;
wire id_is_branch    = (id_op == OP_JMP || id_op == OP_JZ ||
                        id_op == OP_JNZ || id_op == OP_CALL ||
                        id_op == OP_RET || id_op == OP_JALR ||
                        id_op == OP_ERET) && id_valid;
wire id_is_io        = (id_op == OP_OUT || id_op == OP_IN) && id_valid;

// Load-Use hazard: EX aşamasında LOAD/IN var, ID'deki komut aynı register'ı okuyor
wire load_use_hazard = ex_valid && ex_mem_read &&
                       ((ex_fd == id_fa && id_fa != 5'd0) ||
                        (ex_fd == id_fb && id_fb != 5'd0) ||
                        (ex_fd == id_fd && id_fd != 5'd0));


// ─────────────────────────────────────────────────────────
// EX Aşaması: Forwarding
// ─────────────────────────────────────────────────────────
always @(*) begin
    // FA forwarding
    if (mem_valid && mem_reg_write && mem_fd != 5'd0 && mem_fd == ex_fa)
        fw_fa = mem_alu_result;          // EX/MEM → EX
    else if (wb_valid && wb_reg_write && wb_fd != 5'd0 && wb_fd == ex_fa)
        fw_fa = wb_data;                 // MEM/WB → EX
    else
        fw_fa = ex_rv_fa;

    // FB forwarding
    if (mem_valid && mem_reg_write && mem_fd != 5'd0 && mem_fd == ex_fb)
        fw_fb = mem_alu_result;
    else if (wb_valid && wb_reg_write && wb_fd != 5'd0 && wb_fd == ex_fb)
        fw_fb = wb_data;
    else
        fw_fb = ex_rv_fb;

    // FD is the value source for STORE and OUT.  It needs the same
    // forwarding treatment as ALU operands, especially immediately after
    // an LI/ALU instruction in an interrupt handler's resume path.
    if (mem_valid && mem_reg_write && mem_fd != 5'd0 && mem_fd == ex_fd)
        fw_fd = mem_alu_result;
    else if (wb_valid && wb_reg_write && wb_fd != 5'd0 && wb_fd == ex_fd)
        fw_fd = wb_data;
    else
        fw_fd = ex_rv_fd;
end

// ─────────────────────────────────────────────────────────
// EX Aşaması: ALU
// ─────────────────────────────────────────────────────────
reg [63:0] alu_result;
reg        branch_taken;
reg [15:0] branch_target;
wire [15:0] branch_fallthrough_addr = ex_pc + 16'd1;

always @(*) begin
    alu_result    = 64'd0;
    branch_taken  = 1'b0;
    branch_target = branch_fallthrough_addr; // alınmayan dalın adresi

    case (ex_op)
        OP_NOP:    alu_result = 64'd0;
        OP_ADD:    alu_result = fw_fa + fw_fb;
        OP_SUB:    alu_result = fw_fa - fw_fb;
        OP_AND:    alu_result = fw_fa & fw_fb;
        OP_OR:     alu_result = fw_fa | fw_fb;
        OP_XOR:    alu_result = fw_fa ^ fw_fb;
        OP_SHL:    alu_result = fw_fa << ex_imm[5:0];
        OP_SHR:    alu_result = fw_fa >> ex_imm[5:0];
        OP_LI:     alu_result = ex_imm;
        OP_LUI:    alu_result = ex_imm << 16;
        OP_MUL:    alu_result = fw_fa * fw_fb;
        OP_DIV:    alu_result = (fw_fb != 64'd0) ? (fw_fa / fw_fb) : 64'd0;
        OP_RFLAGS: alu_result = 64'd0; // RTL'de flag yok
        OP_ELOAD:  alu_result = 64'd0; // sim-only NOP
        OP_ESTORE: alu_result = 64'd0;
        OP_CMPEQ:  alu_result = (fw_fa == fw_fb) ? 64'd1 : 64'd0;
        OP_CMPNE:  alu_result = (fw_fa != fw_fb) ? 64'd1 : 64'd0;
        OP_CMPLT:  alu_result = ($signed(fw_fa) <  $signed(fw_fb)) ? 64'd1 : 64'd0;
        OP_CMPLE:  alu_result = ($signed(fw_fa) <= $signed(fw_fb)) ? 64'd1 : 64'd0;
        OP_CMPLTU: alu_result = (fw_fa <  fw_fb) ? 64'd1 : 64'd0;
        OP_CMPLEU: alu_result = (fw_fa <= fw_fb) ? 64'd1 : 64'd0;
        OP_BSET:   alu_result = fw_fa | (64'd1 << ex_imm[5:0]);
        OP_BCLR:   alu_result = fw_fa & ~(64'd1 << ex_imm[5:0]);
        OP_BTEST:  alu_result = (fw_fa >> ex_imm[5:0]) & 64'd1;
        OP_CSRR:   alu_result = csr_read(ex_imm[5:0]);
        OP_CSRW:   alu_result = 64'd0;
        OP_ECALL:  alu_result = 64'd0;
        OP_WFI:    alu_result = 64'd0;
        OP_LOAD:   alu_result = fw_fa + ex_imm;   // bellek adresi
        OP_STORE:  alu_result = fw_fa + ex_imm;   // bellek adresi
        OP_IN:     alu_result = ex_imm & 64'hFF;  // port numarası
        OP_OUT:    alu_result = ex_imm & 64'hFF;  // port numarası
        OP_HALT:   alu_result = 64'd0;

        // Dal komutları: branch_target hesapla
        OP_JMP: begin
            branch_taken  = 1'b1;
            branch_target = branch_fallthrough_addr + ex_imm[15:0];
        end
        OP_JZ: begin
            // Conditional branches encode their condition register in Fd.
            branch_taken  = (fw_fd == 64'd0);
            branch_target = branch_fallthrough_addr + ex_imm[15:0];
        end
        OP_JNZ: begin
            // Conditional branches encode their condition register in Fd.
            branch_taken  = (fw_fd != 64'd0);
            branch_target = branch_fallthrough_addr + ex_imm[15:0];
        end
        OP_CALL: begin
            branch_taken  = 1'b1;
            branch_target = branch_fallthrough_addr + ex_imm[15:0];
            alu_result    = {48'd0, branch_fallthrough_addr}; // dönüş adresi
        end
        OP_RET: begin
            branch_taken  = 1'b1;
            branch_target = fw_fa[15:0]; // mem'den gelecek, stall gerekebilir
            // RET: fw_fa = mem[R7] değil, R7 değeri — MEM aşamasında handle
        end
        OP_JALR: begin
            branch_taken  = 1'b1;
            branch_target = (fw_fa[15:0] + ex_imm[15:0]);
            alu_result    = {48'd0, branch_fallthrough_addr}; // link
        end
        OP_ERET: begin
            branch_taken  = 1'b1;
            branch_target = csr_mepc[15:0];
        end
        default: alu_result = 64'd0;
    endcase
end


// ─────────────────────────────────────────────────────────
// Bellek/IO Kombinasyonel Sürücü (MEM aşaması)
// ─────────────────────────────────────────────────────────
always @(*) begin
    // Varsayılan: IF fetch
    mem_addr  = pc_if;
    mem_we    = 1'b0;
    mem_wdata = 64'd0;
    io_addr   = 8'd0;
    io_we     = 1'b0;
    io_wdata  = 64'd0;

    if (mem_valid) begin
        if (mem_mem_write && !mem_is_io) begin
            // STORE: belleğe yaz — IF fetch'i durdur
            mem_addr  = mem_addr_r;
            mem_we    = 1'b1;
            mem_wdata = mem_store_data;
        end else if (mem_mem_read && !mem_is_io) begin
            // LOAD: belleği oku
            mem_addr  = mem_addr_r;
        end else if (mem_is_io && mem_mem_write) begin
            // OUT: IO portuna yaz
            io_addr  = mem_addr_r[7:0];
            io_we    = 1'b1;
            io_wdata = mem_store_data;
        end else if (mem_is_io && mem_mem_read) begin
            // IN: IO portunu oku
            io_addr  = mem_addr_r[7:0];
        end
    end

    // CALL stack push — EX aşamasında
    if (ex_valid && ex_op == OP_CALL) begin
        mem_addr  = regs[7][15:0] - 16'd1;
        mem_we    = 1'b1;
        mem_wdata = {48'd0, branch_fallthrough_addr}; // dönüş adresi
    end

    // RET stack pop — EX aşamasında (adres R7)
    if (ex_valid && ex_op == OP_RET) begin
        mem_addr = regs[7][15:0];
        mem_we   = 1'b0;
    end
end

// ─────────────────────────────────────────────────────────
// Pipeline Kayıtlarını Güncelle (senkron)
// ─────────────────────────────────────────────────────────
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pc_if       <= 16'd0;
        halted      <= 1'b0;
        cycles      <= 64'd0;

        id_insn  <= 32'd0; id_pc  <= 16'd0; id_valid  <= 1'b0;
        ex_op    <= 6'd0;  ex_fd  <= 5'd0;  ex_fa     <= 5'd0;
        ex_fb    <= 5'd0;  ex_rv_fa <= 64'd0; ex_rv_fb <= 64'd0;
         ex_rv_fd <= 64'd0;
        ex_imm   <= 64'd0; ex_pc  <= 16'd0; ex_valid  <= 1'b0;
        ex_reg_write <= 1'b0; ex_mem_read <= 1'b0;
        ex_mem_write <= 1'b0; ex_is_branch <= 1'b0; ex_is_io <= 1'b0;
        ex_was_predicted <= 1'b0; ex_pred_target_r <= 16'd0;

        mem_op   <= 6'd0;  mem_fd <= 5'd0;  mem_alu_result <= 64'd0;
        mem_store_data <= 64'd0; mem_addr_r <= 16'd0;
        mem_valid <= 1'b0; mem_reg_write <= 1'b0;
        mem_mem_read <= 1'b0; mem_mem_write <= 1'b0;
        mem_is_io <= 1'b0; mem_pc <= 16'd0;

        wb_fd   <= 5'd0;   wb_data <= 64'd0; wb_valid <= 1'b0;
        wb_reg_write <= 1'b0;

         csr_mepc     <= 64'd0;
         csr_mcause   <= 64'd0;
         csr_mtvec    <= 64'd0;
         csr_mstatus  <= 64'd0;
         csr_mie      <= 64'd0;
         csr_mip      <= 64'd0;
         csr_mtimecmp <= 64'd0;
         waiting_for_irq <= 1'b0;
         wfi_resume_pc <= 16'd0;

        for (gi = 0; gi < 32; gi = gi + 1) regs[gi] <= 64'd0;
    end
    else if (!halted) begin

        // ── Cycle Sayacı ──────────────────────────────
        cycles <= cycles + 64'd1;

        // ── Kesme girişi ───────────────────────────────
        // Pipeline'ı tamamen boşaltarak, kesilen akışın yarım
        // komutlarının trap handler'dan önce yan etki üretmesini önle.
        if (irq_pending) begin
            // WFI has already retired before the interrupt is accepted.
            // Use its saved resume PC instead of the speculative fetch PC.
            csr_mepc    <= waiting_for_irq
                            ? {48'd0, wfi_resume_pc}
                            : {48'd0, pc_if};
            if (csr_mie[0] && (csr_mip[0] || timer_irq_pending))
                csr_mcause <= CAUSE_IRQ_TIMER;
            else if (csr_mie[2] && (csr_mip[2] || uart_irq_rx))
                csr_mcause <= CAUSE_IRQ_UART_RX;
            else if (csr_mie[3] && (csr_mip[3] || uart_irq_tx))
                csr_mcause <= CAUSE_IRQ_UART_TX;
            else if (csr_mie[4] && (csr_mip[4] || dma_irq_pending))
                csr_mcause <= CAUSE_IRQ_DMA;
            else
                csr_mcause <= CAUSE_IRQ_EXT;
            csr_mstatus[1] <= csr_mstatus[0];
            csr_mstatus[0] <= 1'b0;
            pc_if         <= csr_mtvec[15:0];
            waiting_for_irq <= 1'b0;

            id_valid <= 1'b0;
            ex_valid <= 1'b0;
            mem_valid <= 1'b0;
            wb_valid <= 1'b0;
            ex_reg_write <= 1'b0;
            ex_mem_read <= 1'b0;
            ex_mem_write <= 1'b0;
            mem_reg_write <= 1'b0;
            mem_mem_read <= 1'b0;
            mem_mem_write <= 1'b0;
            wb_reg_write <= 1'b0;
        end else if (waiting_for_irq) begin
            // WFI: cycle sayacı çalışmaya devam eder, pipeline donar.
            // IRQ geldiğinde yukarıdaki trap yolu tekrar etkinleşir.
            waiting_for_irq <= 1'b1;
        end else begin

        // ────────────────────────────────────────────
        // WB Aşaması: Register'a yaz
        // ────────────────────────────────────────────
        if (wb_valid && wb_reg_write && wb_fd != 5'd0)
            regs[wb_fd] <= wb_data;

        // ────────────────────────────────────────────
        // MEM→WB Geçişi
        // ────────────────────────────────────────────
        wb_valid     <= mem_valid;
        wb_reg_write <= mem_reg_write;
        wb_fd        <= mem_fd;
        if (mem_valid && mem_mem_read) begin
            // LOAD: mem_rdata veya io_rdata
            wb_data <= mem_is_io ? io_rdata : mem_rdata;
        end else begin
            wb_data <= mem_alu_result;
        end

        // ────────────────────────────────────────────
        // EX→MEM Geçişi
        // ────────────────────────────────────────────
        mem_valid      <= ex_valid;
        mem_op         <= ex_op;
        mem_fd         <= ex_fd;
        mem_alu_result <= alu_result;
        mem_reg_write  <= ex_reg_write;
        mem_mem_read   <= ex_mem_read;
        mem_mem_write  <= ex_mem_write;
        mem_is_io      <= ex_is_io;
        mem_pc         <= ex_pc;

        // FD alanı STORE ve OUT için kaynak register'dır.  Forward edilmiş
        // değer kullanılmalı; aksi halde LI/ALU sonrası port yazısı önceki
        // handler değerini tekrarlar.
        mem_store_data <= (ex_op == OP_STORE || ex_op == OP_OUT)
                          ? fw_fd
                          : fw_fb;

        // Bellek/IO adresi
        if (ex_op == OP_STORE)
            mem_addr_r <= alu_result[15:0];
        else if (ex_op == OP_LOAD)
            mem_addr_r <= alu_result[15:0];
        else if (ex_op == OP_OUT || ex_op == OP_IN)
            mem_addr_r <= alu_result[7:0];
        else
            mem_addr_r <= 16'd0;

        // CALL: R7 push
        if (ex_valid && ex_op == OP_CALL) begin
            regs[7] <= regs[7] - 64'd1;
            // mem write kombinasyonel olarak yapıldı
        end
        // RET: R7 pop
        if (ex_valid && ex_op == OP_RET) begin
            regs[7] <= regs[7] + 64'd1;
        end

        // HALT
        if (ex_valid && ex_op == OP_HALT)
            halted <= 1'b1;
        if (ex_valid && ex_op == OP_WFI) begin
            waiting_for_irq <= 1'b1;
            wfi_resume_pc   <= branch_fallthrough_addr;
        end

        // ── CSR yazma ve ERET ─────────────────────────
        if (ex_valid && ex_op == OP_CSRW) begin
            case (ex_imm[5:0])
                CSR_MEPC:     csr_mepc     <= ex_rv_fd;
                CSR_MTVEC:    csr_mtvec    <= ex_rv_fd;
                CSR_MSTATUS:  csr_mstatus  <= ex_rv_fd;
                CSR_MIE:      csr_mie      <= ex_rv_fd;
                CSR_MIP:      csr_mip      <= ex_rv_fd;
                CSR_MTIMECMP: csr_mtimecmp <= ex_rv_fd;
                default: ;
            endcase
        end
        if (ex_valid && ex_op == OP_ERET) begin
            pc_if <= csr_mepc[15:0];
            csr_mstatus[0] <= csr_mstatus[1];
            csr_mstatus[1] <= 1'b1;
            waiting_for_irq <= 1'b0;
        end

        // ────────────────────────────────────────────
        // ID→EX Geçişi (stall veya flush varsa bubble ekle)
        // ────────────────────────────────────────────
        if (flush_id_ex || !id_valid) begin
            // Bubble
            ex_valid          <= 1'b0;
            ex_op             <= OP_NOP;
            ex_fd             <= 5'd0; ex_fa <= 5'd0; ex_fb <= 5'd0;
            ex_rv_fa          <= 64'd0; ex_rv_fb <= 64'd0;
            ex_rv_fd          <= 64'd0;
            ex_imm            <= 64'd0; ex_pc <= 16'd0;
            ex_reg_write      <= 1'b0; ex_mem_read <= 1'b0;
            ex_mem_write      <= 1'b0; ex_is_branch <= 1'b0; ex_is_io <= 1'b0;
            ex_was_predicted  <= 1'b0;
            ex_pred_target_r  <= 16'd0;
        end else if (!stall) begin
            ex_valid          <= id_valid;
            ex_op             <= id_op;
            ex_fd             <= id_fd;
            ex_fa             <= id_fa;
            ex_fb             <= id_fb;
            ex_rv_fa          <= id_rfa;
            ex_rv_fb          <= id_rfb;
            ex_rv_fd          <= id_rfd;
            ex_imm            <= id_imm;
            ex_pc             <= id_pc; // mimari komut adresi; +1 fall-through'tur
            ex_reg_write      <= id_is_reg_write;
            ex_mem_read       <= id_is_mem_read;
            ex_mem_write      <= id_is_mem_write;
            ex_is_branch      <= id_is_branch;
            ex_is_io          <= id_is_io;
            // Tahmin taşı: bu dal ID'de öngörüldü mü?
            ex_was_predicted  <= predict_redirect;
            ex_pred_target_r  <= id_pred_tgt;
        end

        // ────────────────────────────────────────────
        // IF→ID Geçişi
        // ────────────────────────────────────────────
        if (flush_if_id) begin
            id_insn  <= 32'd0;
            id_pc    <= 16'd0;
            id_valid <= 1'b0;
        end else if (!stall) begin
            id_insn  <= mem_rdata[31:0]; // IF'te okunan komut
            id_pc    <= pc_if;
            id_valid <= 1'b1;
        end
        // stall: IF/ID dondur

        // ────────────────────────────────────────────
        // PC Güncelleme (Tahminli)
        // ────────────────────────────────────────────
        if (prediction_wrong) begin
            // Tahmin edilen geri dal alınmadıysa tahmin edilen hedefte
            // kalmamalı; dalın fall-through adresine dön.
            pc_if <= branch_taken ? branch_target : branch_fallthrough_addr;
        end else if (predict_redirect) begin
            // ID'deki geri dal önceden öngörüldü → hedefe erken yönlendir
            pc_if <= id_pred_tgt;
        end else if (!stall) begin
            pc_if <= pc_if + 16'd1;
        end
        // stall: PC dondur

        end // !waiting_for_irq
    end // !halted
end


// ─────────────────────────────────────────────────────────
// ID-Aşaması Tahmin Sinyalleri (kombinasyonel)
// ─────────────────────────────────────────────────────────
// Geri yönlü dal: imm bit10 = işaret biti, 1 → negatif → geri dal
wire id_is_backward  = id_is_branch && id_valid && id_raw_imm[10];
// Öngörülen hedef: id_pc + 1 + sign_ext(imm) (EX'teki hesapla birebir aynı)
wire [15:0] id_pred_tgt = id_pc + 16'd1 + {{5{id_raw_imm[10]}}, id_raw_imm};
// Yalnızca flush yokken ve stall yokken öngörü yap
// Keep control flow precise until the branch is resolved in EX.  A speculative
// redirect can leave the first fall-through instruction behind the flush edge.
wire predict_redirect = 1'b0;

// EX'te tahmin doğrulama
wire ex_pred_correct_w = ex_was_predicted && ex_valid && ex_is_branch &&
                         branch_taken && (branch_target == ex_pred_target_r);
// Tahmin edilen geri dal alınmadığında da tahmin yanlıştır.  Bu durumda
// branch_target varsayılan olarak fall-through adresini taşır; yalnızca
// alınan dallarda gerçek hedefe yönleniriz.
wire prediction_wrong = ex_valid && ex_is_branch &&
                        ((!ex_was_predicted && branch_taken) ||
                         (ex_was_predicted &&
                          (!branch_taken || branch_target != ex_pred_target_r)));

// ─────────────────────────────────────────────────────────
// Hazard Kontrol Mantığı (kombinasyonel)
// ─────────────────────────────────────────────────────────
always @(*) begin
    stall = load_use_hazard;
    // Doğru tahmin → flush yok; yanlış tahmin veya tahmin edilmemiş dal → flush
    // A taken backward branch predicted in ID still invalidates the
    // sequential instruction already sitting in IF/ID.
    flush_if_id = (prediction_wrong || predict_redirect) ? 1'b1 : 1'b0;
    flush_id_ex = (prediction_wrong || load_use_hazard) ? 1'b1 : 1'b0;
end

endmodule


// ============================================================
// Test Bench — oxalyn_cpu_tb
// Icarus Verilog:
//   iverilog -o sim_tb cpu.v -DTESTBENCH && vvp sim_tb
// ============================================================
`ifdef TESTBENCH

module oxalyn_cpu_tb;
    reg        clk, rst_n;
    wire [15:0] mem_addr;
    wire        mem_we;
    wire [63:0] mem_wdata;
    reg  [63:0] mem_rdata;
    wire [7:0]  io_addr;
    wire        io_we;
    wire [63:0] io_wdata;
    reg  [63:0] io_rdata;
    wire        halted;
    wire [63:0] cycles;

    oxalyn_cpu uut (
        .clk(clk), .rst_n(rst_n),
        .mem_addr(mem_addr), .mem_we(mem_we),
        .mem_wdata(mem_wdata), .mem_rdata(mem_rdata),
        .io_addr(io_addr), .io_we(io_we),
        .io_wdata(io_wdata), .io_rdata(io_rdata),
        .irq_external(1'b0),
        .irq_dma(1'b0),
        .uart_irq_rx(1'b0), .uart_irq_tx(1'b0),
        .halted(halted), .cycles(cycles)
    );

    reg [63:0] sim_mem [0:511];
    reg [63:0] io_ports [0:255];
    integer ii;

    // The CPU fetch/load interface is combinational.  Keep the smoke
    // testbench model aligned with the FPGA-side address/data contract;
    // a registered read here shifts every fetched instruction by one word.
    always @(*) begin
        mem_rdata = sim_mem[mem_addr[8:0]];
    end
    always @(posedge clk) begin
        if (mem_we) sim_mem[mem_addr[8:0]] <= mem_wdata;
    end

    always @(posedge clk) begin
        io_rdata <= io_ports[io_addr];
        if (io_we) begin
            io_ports[io_addr] <= io_wdata;
        end
    end

    initial clk = 0;
    always #5 clk = ~clk;

    // Komut kodlama yardımcısı
    function [31:0] enc;
        input [5:0] op; input [4:0] d, a, b; input [10:0] imm;
        enc = {op, d, a, b, imm};
    endfunction

    localparam OP_ADD=6'h01, OP_SUB=6'h02, OP_LI=6'h0A, OP_JNZ=6'h0D,
               OP_OUT=6'h10, OP_HALT=6'h3F, OP_CMPEQ=6'h22, OP_BSET=6'h28;

    initial begin
        for (ii = 0; ii < 512; ii = ii + 1) sim_mem[ii] = 64'd0;
        for (ii = 0; ii < 256; ii = ii + 1) io_ports[ii] = 64'd0;

        // Test 1: 1+2+...+10 = 55
        // LI R1,1  LI R2,11  LI R3,0  LI R4,1
        // loop: ADD R3,R3,R1  ADD R1,R1,R4  SUB R5,R1,R2  JNZ R5,-4
        // OUT R3,0  HALT
        sim_mem[0]  = {32'd0, enc(OP_LI,  5'd1, 5'd0, 5'd0, 11'd1)};
        sim_mem[1]  = {32'd0, enc(OP_LI,  5'd2, 5'd0, 5'd0, 11'd11)};
        sim_mem[2]  = {32'd0, enc(OP_LI,  5'd3, 5'd0, 5'd0, 11'd0)};
        sim_mem[3]  = {32'd0, enc(OP_LI,  5'd4, 5'd0, 5'd0, 11'd1)};
        sim_mem[4]  = {32'd0, enc(OP_ADD, 5'd3, 5'd3, 5'd1, 11'd0)};
        sim_mem[5]  = {32'd0, enc(OP_ADD, 5'd1, 5'd1, 5'd4, 11'd0)};
        sim_mem[6]  = {32'd0, enc(OP_SUB, 5'd5, 5'd1, 5'd2, 11'd0)};
        sim_mem[7]  = {32'd0, enc(OP_JNZ, 5'd5, 5'd0, 5'd0, 11'h7FC)}; // -4
        sim_mem[8]  = {32'd0, enc(OP_OUT, 5'd3, 5'd0, 5'd0, 11'd0)};
        sim_mem[9]  = {32'd0, enc(OP_HALT,5'd0, 5'd0, 5'd0, 11'd0)};

        rst_n = 0; #20; rst_n = 1;

        for (ii = 0; ii < 200; ii = ii + 1) begin
            @(posedge clk);
            if (halted) begin
                #10;
                $display("─────────────────────────────────");
                $display("Oxalyn-64 5-Aşamalı Pipeline Testi");
                $display("Cycles  : %0d", cycles);
                $display("port[0] : %0d (beklenen: 55)", io_ports[0]);
                if (io_ports[0] == 64'd55)
                    $display("✓ TEST GEÇTİ");
                else
                    $display("✗ TEST BAŞARISIZ");
                $display("─────────────────────────────────");
                $finish;
            end
        end
        $display("ZAMAN AŞIMI"); $finish;
end
endmodule

`endif
