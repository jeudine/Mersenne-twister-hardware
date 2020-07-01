#include <systemc>
#include "MTwister_func.h"
#include <iostream>

int sc_main(int argc, char *argv[]) {
    Parameters param;
    MTwister_func MT_func("MT_func", param);
    return 0;
}
