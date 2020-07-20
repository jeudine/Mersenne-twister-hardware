module MTwister #(parameter N = 624, //degree of recurrence
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
                               )
(input clk, input rst, input init, input [31:0] seed, input trig, output [31:0] randNumber, output ready);

localparam W =32;
localparam INDEX_WIDTH = $clog2(N);
logic [31:0] mem [0:N-1];
logic [INDEX_WIDTH-1:0] index;

//init
wire [W-INDEX_WIDTH-1:0] extra_z;
logic [W-1:0] val;
assign extra_z = 0;

always_ff@(posedge clk)
    if(rst)
        index <= 0;
    else
        index <= (index < N) ? index + 1'b1 : index;

always_ff@(posedge clk)
    if(rst)
        val <= seed;
    else
        val <= (F * (val ^ (val >> (W-2))) + {extra_z, index});

always_ff@(posedge clk)
    if(index < N)
        mem[index] <= val;


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

endmodule
