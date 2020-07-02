#include "MTwister_func.h"

void MTwister_func::initialize() {
    index = param.N;
    mem[0] = seed;
    for(unsigned int i = 1; i < param.N; i++)
        mem[i] = (param.F * (mem[i-1] ^ (mem[i-1] >> 30))) + (uint32_t)i;
}

void MTwister_func::extract() {
    if(index == param.N)
        this->generate();

    uint32_t y = mem[index];
    y = y ^ ((y >> param.U) & param.D);
    y = y ^ ((y << param.S) & param.B);
    y = y ^ ((y << param.T) & param.C);
    y = y ^ (y >> param.L);

    index++;
    r_num = y;
}

void MTwister_func::generate() {
    const uint32_t lower_mask = ((uint32_t)1 << param.R) - 1;
    const uint32_t upper_mask = ~lower_mask;
    const uint32_t mag01[2]={0, param.A};
    unsigned int i = 0;
    for(; i < param.N - param.M; i++) {
        uint32_t x = (mem[i] & upper_mask) | (mem[(i+1)] & lower_mask);
        mem[i] = mem[i + param.M] ^ (x >> 1) ^ mag01[x & (uint32_t)1];
    }

    for(; i < param.N -1; i++) {
        uint32_t x = (mem[i] & upper_mask) | (mem[(i+1)] & lower_mask);
        mem[i] = mem[i + param.M - param.N] ^ (x >> 1) ^ mag01[x & (uint32_t)1];
    }

    uint32_t x = (mem[param.N - 1] & upper_mask) | (mem[(i+1)] & lower_mask);
    mem[param.N-1] = mem[param.M - 1] ^ (x >> 1) ^ mag01[x & (uint32_t)1];
    index = 0;
}

void MTwister_func::mthread() {
    for(;;) {
        if(init) {
            initialize();
        }
        generate();
        wait();
    }
}
