#include <stdio.h>

int main() {
  unsigned char mem[256] = {0}, p = 1, *m = &mem[0];

  while((size_t)(m - mem) < sizeof mem && fread(++m, 1, 1, stdin));
  while((p = (mem[mem[p+1]] -= mem[mem[p]]) <= 0 ? mem[p+2] : p+3));

  return printf("%c\n", mem[0]), 0;
}
