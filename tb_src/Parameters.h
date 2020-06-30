struct Parameters {
    unsigned int N;
    unsigned int M;
    uint32_t A;
    uint32_t D;
    uint32_t B;
    uint32_t C;
    uint32_t F;
    unsigned char R;
    unsigned char U;
    unsigned char S;
    unsigned char T;
    unsigned char L;

    Parameters(
            unsigned int N = 624,
            unsigned int M = 397,
            unsigned char R = 31,
            uint32_t A = 0x9908B0DF,
            unsigned char U = 11,
            uint32_t D = 0xFFFFFFFF,
            unsigned char S = 7,
            uint32_t B = 0x9D2C5680,
            unsigned char T = 15,
            uint32_t C = 0xEFC60000,
            unsigned char L = 18,
            uint32_t F = 1812433253
            ) : N(N), M(M), A(A), D(D), B(B), C(C), F(F), R(R), U(U), S(S), T(T), L(L) {}
};
