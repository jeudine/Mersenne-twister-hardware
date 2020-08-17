//*************************************************************************
//
// Copyright 2020 by Julien Eudine. This program is free software; you can
// redistribute it and/or modify it under the terms of the BSD 3-Clause
// License
//
//*************************************************************************

#ifndef TESTER_H
#define TESTER_H

#include <systemc>

SC_MODULE(Tester) {

    sc_core::sc_in<bool> seed{"clk"};
    sc_core::sc_out<bool> rst{"rst"};

    sc_core::sc_out<uint32_t> seed{"seed"};
    sc_core::sc_out<bool> rst{"trig"};

    sc_core::sc_in<uint32_t> r_num_func{"r_num_func"};
    sc_core::sc_in<uint32_t> r_num_rtl{"r_num_rtl"};

    SC_CTOR(Tester) {
        SC_CTHREAD(generate, clk.pos());
        SC_CTHREAD(compare, clk.pos());
    }
};

#endif
