//*************************************************************************
//
// Copyright 2020 by Julien Eudine. This program is free software; you can
// redistribute it and/or modify it under the terms of the BSD 3-Clause
// License
//
//*************************************************************************

#include "Tester.h"
#include <iostream>
#include <cstdlib>

#define GENERATION \
    wait();\
    counter ++;

#define EXTRACTION \
    trig = std::rand() % 2;\
    wait();\
    if (r_num_func != r_num_rtl && trig) nb_errors ++;


void Tester::test() {
    unsigned int counter = 0;
    unsigned int nb_errors = 0;

    std::cout << std::endl << "############# Mersenne-twister-hardware #############" << std::endl;
    wait();
    rst = true;
    seed = seed_v;
    wait(2);
    rst = false;
    std::cout << "The initialisation and the first generation start..." << std::endl;
    std::cout << "Seed: " << seed_v << std::endl;

    while (!ready) { GENERATION }

    std::cout << "The initialisation and the first generation lasted " << counter << " periods." << std::endl;
    std::cout << "The first extraction stage starts..." << std::endl;


    while (ready && !last) { EXTRACTION }

    while (!trig) { EXTRACTION }

    std::cout << "All numbers have been output, the first extraction stage is over." << std::endl;
    trig = false;
    wait();

    counter = 0;
    while (!ready) { GENERATION }

    std::cout << "The second generation starts..." << std::endl;
    std::cout << "The second generation lasted " << counter << " periods." << std::endl;
    std::cout << "The second extraction stage starts..." << std::endl;

    while (ready && !last) { EXTRACTION }

    while (!trig) { EXTRACTION }

    std::cout << "All numbers have been output, the second extraction stage is over." << std::endl;
    trig = false;
    wait(10);

    std::cout << "The simulation is over, number of errors during the extractions: " << nb_errors << std::endl;
    test_failed = (nb_errors) ? 1 : 0;
    sc_core::sc_stop();
}
