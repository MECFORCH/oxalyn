`timescale 1ns / 1ps

// GPU interrupt regression:
//   external/frame IRQ -> MCAUSE 0x80000004
//   DMA completion IRQ  -> MCAUSE 0x80000005
// The handler writes both the cause and a visible completion marker.
module gpu_interrupt_test;
    reg clk = 1'b0;
    reg rst_n = 1'b0;
    reg irq_external = 1'b0;
    reg irq_dma = 1'b0;

    wire [15:0] mem_addr;
    wire mem_we;
    wire [63:0] mem_wdata;
    reg [63:0] mem_rdata;
    wire [7:0] io_addr;
    wire io_we;
    wire [63:0] io_wdata;
    reg [63:0] io_rdata;
    wire halted;
    wire [63:0] cycles;

    reg [63:0] sim_mem [0:255];
    reg [63:0] io_ports [0:255];
    integer i;
    integer frame_seen;
    integer dma_seen;

    localparam OP_LI = 6'h0A;
    localparam OP_OUT = 6'h10;
    localparam OP_CSRR = 6'h15;
    localparam OP_ERET = 6'h13;

    function [31:0] enc;
        input [5:0] op;
        input [4:0] d;
        input [4:0] a;
        input [4:0] b;
        input [10:0] imm;
        begin enc = {op, d, a, b, imm}; end
    endfunction

    oxalyn_cpu dut (
        .clk(clk), .rst_n(rst_n),
        .mem_addr(mem_addr), .mem_we(mem_we),
        .mem_wdata(mem_wdata), .mem_rdata(mem_rdata),
        .io_addr(io_addr), .io_we(io_we),
        .io_wdata(io_wdata), .io_rdata(io_rdata),
        .irq_external(irq_external), .irq_dma(irq_dma),
        .uart_irq_rx(1'b0), .uart_irq_tx(1'b0),
        .halted(halted), .cycles(cycles)
    );

    always #5 clk = ~clk;

    always @(*) begin
        mem_rdata = sim_mem[mem_addr];
        io_rdata = io_ports[io_addr];
    end

    always @(posedge clk) begin
        if (mem_we) sim_mem[mem_addr] <= mem_wdata;
        if (io_we) begin
            io_ports[io_addr] <= io_wdata;
            if (io_addr == 8'd0 && io_wdata == 64'd4) frame_seen = 1;
            if (io_addr == 8'd0 && io_wdata == 64'd5) dma_seen = 1;
        end
    end

    initial begin
        for (i = 0; i < 256; i = i + 1) begin
            sim_mem[i] = 64'd0;
            io_ports[i] = 64'd0;
        end

        // Handler: output MCAUSE to port 2, then output a cause-specific
        // marker to port 0 and return.  Main memory is intentionally NOPs.
        sim_mem[20] = {32'd0, enc(OP_CSRR, 5'd1, 5'd0, 5'd0, 11'd2)};
        sim_mem[21] = {32'd0, enc(OP_OUT,  5'd1, 5'd0, 5'd0, 11'd2)};
        sim_mem[22] = {32'd0, enc(OP_LI,   5'd2, 5'd0, 5'd0, 11'd4)};
        sim_mem[23] = {32'd0, enc(OP_OUT,  5'd2, 5'd0, 5'd0, 11'd0)};
        sim_mem[24] = {32'd0, enc(OP_ERET, 5'd0, 5'd0, 5'd0, 11'd0)};
        sim_mem[25] = {32'd0, enc(OP_CSRR, 5'd1, 5'd0, 5'd0, 11'd2)};
        sim_mem[26] = {32'd0, enc(OP_OUT,  5'd1, 5'd0, 5'd0, 11'd2)};
        sim_mem[27] = {32'd0, enc(OP_LI,   5'd2, 5'd0, 5'd0, 11'd5)};
        sim_mem[28] = {32'd0, enc(OP_OUT,  5'd2, 5'd0, 5'd0, 11'd0)};
        sim_mem[29] = {32'd0, enc(OP_ERET, 5'd0, 5'd0, 5'd0, 11'd0)};

        frame_seen = 0;
        dma_seen = 0;
        #12 rst_n = 1'b1;
        dut.csr_mtvec = 64'd20;

        // Frame/present IRQ uses external cause 4.
        dut.csr_mie = 64'h2;
        dut.csr_mstatus = 64'h1;
        irq_external = 1'b1;
        wait (dut.csr_mcause === 64'h0000_0000_8000_0004);
        irq_external = 1'b0;
        repeat (12) @(posedge clk);
        if (io_ports[2] !== 64'h0000_0000_8000_0004 ||
            !frame_seen) begin
            $display("FAIL: frame IRQ handler mcause=%h marker=%0d",
                     io_ports[2], frame_seen);
            $finish(1);
        end

        // DMA IRQ uses the dedicated cause 5 and handler marker.
        dut.csr_mcause = 64'd0;
        dut.csr_mtvec = 64'd25;
        dut.csr_mie = 64'h10;
        dut.csr_mstatus = 64'h1;
        irq_dma = 1'b1;
        wait (dut.csr_mcause === 64'h0000_0000_8000_0005);
        irq_dma = 1'b0;
        repeat (16) @(posedge clk);
        if (io_ports[2] !== 64'h0000_0000_8000_0005 ||
            !dma_seen) begin
            $display("FAIL: DMA IRQ handler mcause=%h marker=%0d",
                     io_ports[2], dma_seen);
            $finish(1);
        end

        $display("PASS: GPU frame IRQ mcause=0x80000004, DMA IRQ mcause=0x80000005");
        $finish;
    end
endmodule