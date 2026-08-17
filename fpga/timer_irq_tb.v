`timescale 1ns / 1ps

// Timer kesmesi için küçük, harici bağımlılığı olmayan RTL testi.
// Kullanım:
//   iverilog -g2012 -s timer_irq_tb -o /tmp/timer_irq_tb \
//       ../cpu.v timer_irq_tb.v && vvp /tmp/timer_irq_tb
module timer_irq_tb;
    reg clk = 1'b0;
    reg rst_n = 1'b0;
    reg irq_external = 1'b0;

    wire [15:0] mem_addr;
    wire        mem_we;
    wire [63:0] mem_wdata;
    reg  [63:0] mem_rdata;
    wire [7:0]  io_addr;
    wire        io_we;
    wire [63:0] io_wdata;
    reg  [63:0] io_rdata = 64'd0;
    wire        halted;
    wire [63:0] cycles;

    oxalyn_cpu dut (
        .clk(clk),
        .rst_n(rst_n),
        .mem_addr(mem_addr),
        .mem_we(mem_we),
        .mem_wdata(mem_wdata),
        .mem_rdata(mem_rdata),
        .io_addr(io_addr),
        .io_we(io_we),
        .io_wdata(io_wdata),
        .io_rdata(io_rdata),
        .irq_external(irq_external),
        .irq_dma(1'b0),
        .uart_irq_rx(1'b0),
        .uart_irq_tx(1'b0),
        .halted(halted),
        .cycles(cycles)
    );

    reg [63:0] mem [0:255];
    integer i;
    integer trap_seen;
    reg [15:0] trap_pc;
    reg [63:0] trap_mepc;

    always @(*) begin
        mem_rdata = mem[mem_addr];
    end

    always #5 clk = ~clk;

    initial begin
        for (i = 0; i < 256; i = i + 1)
            mem[i] = 64'd0;

        trap_seen = 0;
        trap_pc = 16'd0;
        trap_mepc = 64'd0;

        #12 rst_n = 1'b1;

        // CSR yazma pipeline'ından bağımsız olarak timer durumunu hazırla.
        dut.csr_mtvec = 64'd20;
        dut.csr_mtimecmp = 64'd6;
        dut.csr_mie = 64'd1;
        dut.csr_mstatus = 64'd1;

        repeat (30) begin
            @(posedge clk);
            #1;
            if (!trap_seen &&
                dut.csr_mcause === 64'h0000_0000_8000_0001) begin
                trap_seen = 1;
                trap_pc = dut.pc_if;
                trap_mepc = dut.csr_mepc;
            end
        end

        if (!trap_seen) begin
            $display("FAIL: timer trap alınmadı, mcause=%h pc=%h cycles=%0d",
                     dut.csr_mcause, dut.pc_if, cycles);
            $finish(1);
        end
        if (trap_pc !== 16'd20) begin
            $display("FAIL: trap PC=%0d, beklenen 20", trap_pc);
            $finish(1);
        end
        if (trap_mepc !== 64'd6) begin
            $display("FAIL: MEPC=%0d, beklenen 6", trap_mepc);
            $finish(1);
        end
        if (dut.csr_mstatus[0] !== 1'b0) begin
            $display("FAIL: MSTATUS.MIE trap sonrasında hâlâ set");
            $finish(1);
        end

        $display("PASS: timer IRQ mcause=%h pc=%0d mepc=%0d cycles=%0d",
                 dut.csr_mcause, trap_pc, trap_mepc, cycles);
        $finish;
    end
endmodule