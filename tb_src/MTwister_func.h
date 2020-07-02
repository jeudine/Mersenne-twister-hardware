#ifndef MTWISTER_FUNC_H
#define MTWISTER_FUNC_H

#include <systemc>
#include "Parameters.h"

SC_MODULE(MTwister_func) {

    sc_core::sc_in<uint32_t> seed{"seed"};
    sc_core::sc_in<bool> init{"init"};
    sc_core::sc_out<uint32_t> r_num{"r_num"};
    sc_core::sc_in<bool> trig{"trig"};

    MTwister_func(sc_core::sc_module_name n, const Parameters & p) : sc_module(), param(p) {
        mem = new uint32_t[param.N];
        SC_HAS_PROCESS(MTwister_func);

        SC_THREAD(mthread);
        sensitive << init.pos() << trig.pos();
        dont_initialize();
    }

    ~MTwister_func() {
        delete[] mem;
    }


    private:
    Parameters param;
    uint32_t * mem;
    unsigned int index;

    void initialize();
    void extract();
    void generate();
    void mthread();
};

#endif
