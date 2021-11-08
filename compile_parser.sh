#!/bin/bash
rm lex.yy.c parser spl.tab.c
flex spl.l
bison -t spl.y
testprogram=a
run=false
while getopts dtgrp: flag
do
    case "${flag}" in
        d) debug=-DYYDEBUG;;
        t) mode=-DDEBUG;;
        r) run=true;;
        p) testprogram=${OPTARG};;
    esac
done
gcc spl.tab.c spl.c -o parser -lfl -lm ${mode} ${debug}
if [ "$run" = false ] && [ "$mode" = -DDEBUG ]; then
    ./parser < test_programs/${testprogram}.spl
elif [ "$run" = false ]; then
    ./parser < test_programs/${testprogram}.spl
elif [ "$run" = true ] && [ "$mode" = -DDEBUG ]; then
    ./parser < test_programs/${testprogram}.spl > tree_generator/output
    python3 tree_generator/generate_tree.py | dot -Tpng -otree_generator/tree_${testprogram}.png
elif [ "$run" = true ]; then
    ./parser < test_programs/${testprogram}.spl > code_generated/${testprogram}.c
    gcc code_generated/${testprogram}.c -o code_generated/${testprogram}.out
fi