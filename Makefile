.PHONY: clean all maos

all: oisc maos

maos:
	@cd maos; $(MAKE) $(MFLAGS)

oisc:	ois.c
	@gcc -Wall -Wextra -ansi -pedantic -O2 $< -o $@

clean:
	@rm -rf oisc
	@cd maos; $(MAKE) clean
