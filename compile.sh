#!/bin/bash
rm -f lex.yy.c compiler spl.tab.c
flex spl.l
bison -t spl.y

#defining the options used by the command
run=false
while getopts m:rp: flag
do
    case "${flag}" in
        m) mode=${OPTARG};;
        r) run=true;;
        p) testprogram=${OPTARG};;
    esac
done

#Checking if the command syntax is correct and setting to the right value the mode according to the arguments
if [ "$mode" != lexer ] && [ "$mode" != parser ] && [ "$mode" != tree ] && [ "$mode" != code ]; then
    echo "Wrong utilisation of the command"
    echo -e "./compile -m <parser | tree | code> -p <\e[4mfile\e[0m> [-r]"
    exit 1
elif [ "$mode" == parser ]; then
    mode=-DYYDEBUG
elif [ "$mode" == tree ]; then
    mode=-DDEBUG
elif [ "$mode" == code ]; then
    unset mode
fi

#Compiling the lexer or the parser with the mode passed as an argument
if [ "$mode" == lexer ]; then
gcc lex.yy.c -o compiler -lfl -DPRINT
else
gcc spl.tab.c spl.c -o compiler -lfl ${mode}
fi

#defining the action of the newly compiled file (either printing the different stages, creating the tree or compiling the generated code)
if [ "$run" = true ] && [ "$mode" = -DDEBUG ]; then
    ./compiler < src_programs/${testprogram}.spl > tree_generator/parser_tree_output
    python3 tree_generator/generate_tree.py | dot -Tpng -otree_generator/tree_${testprogram}.png
elif [ "$run" = true ] && [ -z "$mode" ]; then
    mkdir -p code_generated
    ./compiler < src_programs/${testprogram}.spl > code_generated/${testprogram}.c
    gcc code_generated/${testprogram}.c -o code_generated/${testprogram}.out
elif [ "$mode" = lexer ] || [ "$mode" = -DYYDEBUG ] || [ "$mode" = -DDEBUG ] || [ -z "$mode" ]; then
    ./compiler < src_programs/${testprogram}.spl
fi

rm -f lex.yy.c compiler spl.tab.c