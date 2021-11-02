#!/bin/bash
rm lex.yy.c parser spl.tab.c
flex spl.l
bison -t spl.y
testprogram=a
while getopts dtgrp: flag
do
    case "${flag}" in
        d) debug=-DYYDEBUG;;
        t) mode=-DPRINTTREE;;
        g) mode=-DGENCODE;;
        r) run=true;;
        p) testprogram=${OPTARG};;
    esac
done
gcc spl.tab.c spl.c -o parser -lfl ${mode} ${debug}
echo $mode

if [ $run = true ] && [ $mode = -DPRINTTREE ]; then
    ./parser < test_programs/${testprogram}.spl > tree_generator/output
    python3 tree_generator/generate_tree.py | dot -Tpng -otree_generator/tree.png
elif [ $run = true ] && [ $mode = -DGENCODE ]; then
    ./parser < test_programs/${testprogram}.spl > code_generated/${testprogram}.c
    gcc code_generated/${testprogram}.c -o code_generated/${testprogram}.out
fi
#python3 tree_generator/generate_tree.py | dot -Tpng -otree_generator/tree.png