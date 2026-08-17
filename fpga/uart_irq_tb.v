`timescale 1ns / 1ps

// UART RX/TX seviyeli kesmelerinin CPU trap yoluna ulaştığını doğrular.
module uart_irq_tb;
    reg clk = 1'b0;
    reg rst_n = 1'b0;
    reg irq_external = 1'b0;
    reg uart_irq_rx = 1'b0;
    reg uart_irq_tx = 1'b0;

    wire [15:0] mem_addr;
    wire        mem_we;
    wire [63:0] mem_wdata;
    reg  [63:0] mem_rdata = 64'd0;
    wire [7:0]  io_addr;
    wire        io_we;
    wire [63:0] io_wdata;
    reg  [63:0] io_rdata = 64'd0;
    wire        halted;
    wire [63:0] cycles;
    integer rx_seen;
    integer tx_seen;

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
        .uart_irq_rx(uart_irq_rx),
        .uart_irq_tx(uart_irq_tx),
        .halted(halted),
        .cycles(cycles)
    );

    always #5 clk = ~clk;

    initial begin
        #12 rst_n = 1'b1;

        // RX: MIE bit2 + global MIE, then assert RX level.
        dut.csr_mtvec = 64'd20;
        dut.csr_mie = 64'h4;
        dut.csr_mstatus = 64'h1;
        uart_irq_rx = 1'b1;
        rx_seen = 0;
        repeat (8) begin
            @(posedge clk);
            #1;
            if (dut.csr_mcause === 64'h0000_0000_8000_0002)
                rx_seen = 1;
        end
        if (!rx_seen || dut.csr_mcause !== 64'h0000_0000_8000_0002) begin
            $display("FAIL: UART RX mcause=%h pc=%0d",
                     dut.csr_mcause, dut.pc_if);
            $finish(1);
        end

        // TX: return from the first trap, then assert only TX.
        uart_irq_rx = 1'b0;
        dut.csr_mstatus = 64'h1;
        dut.csr_mie = 64'h8;
        uart_irq_tx = 1'b1;
        dut.csr_mcause = 64'd0;
        tx_seen = 0;
        repeat (8) begin
            @(posedge clk);
            #1;
            if (dut.csr_mcause === 64'h0000_0000_8000_0003)
                tx_seen = 1;
        end
        if (!tx_seen || dut.csr_mcause !== 64'h0000_0000_8000_0003) begin
            $display("FAIL: UART TX mcause=%h pc=%0d",
                     dut.csr_mcause, dut.pc_if);
            $finish(1);
        end

        $display("PASS: UART RX/TX IRQ trap yolu doğrulandı");
        $finish;
    end
endmodule