// ============================================================
// Oxalyn-64 FPGA Üst Modülü — Xilinx Basys3 (Artix-7 XC7A35T)
//
// Donanım haritası:
//   Saat     : 100 MHz (W5)
//   Reset    : BTNC (U18) — aktif-yüksek, CPU için aktif-düşük çevrilir
//   LED[15:0]: port[0] çıkışının alt 16 biti — hesaplama sonucunu gösterir
//   SW[15:0] : port[1] girişi — runtime veri girişi (64-bit portun alt yarısı)
//   7-Seg    : port[0] değerinin alt 16 biti hex olarak gösterilir
//   LED[15]  : CPU halted göstergesi (yanıp söner)
//   VGA      : Gravityon GPU framebuffer çıkışı (800×600)
//
// Gravityon GPU I/O port aralığı: 0xE0–0xFF
//   GPU, Oxalyn-64 CPU I/O bus'ına bağlı ayrı bir modül olarak çalışır.
//   CPU → OUT port_addr, reg  →  gpu port_wr + port_din
//   CPU → IN  reg, port_addr  →  gpu port_rd → port_dout → io_rdata
// ============================================================

module oxalyn_top (
    // ── Saat / Reset ────────────────────────────────────
    input  wire        clk_100mhz,   // W5  — 100 MHz sistem saati
    input  wire        btnC,         // U18 — merkez buton (reset)

    // ── LED'ler ─────────────────────────────────────────
    output wire [15:0] led,          // U16..L1

    // ── Slide Switchler ──────────────────────────────────
    input  wire [15:0] sw,           // V17..R2

    // ── 7-Segment Display ────────────────────────────────
    output wire [6:0]  seg,          // CA..CG
    output wire        dp,           // ondalık nokta
    output wire [3:0]  an,           // AN0..AN3 (aktif-düşük)

    // ── UART (USB-UART köprüsü, Basys3: RX=B18, TX=A18) ──
    output wire        uart_tx,      // FPGA → PC
    input  wire        uart_rx,      // PC → FPGA

    // ── VGA Çıkışı (Gravityon GPU) ──────────────────────
    output wire        vga_hsync,    // yatay sync
    output wire        vga_vsync,    // dikey sync
    output wire [3:0]  vga_r,        // kırmızı [3:0]
    output wire [3:0]  vga_g,        // yeşil   [3:0]
    output wire [3:0]  vga_b         // mavi    [3:0]
);

    // ─── Sıfırlama ────────────────────────────────────────
    reg [1:0] rst_sync;
    always @(posedge clk_100mhz) begin
        rst_sync <= {rst_sync[0], btnC};
    end
    wire rst_n = ~rst_sync[1];

    // ─── CPU ↔ Bellek Sinyalleri ──────────────────────────
    wire [15:0] mem_addr;
    wire        mem_we;
    wire [63:0] mem_wdata;
    wire [63:0] mem_rdata;

    // ─── CPU ↔ G/Ç Sinyalleri ────────────────────────────
    wire [7:0]  io_addr;
    wire        io_we;
    wire [63:0] io_wdata;
    reg  [63:0] io_rdata;

    // ─── CPU Durum ────────────────────────────────────────
    wire        halted;
    wire [63:0] cycles;

    // ─── Oxalyn-64 CPU Örneği ───────────────────────────────
    oxalyn_cpu cpu (
        .clk      (clk_100mhz),
        .rst_n    (rst_n),
        .mem_addr (mem_addr),
        .mem_we   (mem_we),
        .mem_wdata(mem_wdata),
        .mem_rdata(mem_rdata),
        .io_addr  (io_addr),
        .io_we    (io_we),
        .io_wdata (io_wdata),
        .io_rdata (io_rdata),
        .halted   (halted),
        .cycles   (cycles)
    );

    // ─── Block RAM ────────────────────────────────────────
    oxalyn_bram bram (
        .clk  (clk_100mhz),
        .addr (mem_addr),
        .we   (mem_we),
        .wdata(mem_wdata),
        .rdata(mem_rdata)
    );

    // ─── UART Çevre Birimi ─────────────────────────────────
    wire [63:0] uart_rdata;
    wire        uart_sel;

    oxalyn_uart #(
        .CLK_HZ (100_000_000),
        .BAUD   (115200)
    ) uart (
        .clk       (clk_100mhz),
        .rst_n     (rst_n),
        .io_addr   (io_addr),
        .io_we     (io_we),
        .io_wdata  (io_wdata),
        .uart_rdata(uart_rdata),
        .uart_sel  (uart_sel),
        .uart_tx   (uart_tx),
        .uart_rx   (uart_rx)
    );

    // ─── Gravityon GPU Çekirdeği ──────────────────────────
    // Port aralığı: 0xE0–0xFF
    wire        gpu_sel    = (io_addr >= 8'hE0);
    wire        gpu_port_wr = io_we  && gpu_sel;
    wire        gpu_port_rd = (!io_we) && gpu_sel;
    wire [63:0] gpu_rdata;

    // GPU ↔ BRAM DMA arayüzü
    wire        gpu_ram_req;
    wire        gpu_ram_wr;
    wire [31:0] gpu_ram_addr;
    wire [63:0] gpu_ram_wdata;
    reg  [63:0] gpu_ram_rdata;
    reg         gpu_ram_ack;

    // GPU → CPU IRQ
    wire        gpu_irq;

    gravityon_gpu_core #(
        .SCREEN_W (800),
        .SCREEN_H (600),
        .CLK_MHZ  (100)
    ) gpu (
        .clk        (clk_100mhz),
        .rst_n      (rst_n),
        // CPU I/O port arayüzü
        .port_wr    (gpu_port_wr),
        .port_rd    (gpu_port_rd),
        .port_addr  (io_addr),
        .port_din   (io_wdata),
        .port_dout  (gpu_rdata),
        // DMA → BRAM
        .ram_req    (gpu_ram_req),
        .ram_wr     (gpu_ram_wr),
        .ram_addr   (gpu_ram_addr),
        .ram_wdata  (gpu_ram_wdata),
        .ram_rdata  (gpu_ram_rdata),
        .ram_ack    (gpu_ram_ack),
        // VGA
        .vga_hsync  (vga_hsync),
        .vga_vsync  (vga_vsync),
        .vga_r      (vga_r),
        .vga_g      (vga_g),
        .vga_b      (vga_b),
        // IRQ
        .irq_out    (gpu_irq),
        // 7-seg debug
        .seg        (),
        .an         ()
    );

    // ─── GPU DMA ↔ BRAM Arası Köprü ─────────────────────
    // GPU BRAM'i Oxalyn-64 ana belleğiyle paylaşır.
    // Basit arbiter: GPU DMA isteğinde bulunduğunda
    // BRAM adres/veri yolunu GPU'ya verir.
    // NOT: Bu basit implementasyonda CPU erişimi ile çakışma
    // kontrolü yoktur. Tam arbiter için ayrı bir iki portlu
    // BRAM veya öncelik mantığı kullanılmalıdır.
    always @(posedge clk_100mhz or negedge rst_n) begin
        if (!rst_n) begin
            gpu_ram_rdata <= 64'd0;
            gpu_ram_ack   <= 1'b0;
        end else if (gpu_ram_req) begin
            // BRAM'den oku (tek döngü gecikme)
            // gpu_ram_addr[15:0] word adresidir
            gpu_ram_rdata <= mem_rdata;      // BRAM çıkışı bir döngü geciktirilmiş
            gpu_ram_ack   <= 1'b1;
        end else begin
            gpu_ram_ack   <= 1'b0;
        end
    end

    // ─── GPU IRQ → MIP.EXT ────────────────────────────────
    // GPU irq_out → Oxalyn-64 harici kesme girişi
    // (gerçek implementasyonda cpu.v'ye IRQ girişi eklenmeli)
    // Şimdilik LED[14]'e bağla (görsel debug)
    wire gpu_irq_latched;
    reg  gpu_irq_r;
    always @(posedge clk_100mhz or negedge rst_n) begin
        if (!rst_n) gpu_irq_r <= 1'b0;
        else        gpu_irq_r <= gpu_irq;
    end
    assign gpu_irq_latched = gpu_irq_r;

    // ─── G/Ç Port Registerları ────────────────────────────
    reg [63:0] port0_out;

    always @(posedge clk_100mhz or negedge rst_n) begin
        if (!rst_n) begin
            port0_out <= 64'd0;
            io_rdata  <= 64'd0;
        end else begin
            if (io_we && io_addr == 8'd0)
                port0_out <= io_wdata;

            // Port okuma mux
            // Öncelik: GPU portları > UART > genel portlar
            if (gpu_sel) begin
                io_rdata <= gpu_rdata;
            end else if (uart_sel) begin
                io_rdata <= uart_rdata;
            end else begin
                case (io_addr)
                    8'd0:    io_rdata <= port0_out;
                    8'd1:    io_rdata <= {48'd0, sw};
                    default: io_rdata <= 64'd0;
                endcase
            end
        end
    end

    // ─── LED Sürücüsü ────────────────────────────────────
    reg [24:0] blink_ctr;
    always @(posedge clk_100mhz or negedge rst_n) begin
        if (!rst_n) blink_ctr <= 25'd0;
        else        blink_ctr <= blink_ctr + 25'd1;
    end
    wire blink = blink_ctr[24];

    assign led[13:0] = port0_out[13:0];
    assign led[14]   = gpu_irq_latched;   // GPU IRQ göstergesi
    assign led[15]   = halted ? blink : 1'b0;

    // ─── 7-Segment Display ────────────────────────────────
    seg7_ctrl seg7 (
        .clk  (clk_100mhz),
        .rst_n(rst_n),
        .value(port0_out[15:0]),
        .seg  (seg),
        .an   (an),
        .dp   (dp)
    );

endmodule
