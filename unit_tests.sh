#!/bin/bash
rm lex.yy.c parser spl.tab.c
flex spl.l
bison -t spl.y
testprogram=001
while getopts rp: flag
do
    case "${flag}" in
        r) run=true;;
        p) testprogram=${OPTARG};;
    esac
done
gcc spl.tab.c spl.c -o parser -lfl -lm
if [ "$run" = true ]; then
    ./parser < unit_tests/Test${testprogram}.spl > unit_tests_code/Test${testprogram}.c
    gcc unit_tests_code/Test${testprogram}.c -o unit_tests_code/Test${testprogram}.out
else
    ./parser < unit_tests/Test${testprogram}.spl
fi