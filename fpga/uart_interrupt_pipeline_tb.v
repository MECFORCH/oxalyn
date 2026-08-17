`timescale 1ns / 1ps

// End-to-end UART RX interrupt regression:
// WFI -> UART RX IRQ -> handler OUT/CSRR -> ERET ->
// LI R1,9 -> OUT(R1), plus a STORE using the same Fd source field.
module uart_interrupt_pipeline_tb;
    reg clk = 1'b0;
    reg rst_n = 1'b0;
    reg irq_external = 1'b0;
    reg uart_irq_rx = 1'b0;
    reg uart_irq_tx = 1'b0;

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

    reg [63:0] sim_mem [0:255];
    reg [63:0] io_ports [0:255];
    integer i;
    integer handler_seen;

    localparam OP_LI   = 6'h0A;
    localparam OP_STORE= 6'h09;
    localparam OP_OUT  = 6'h10;
    localparam OP_IN   = 6'h11;
    localparam OP_WFI  = 6'h1F;
    localparam OP_ERET = 6'h13;
    localparam OP_CSRW = 6'h14;
    localparam OP_CSRR = 6'h15;
    localparam OP_HALT = 6'h3F;

    function [31:0] enc;
        input [5:0] op;
        input [4:0] d;
        input [4:0] a;
        input [4:0] b;
        input [10:0] imm;
        begin
            enc = {op, d, a, b, imm};
        end
    endfunction

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

    // The CPU's RTL interface is a combinational read port in this test.
    always @(*) begin
        mem_rdata = sim_mem[mem_addr];
        io_rdata  = io_ports[io_addr];
    end

    always @(posedge clk) begin
        if (mem_we)
            sim_mem[mem_addr] <= mem_wdata;
        if (io_we) begin
            io_ports[io_addr] <= io_wdata;
            if (io_addr == 8'd1)
                handler_seen = 1;
            // Drop the level after the handler's marker write so ERET can
            // return to the WFI resume path without taking the same IRQ again.
            if (io_addr == 8'd1)
                uart_irq_rx <= 1'b0;
        end
    end

    initial begin
        for (i = 0; i < 256; i = i + 1) begin
            sim_mem[i] = 64'd0;
            io_ports[i] = 64'd0;
        end
        handler_seen = 0;

        // Main program.  The testbench primes CSRs below so this isolates
        // WFI/IRQ/ERET from the separate LI->CSRW setup hazard.
        // WFI resumes at instruction 1.
        sim_mem[0] = {32'd0, enc(OP_WFI,   5'd0, 5'd0, 5'd0, 11'd0)};
        sim_mem[1] = {32'd0, enc(OP_LI,    5'd1, 5'd0, 5'd0, 11'd9)};
        sim_mem[2] = {32'd0, enc(OP_OUT,   5'd1, 5'd0, 5'd0, 11'd0)};
        // One independent instruction forces the delayed MEM/WB source path.
        sim_mem[3] = {32'd0, enc(OP_LI,    5'd4, 5'd0, 5'd0, 11'd0)};
        sim_mem[4] = {32'd0, enc(OP_LI,    5'd3, 5'd0, 5'd0, 11'd64)};
        sim_mem[5] = {32'd0, enc(OP_STORE, 5'd1, 5'd3, 5'd0, 11'd0)};
        sim_mem[6] = {32'd0, enc(OP_HALT,  5'd0, 5'd0, 5'd0, 11'd0)};

        // UART RX handler at MTVEC=20.
        sim_mem[20]= {32'd0, enc(OP_LI,   5'd1, 5'd0, 5'd0, 11'd1)};
        sim_mem[21]= {32'd0, enc(OP_OUT,  5'd1, 5'd0, 5'd0, 11'd1)};
        sim_mem[22]= {32'd0, enc(OP_CSRR, 5'd2, 5'd0, 5'd0, 11'd2)};
        sim_mem[23]= {32'd0, enc(OP_OUT,  5'd2, 5'd0, 5'd0, 11'd2)};
        sim_mem[24]= {32'd0, enc(OP_ERET, 5'd0, 5'd0, 5'd0, 11'd0)};

        #12 rst_n = 1'b1;
        dut.csr_mtvec = 64'd20;
        dut.csr_mie = 64'h4;
        dut.csr_mstatus = 64'h1;
        // Let WFI retire before asserting the level-triggered RX IRQ.
        repeat (6) @(posedge clk);
        uart_irq_rx = 1'b1;

        repeat (160) begin
            @(posedge clk);
            if (halted) begin
                #1;
                if (!handler_seen) begin
                    $display("FAIL: UART handler OUT yazısı görülmedi");
                    $finish(1);
                end
                if (io_ports[1] !== 64'd1) begin
                    $display("FAIL: handler port[1]=%0d, beklenen 1", io_ports[1]);
                    $finish(1);
                end
                if (io_ports[2] !== 64'h0000_0000_8000_0002) begin
                    $display("FAIL: handler MCAUSE port[2]=%h",
                             io_ports[2]);
                    $finish(1);
                end
                if (io_ports[0] !== 64'd9) begin
                    $display("FAIL: ERET sonrası OUT port[0]=%0d, beklenen 9",
                             io_ports[0]);
                    $finish(1);
                end
                if (sim_mem[64] !== 64'd9) begin
                    $display("FAIL: ERET sonrası STORE mem[64]=%0d, beklenen 9",
                             sim_mem[64]);
                    $finish(1);
                end
                $display("PASS: WFI -> UART IRQ -> ISR OUT -> ERET -> LI/OUT/STORE");
                $finish;
            end
        end
        $display("FAIL: UART interrupt pipeline testi zaman aşımına uğradı");
        $finish(1);
    end
endmodule