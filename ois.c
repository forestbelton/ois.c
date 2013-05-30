#include <stdio.h>

int main() {
  unsigned char mem[256] = {0}, p = 1, *m = &mem[0];

  while(m - mem < sizeof mem && fread(++m, 1, 1, stdin));
  while(p = ((mem[p+2] -= mem[p+1]) <= 0) ? mem[p+3] : p+3);

  return putchar(p[0]), 0;
}
