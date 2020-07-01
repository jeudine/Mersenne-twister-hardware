#ifndef MTWISTER_FUNC_H
#define MTWISTER_FUNC_H

#include <systemc>
#include "Parameters.h"

SC_MODULE(MTwister_func) {

    MTwister_func(sc_core::sc_module_name n, const Parameters & p) : sc_module(), param(p) {
    SC_HAS_PROCESS(MTwister_func);
    }

    private:
    Parameters param;

};
#endif
