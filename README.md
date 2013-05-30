ois.c
=====

This is a simple interpreter for an [OISC](http://en.wikipedia.org/wiki/One_instruction_set_computer)
CPU. My goal is to keep the interpreter at a 10-line maximum because I'm bored
and don't have anything else to do in my free time.

The CPU
-------

The CPU has 256 bytes of addressable memory. During startup, a sequence of bytes
are read from stdin into this memory space, starting at address 1. Execution
then begins with the instruction pointer `P` set to 1. The CPU executes until
`P = 0`, which is the terminating condition.

The instruction
---------------

Since this is a standard OISC architecture, there is only one instruction:
`subleq`. `subleq` has the following form:

```
subleq a:Uint8, b:Uint8, c:Uint8
```

This instruction performs the following (given in pseudocode):

```
mem[b] = mem[b] - mem[a];
if(mem[b] <= 0)
  P = c;
```

Since there is only one instruction, the only data which need to be stored in
memory are the three immediates. Therefore, each instruction takes up 3 bytes,
with `a` first and `c` last.

Output
------

Right now, there is only one output register. This register is memory-mapped
to the address 0 and its value is displayed when the CPU finishes execution.
Incremental output would be nice, so I'm trying to figure out a way to do this
in the future.
