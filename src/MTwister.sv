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

wire [32-INDEX_WIDTH-1:0] extra_z; //to modify
assign extra_z = 0;

wire wr;

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

always_ff @(posedge clk) //faire avec case
if (rst)
    state <= INIT;
else if (index == N-1 && state == INIT) // pas sûr
    state <= GEN;
else
    state <= EXTR;

// Initialize and generate the values stored in the memory

logic [31-R:0] Do1_r;
logic [31:0] x;
wire [31:0] wire_gen;

assign wr = (rst || (state == INIT) || (state == GEN));

assign wire_gen = Do2 ^ (x >> 1);

always_ff @(posedge clk)
if (rst)
    Di <= seed;
else
case (state)
    INIT: Di <= (F * (Di ^ (Di >> (30))) + {extra_z, index});
    GEN: Di <= x[0] ? wire_gen ^ A : wire_gen;
    default: ;
endcase

always_ff @(posedge clk)
begin
    Do1_r <= Do1[31:R];
    x <= {Do1_r, Do1[R-1:0]};
end

// Combinatory logic used to extract the number

wire [31:0] y0;
wire [31:0] y1;
wire [31:0] y2;

assign y0 = Do1 ^ ((Do1 >> U) & D);
assign y1 = y0 ^ ((y0 << S) & B);
assign y2 = y1 ^ ((y1 << T) & C);
assign r_num = y2 ^ (y2 >> L);

// index and index_gen handler

always_ff @(posedge clk)
if (rst)
    index <= 1;
else
case(state)
    INIT: index <= (index == N-1) ? 0 : index + 1;
    GEN: begin
        index <= (index == N-1) ? 0 : index + 1;
        index_gen <= (index + 1 + M == N-1) ? 0 : index + 1 + M;
    end
    EXTR: if (trig)
        index <= index + 1;
    default: ;
endcase

// ready handler

always_ff @(posedge clk)
case (state)
    EXTR:
        ready <= trig;

    default: ready <= 0;
endcase

endmodule
