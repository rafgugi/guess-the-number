## Construct a good code

Binary bitstrings are string with length `n`, each digit only filled by `0` and `1`.

Binary code `(n,M,d)2` is `M` bitstrings (called *codeword*) with length `n`, in which every different codewords have minimal Hamming distance `d`.

Hamming distance between bitstrings `x` and `y` is number of coordinates `i` where `xi≠yi`. Example `dH(000,011) = 2` and `dH(00010,01101) = 4`.

### Input
Single integer `t` test case, followed by `t` lines of two integers `M` and `e`. `d = 2*e + 1`.

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
2
4 0
8 1
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
100110
101101 
010101
011110 
110011
111000
```
