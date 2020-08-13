module MTwister #(parameter
    N = 624, //degree of recurrence
    M = 397, //middle word
    R = 31, //separation point of one word
    A = 32'h9908B0DF, //coefficients of the rational normal form twist matrix
    U = 11, // shift size used in the tempering process
    D = 32'hFFFFFFFF, // XOR mask used in the tempering process
    S = 7, // shift size used in tempering process
    B = 32'h9D2C5680, // XOR mask used in the tempering process
    T = 15, // shift size used in tempering process
    C = 32'hEFC60000, // XOR mask used in the tempering process
    L = 18, // shift size used in tempering process
    F = 1812433253 // initialization parameter
) (
    input clk, rst, trig,
    input [31:0] seed,
    output [31:0] r_num,
    output ready
);

localparam INDEX_WIDTH = $clog2(N);

logic [INDEX_WIDTH-1:0] index;
enum logic [1:0] {INIT, EXTR, GEN} state;

wire [32-INDEX_WIDTH-1:0] extra_z;
assign extra_z = 0;

wire wr;
assign wr = (rst || (state == INIT) || (state == GEN));

logic [31:0] Di;
wire [31:0] Do1;
wire [31:0] Do2;
logic [INDEX_WIDTH-1:0] index_gen;

Sram_dp #(N) sram (
    .clk(clk),
    .wr(wr),
    .Addr1(index),
    .Addr2(index_gen),
    .Di(Di),
    .Do1(Do1),
    .Do2(Do2)
);

always_ff@(posedge clk) //faire avec case
if(rst)
    state <= INIT;
else if(index == N-1 && state == INIT) // pas sûr
    state <= GEN;
else
    state <= EXTR;

always_ff@(posedge clk)
if(rst)
    index <= 1;
else if(state == INIT)
    index <= index + 1;

logic [31:0] Do1_r;
logic [31:0] x;
wire [31:0] wire_gen;

assign wire_gen = Do2 ^ (x >> 1);

always_ff@(posedge clk)
if(rst)
    Di <= seed;
else if(state == INIT)
    Di <= (F * (Di ^ (Di >> (30))) + {extra_z, index});
else if(state == GEN)
begin
    if (x[0])
        Di <= wire_gen ^ A;
    else
        Di <= wire_gen;
end

always_ff@(posedge clk)
begin
    Do1_r <= Do1;
    x <= {Do1_r[31:R], Do1[R-1:0]};
end


/*

//extract
logic [INDEX_WIDTH-1:0] ext_index;
logic [W-1:0] y0;
wire [W-1:0] y1;
wire [W-1:0] y2;
wire [W-1:0] y3;

always_ff@(posedge clk)
if(rst)
    ext_index <= 0;
else
    ext_index <= trig ?
    (ext_index == N -1) ?
    0 :
    ext_index + 1'b1 :
    ext_index;

    assign y0 = mem[ext_index];
    assign y1 = y0 ^ ((y0 >> U) & D);
    assign y2 = y1 ^ ((y1 << S) & B);
    assign y3 = y2 ^ ((y2 << T) & C);
    assign randNumber = y3 ^ (y3 >> L);

    //twist
    */

endmodule
