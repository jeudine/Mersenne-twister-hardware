#include <systemc>
#include "MTwister_func.h"
#include <iostream>

using namespace sc_core;

int sc_main(int argc, char *argv[]) {
    Parameters param;
    MTwister_func MT_func("MT_func", param);

    sc_signal<uint32_t> seed("seed");
    sc_signal<bool> init("init");
    sc_signal<uint32_t> r_num("r_num");
    sc_clock trig("trig",10,SC_NS);
    //sc_signal<bool> trig("trig");

    MT_func.seed(seed);
    MT_func.init(init);
    MT_func.r_num(r_num);
    MT_func.trig(trig);

    // trace
    sc_trace_file *trace_f = sc_create_vcd_trace_file("simu_trace");
    trace_f->set_time_unit(1, SC_NS);

    sc_trace(trace_f, seed, seed.name());
    sc_trace(trace_f, init, init.name());
    sc_trace(trace_f, r_num, r_num.name());
    sc_trace(trace_f, trig, trig.name());

    // simulation
    seed = 0;
    init = true;
    sc_start(SC_ZERO_TIME);
    init = false;
    sc_start(200, SC_NS);

    sc_close_vcd_trace_file(trace_f);
    return 0;
}
