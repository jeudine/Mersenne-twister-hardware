//*************************************************************************
//
// Copyright 2020 by Julien Eudine. This program is free software; you can
// redistribute it and/or modify it under the terms of the BSD 3-Clause
// License
//
//*************************************************************************

#include <systemc>
#include "MTwister_func.h"
#include "VMTwister.h"
#include "Tester.h"
#include "verilated_vcd_sc.h"

using namespace sc_core;

int sc_main(int argc, char *argv[]) {
    if (argc != 2) {
        cerr << "Wrong number of arguments, please indicate the value of the seed!" << endl;
        cerr << "./simulation.x <value of the seed>" << endl;
        return 1;
    }

    uint32_t seed_v = std::stoi(argv[1]);

    Parameters param;
    MTwister_func MT_func("MT_func", param);
    VMTwister MT_hdl("MT_hdl");
    Tester tester("tester", seed_v);

    sc_signal<uint32_t> seed("seed");
    sc_signal<bool> rst("rst");
    sc_signal<uint32_t> r_num_func("r_num_func");
    sc_signal<uint32_t> r_num_rtl("r_num_rtl");
    sc_signal<bool> trig("trig");
    sc_signal<bool> ready("ready");
    sc_signal<bool> last("last");
    sc_clock clk("clk",10,SC_NS);

    MT_func.clk(clk);
    MT_func.rst(rst);
    MT_func.trig(trig);
    MT_func.seed(seed);
    MT_func.r_num(r_num_func);

    MT_hdl.clk(clk);
    MT_hdl.rst(rst);
    MT_hdl.trig(trig);
    MT_hdl.ready(ready);
    MT_hdl.seed(seed);
    MT_hdl.r_num(r_num_rtl);
    MT_hdl.last(last);

    tester.clk(clk);
    tester.rst(rst);
    tester.seed(seed);
    tester.trig(trig);
    tester.r_num_func(r_num_func);
    tester.r_num_rtl(r_num_rtl);
    tester.ready(ready);
    tester.last(last);

    // Debug trace
    Verilated::traceEverOn(true);
    VerilatedVcdSc* tfp = new VerilatedVcdSc;
    MT_hdl.trace(tfp, 10);
    tfp->open("debug_trace.vcd");

    // Simu trace
    sc_trace_file *trace_f = sc_create_vcd_trace_file("simu_trace");
    trace_f->set_time_unit(1, SC_NS);

    sc_trace(trace_f, clk, clk.name());
    sc_trace(trace_f, rst, rst.name());
    sc_trace(trace_f, seed, seed.name());
    sc_trace(trace_f, trig, trig.name());

    sc_trace(trace_f, r_num_func, r_num_func.name());

    sc_trace(trace_f, r_num_rtl, r_num_rtl.name());
    sc_trace(trace_f, ready, ready.name());
    sc_trace(trace_f, last, last.name());

    // simulation
    sc_start();

    sc_close_vcd_trace_file(trace_f);
    tfp->close();
    return tester.getExitStatus();
}
