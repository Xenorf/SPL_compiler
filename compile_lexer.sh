#!/bin/bash
rm lex.yy.c lexer
flex spl.l
gcc lex.yy.c -o lexer -lfl -DPRINT