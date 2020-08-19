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

void Tester::test() {
    std::cout << std::endl << "############# Mersenne-twister-hardware #############" << std::endl;
    wait();
    rst = true;
    seed = 42; // to modify
    wait(2);
    rst = false;
    std::cout << "The initialisation and the first generation start..." << std::endl;
    while (!ready) {
        wait();
        counter ++;
    }
    std::cout << "The initialisation and the first generation lasted " << counter << " periods." << std::endl;
    std::cout << "The first extraction stage starts..." << std::endl;


    while (ready && !last) {
        trig = std::rand() % 2;
        wait();
    }

    while (!trig) {
        trig = std::rand() % 2;
        wait();
    }
    std::cout << "All numbers have been output, the first extraction stage is over." << std::endl;
    trig = 0;
    wait();

    counter = 0;
    while (!ready) {
        wait();
        counter ++;
    }
    std::cout << "The second generation starts..." << std::endl;
    std::cout << "The second generation lasted " << counter << " periods." << std::endl;
    std::cout << "The second extraction stage starts..." << std::endl;

    while (ready && !last) {
        trig = std::rand() % 2;
        wait();
    }

    while (!trig) {
        trig = std::rand() % 2;
        wait();
    }
    std::cout << "All numbers have been output, the second extraction stage is over." << std::endl;
    trig = 0;
    wait(10);
    sc_core::sc_stop();
}
