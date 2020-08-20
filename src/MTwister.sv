//*************************************************************************
//
// Copyright 2020 by Julien Eudine. This program is free software; you can
// redistribute it and/or modify it under the terms of the BSD 3-Clause
// License
//
//*************************************************************************

module MTwister #(parameter
    N = 624, // degree of recurrence
    M = 397, // middle word
    R = 31, // separation point of one word
    A = 32'h9908B0DF, // coefficients of the rational normal form twist matrix
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
    output ready,
    output last
);

localparam INDEX_WIDTH = $clog2(N);

logic [INDEX_WIDTH-1:0] index;
enum logic [1:0] {INIT, EXTR, GEN} state, state_r0, state_r1;

wire wr;
wire [31:0] Di, Do1, Do2;
wire [INDEX_WIDTH-1:0] index_gen;

Sram_dp #(N) sram (
    .clk(clk),
    .wr(wr),
    .Addr1(index),
    .Addr2(index_gen),
    .Di(Di),
    .Do1(Do1),
    .Do2(Do2)
);

always_ff @(posedge clk)
begin
    state_r0 <= state;
    state_r1 <= state_r0;
end

always_ff @(posedge clk)
if (rst)
    state <= INIT;
else
case (state)
    INIT: if (index == N-2)
        state <= GEN;
    GEN: if (index == 0 && !wr && state_r1 == GEN)
        state <= EXTR;
    EXTR: if (last && trig)
        state <= GEN;
    default: ;
endcase

// Initialize and generate the values stored in the memory

logic [31:0] Di_init;

wire [31:0] x_gen;
wire [31:0] comb_gen;
logic osci_gen;
logic [31-R:0] Do1_gen;

assign wr = rst || (state == INIT) || (state == GEN && osci_gen && state_r0 != EXTR) || (state == EXTR && state_r0 == GEN && index == N-1);

assign comb_gen = Do2 ^ (x_gen >> 1);
assign x_gen = {Do1_gen, Do1[R-1:0]};

assign Di = (state_r0 == INIT || state == INIT) ? Di_init :
x_gen[0] ? comb_gen ^ A : comb_gen;

wire [32-INDEX_WIDTH-1:0] extra_zero;
assign extra_zero = 0;

always_ff @(posedge clk)
if (rst)
    Di_init <= seed;
else
begin
    Di_init <= F * (Di_init ^ (Di_init >> (30))) + {extra_zero, index} + 1;
end

always_ff @(posedge clk)
if (wr)
    Do1_gen <= Do1[31:R];

always_ff @(posedge clk)
if (state == GEN)
    osci_gen <= (state_r1 == GEN) ? ~osci_gen : 0;
else
    osci_gen <= 1;

// Registers used for the extraction (used to avoid latency)

logic [31:0] y;
logic trig_r;

always_ff @(posedge clk)
if (trig)
    y <= Do1;

always_ff @(posedge clk)
    trig_r <= trig;

// Combinatory logic used to extract the number

wire [31:0] y0;
wire [31:0] y1;
wire [31:0] y2;
wire [31:0] y3;

assign y0 = (trig && !trig_r) ? y ^ ((y >> U) & D) : Do1 ^ ((Do1 >> U) & D);
assign y1 = y0 ^ ((y0 << S) & B);
assign y2 = y1 ^ ((y1 << T) & C);
assign y3 = y2 ^ (y2 >> L);

// Register used to hold the random number on the output during the extraction

logic [31:0] y3_r;

always_ff @(posedge clk)
if(trig_r)
    y3_r <= y3;

assign r_num = trig_r ? y3 : y3_r;

// Handling of index

always_ff @(posedge clk)
if (rst)
    index <= 0;
else
case(state)
    EXTR:
    if (index == N-1 && state_r0 == GEN)
        index <= 0;
    else if (trig)
        index <= index + 1;
    GEN:
    if (state_r0 != GEN)
        index <= 0;
    else if (state_r1 != GEN)
        index <= 1;
    else if (index == N-2 && wr)
        index <= 0;
    else if (index == 0 && !wr)
        index <= N-1;
    else if (wr)
        index <= index + 2;
    else
        index <= index - 1;

    default: index <= index + 1;
endcase

assign index_gen = (index + M > N) ? index + M - N -1 : index + M - 1;

assign ready = (state_r0 == EXTR) && (state == EXTR);

assign last = (state_r0 == EXTR) && (index == N-1);

endmodule
