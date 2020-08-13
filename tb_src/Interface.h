#ifndef INTERFACE_H
#define INTERFACE_H

#include <systemc>

struct Interface {
sc_in<bool> clk;
sc_in<bool> rst;
sc_in<uint32_t> seed;
sc_in<bool> trig;
sc_out<uint32_t> randNumber;
};


#endif
