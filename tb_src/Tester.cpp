//*************************************************************************
//
// Copyright 2020 by Julien Eudine. This program is free software; you can
// redistribute it and/or modify it under the terms of the BSD 3-Clause
// License
//
//*************************************************************************

#include "Tester.h"
#include <iostream>

void Tester::test() {
    std::cout << std::endl << "############# Mersenne-twister-hardware #############" << std::endl;
    sc_core::wait();
    rst = true;
    seed = 42; // to modify
    sc_core::wait(2);
    rst = false;
    std::cout << "The Initialisation and the first generation start..." << std::endl;
    while (ready != true) {
        sc_core::wait();
        counter ++;
    }
    std::cout << "Duration of the Initialisation and Generation: " << counter << " periods" << std::endl;
    std::cout << "The Extraction stage starts..." << std::endl;


}
