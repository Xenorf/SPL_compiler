#!/bin/bash
rm lex.yy.c parser spl.tab.c
flex spl.l
bison -t spl.y
gcc spl.tab.c spl.c -o parser -lfl -DYYDEBUG