## Construct a good code

Binary bitstrings are string with length `n`, each digit only filled by `0` and `1`.

Binary code `(n,M,d)2` is `M` bitstrings (called _codeword_) with length `n`, in which every different codewords have minimal Hamming distance `d`.

Hamming distance between bitstrings `x` and `y` is number of coordinates `i` where `xi≠yi`. Example `dH(000,011) = 2` and `dH(00010,01101) = 4`.

### Input
Single integer `t` test case, followed by `t` lines of two integers `M` and `e`. Minimal Hamming distance `d = 2*e + 1`.

### Output
Single integer `n`, followed by `M` codewords, each codeword has length `n`. Every two different codewords must have minimal Hamming distance `d`. 

Remember, you must find the lowest `n` such that binary code `(n, M, d)` exists.

### Constrains
```
1 <= t <= 10
2 <= M <= 4096
0 <= e <= 16
```

### Example input
```
3
4 0
8 1
16 1
```

### Example output
```
2
00
01
10
11
6
000000
001011
010101
011110
100110
101101
110011
111000
7
0000000
0001110
0010111
0011001
0100101
0101011
0110010
0111100
1000011
1001101
1010100
1011010
1100110
1101000
1110001
1111111
```
