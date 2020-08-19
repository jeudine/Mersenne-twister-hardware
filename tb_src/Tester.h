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

    sc_core::sc_in<bool> clk{"clk"};
    sc_core::sc_out<bool> rst{"rst"};

    sc_core::sc_out<uint32_t> seed{"seed"};
    sc_core::sc_out<bool> trig{"trig"};

    sc_core::sc_in<uint32_t> r_num_func{"r_num_func"};

    sc_core::sc_in<uint32_t> r_num_rtl{"r_num_rtl"};
    sc_core::sc_in<bool> ready{"ready"};
    sc_core::sc_in<bool> last{"last"};

    Tester(sc_core::sc_module_name n, uint32_t s) : sc_module(), seed_v(s) {
        SC_HAS_PROCESS(Tester);
        SC_CTHREAD(test, clk.pos());
    }

    private:
    uint32_t seed_v;
    void test();

};

#endif
