//*************************************************************************
//
// Copyright 2020 by Julien Eudine. This program is free software; you can
// redistribute it and/or modify it under the terms of the BSD 3-Clause
// License
//
//*************************************************************************

module Sram_dp#(parameter N = 624)
(
    input clk, wr,
    input  [$clog2(N) - 1:0] Addr1, Addr2,
    input  [31:0] Di,
    output logic [31:0] Do1, Do2
);


logic[31:0] mem [0:N-1];

always_ff @(posedge clk)
begin
    if (wr)
        mem[Addr1] <= Di;
    Do1 <= mem[Addr1];
end

always_ff @(posedge clk)
    Do2 <= mem[Addr2];

endmodule
