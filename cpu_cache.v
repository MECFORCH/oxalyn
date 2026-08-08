// ============================================================
// Oxalyn-64 L1 Cache — Direct-Mapped, Write-Through
//
// İki ayrı önbellek:
//   I-Cache : 128-satır × 64-bit (komutlar için)
//   D-Cache : 128-satır × 64-bit (veri için)
//
// Her ikisi de direct-mapped, write-through politikası.
// Hit → 0 ekstra gecikme  (pipeline stall yok)
// Miss → 1 ekstra gecikme (1 bubble ekler, pipeline'a stall sinyali)
//
// Bu modül oxalyn_cpu'nun bellek arayüzüne araya girer:
//   CPU ↔ Cache ↔ SRAM/Block-RAM
//
// Parametreler:
//   CACHE_LINES : satır sayısı (2'nin kuvveti, varsayılan 128)
//   INDEX_BITS  : log2(CACHE_LINES) = 7
//   TAG_BITS    : 16 - INDEX_BITS = 9
// ============================================================
`timescale 1ns / 1ps

module oxalyn_icache #(
    parameter LINES      = 512,
    parameter INDEX_BITS = 9,
    parameter TAG_BITS   = 7
)(
    input  wire        clk,
    input  wire        rst_n,
    // CPU tarafı
    input  wire [15:0] req_addr,    // istenen word adresi
    input  wire        req_valid,   // istek geçerli
    output reg  [63:0] rdata,       // okunan veri
    output reg         hit,         // önbellekte var
    output reg         stall,       // CPU'yu beklet (miss)
    // Bellek tarafı
    output reg  [15:0] mem_addr,
    input  wire [63:0] mem_rdata,
    input  wire        mem_ack      // bellek verisi hazır
);
    // ── Önbellek Dizileri ────────────────────────────────
    reg [63:0]           cache_data [0:LINES-1];
    reg [TAG_BITS-1:0]   cache_tag  [0:LINES-1];
    reg                  cache_valid[0:LINES-1];

    wire [INDEX_BITS-1:0] idx = req_addr[INDEX_BITS-1:0];
    wire [TAG_BITS-1:0]   tag = req_addr[15:INDEX_BITS];

    wire tag_match = cache_valid[idx] && (cache_tag[idx] == tag);

    integer ii;
    reg miss_pending;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (ii = 0; ii < LINES; ii = ii + 1) begin
                cache_valid[ii] <= 1'b0;
                cache_tag[ii]   <= {TAG_BITS{1'b0}};
                cache_data[ii]  <= 64'd0;
            end
            hit          <= 1'b0;
            stall        <= 1'b0;
            rdata        <= 64'd0;
            mem_addr     <= 16'd0;
            miss_pending <= 1'b0;
        end else begin
            if (req_valid) begin
                if (tag_match) begin
                    // Hit
                    rdata        <= cache_data[idx];
                    hit          <= 1'b1;
                    stall        <= 1'b0;
                    miss_pending <= 1'b0;
                end else if (!miss_pending) begin
                    // Miss — belleğe iste
                    hit          <= 1'b0;
                    stall        <= 1'b1;
                    mem_addr     <= req_addr;
                    miss_pending <= 1'b1;
                end else if (miss_pending && mem_ack) begin
                    // Bellek cevap verdi — satırı yükle
                    cache_data[idx]  <= mem_rdata;
                    cache_tag[idx]   <= tag;
                    cache_valid[idx] <= 1'b1;
                    rdata            <= mem_rdata;
                    hit              <= 1'b1;
                    stall            <= 1'b0;
                    miss_pending     <= 1'b0;
                end
            end else begin
                hit   <= 1'b0;
                stall <= 1'b0;
            end
        end
    end
endmodule


module oxalyn_dcache #(
    parameter LINES      = 512,
    parameter INDEX_BITS = 9,
    parameter TAG_BITS   = 7
)(
    input  wire        clk,
    input  wire        rst_n,
    // CPU tarafı
    input  wire [15:0] req_addr,
    input  wire        req_valid,
    input  wire        req_we,      // yazma isteği
    input  wire [63:0] wdata,       // yazılacak veri
    output reg  [63:0] rdata,
    output reg         hit,
    output reg         stall,
    // Bellek tarafı — write-through
    output reg  [15:0] mem_addr,
    output reg         mem_we,
    output reg  [63:0] mem_wdata,
    input  wire [63:0] mem_rdata,
    input  wire        mem_ack
);
    reg [63:0]           cache_data [0:LINES-1];
    reg [TAG_BITS-1:0]   cache_tag  [0:LINES-1];
    reg                  cache_valid[0:LINES-1];

    wire [INDEX_BITS-1:0] idx = req_addr[INDEX_BITS-1:0];
    wire [TAG_BITS-1:0]   tag = req_addr[15:INDEX_BITS];
    wire tag_match = cache_valid[idx] && (cache_tag[idx] == tag);

    integer ii;
    reg miss_pending;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (ii = 0; ii < LINES; ii = ii + 1) begin
                cache_valid[ii] <= 1'b0;
                cache_tag[ii]   <= {TAG_BITS{1'b0}};
                cache_data[ii]  <= 64'd0;
            end
            hit <= 1'b0; stall <= 1'b0; rdata <= 64'd0;
            mem_addr <= 16'd0; mem_we <= 1'b0; mem_wdata <= 64'd0;
            miss_pending <= 1'b0;
        end else begin
            mem_we <= 1'b0; // varsayılan

            if (req_valid) begin
                if (req_we) begin
                    // STORE: write-through → her zaman belleğe yaz
                    if (tag_match) cache_data[idx] <= wdata; // önbellekte güncelle
                    mem_addr  <= req_addr;
                    mem_we    <= 1'b1;
                    mem_wdata <= wdata;
                    hit       <= 1'b1;
                    stall     <= 1'b0;
                end else begin
                    // LOAD
                    if (tag_match) begin
                        rdata        <= cache_data[idx];
                        hit          <= 1'b1;
                        stall        <= 1'b0;
                        miss_pending <= 1'b0;
                    end else if (!miss_pending) begin
                        hit          <= 1'b0;
                        stall        <= 1'b1;
                        mem_addr     <= req_addr;
                        miss_pending <= 1'b1;
                    end else if (miss_pending && mem_ack) begin
                        cache_data[idx]  <= mem_rdata;
                        cache_tag[idx]   <= tag;
                        cache_valid[idx] <= 1'b1;
                        rdata            <= mem_rdata;
                        hit              <= 1'b1;
                        stall            <= 1'b0;
                        miss_pending     <= 1'b0;
                    end
                end
            end else begin
                hit <= 1'b0; stall <= 1'b0;
            end
        end
    end
endmodule


// ============================================================
// Cache Controller — CPU ile SRAM arasında arabulucu
// I-Cache + D-Cache birleştirilmiş arayüz
// (tek portlu SRAM için round-robin arbiter)
// ============================================================
module oxalyn_cache_ctrl (
    input  wire        clk,
    input  wire        rst_n,

    // CPU I-side (fetch)
    input  wire [15:0] if_addr,
    input  wire        if_req,
    output wire [63:0] if_rdata,
    output wire        if_stall,

    // CPU D-side (load/store)
    input  wire [15:0] d_addr,
    input  wire        d_req,
    input  wire        d_we,
    input  wire [63:0] d_wdata,
    output wire [63:0] d_rdata,
    output wire        d_stall,

    // SRAM
    output reg  [15:0] sram_addr,
    output reg         sram_we,
    output reg  [63:0] sram_wdata,
    input  wire [63:0] sram_rdata
);
    // Basit: her iki cache aynı SRAM portunu paylaşır.
    // D-cache öncelikli, I-cache miss'leri sonrasında.
    wire        ic_stall, dc_stall;
    wire [15:0] ic_mem_addr, dc_mem_addr;
    wire        dc_mem_we;
    wire [63:0] dc_mem_wdata;

    // SRAM ack: tek döngülü (kombinasyonel SRAM modeli)
    wire sram_ack = 1'b1;

    oxalyn_icache ic (
        .clk(clk), .rst_n(rst_n),
        .req_addr(if_addr), .req_valid(if_req),
        .rdata(if_rdata), .hit(), .stall(ic_stall),
        .mem_addr(ic_mem_addr), .mem_rdata(sram_rdata), .mem_ack(sram_ack)
    );

    oxalyn_dcache dc (
        .clk(clk), .rst_n(rst_n),
        .req_addr(d_addr), .req_valid(d_req), .req_we(d_we),
        .wdata(d_wdata), .rdata(d_rdata), .hit(), .stall(dc_stall),
        .mem_addr(dc_mem_addr), .mem_we(dc_mem_we), .mem_wdata(dc_mem_wdata),
        .mem_rdata(sram_rdata), .mem_ack(sram_ack)
    );

    assign if_stall = ic_stall;
    assign d_stall  = dc_stall;

    // SRAM mux: D-cache öncelikli
    always @(*) begin
        if (d_req) begin
            sram_addr  = dc_mem_addr;
            sram_we    = dc_mem_we;
            sram_wdata = dc_mem_wdata;
        end else begin
            sram_addr  = ic_mem_addr;
            sram_we    = 1'b0;
            sram_wdata = 64'd0;
        end
    end
endmodule
