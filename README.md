# SPL Compiler

This compiler was created as part of the module **Languages and their compilers** in Hull University in autumn 2021.  
Big thanks to Brian Tompsett and Lydia Bryan-Smith for their help during the semester.  
<br />
The compiler has been designed to compile the SPL language into C. The language specifications can be find [here](git_ressources/definition_SPL_language.pdf).  

## Requirements
> :warning: **If you are a Windows or MacOS user**: This repository is meant to be used on Ubuntu. It's still possible to run the compiler on Windows but this document don't explain how.

* Install Python 3 `apt-get install python3`.
* Install Flex `apt-get install flex`.
* Install Bison `apt-get install bison`.
* Install GraphViz `apt-get install graphviz` (we will need it to generate the graphic representation of the parse tree).
* Authorize your user to execute **compile.sh** `chmod u+x compile.sh`.
* Having a folder named **src_programs** and some .spl files in it

## How to use and how it works

There are multiple things you can do with this repository, **compile.sh** regroup all of them so I'll link the associated commands in each section.

### Lexer
The lexer can be used to print the tokens of the source program recognized by the compiler.  
`./compile -m lexer -p <src_program>`

![Lexer diagram](git_ressources/lexer.drawio.png?raw=true)

---
### Parser
The parser can be used in debug mode to see the rules used and the stack generated for the source program.  
`./compile -m parser -p <src_program>`

![Parser diagram](git_ressources/parser.drawio.png?raw=true)

---
### Tree
The parse tree can be used in 2 differents ways:
* Printing the JSON format of the tree in the terminal. `./compile -m tree -p <src_program>`  

![Tree diagram](git_ressources/tree.drawio.png?raw=true)
<br />
<br />
> :information_source: **If you don't want to use GraphViz**: There is an alternative to visualize the tree, you can paste the JSON on https://vanya.jp.net/vtree/

* Passing the JSON into GraphViz to generate a PNG with a graphical representation of the parse tree. `./compile -m tree -p <src_program> -r`  

![Tree diagram](git_ressources/tree_graph.drawio.png?raw=true)

The PNG tree will be created inside the **tree_generator/** folder.

---
### Code
The code feature can also be used in 2 differents ways:
* Printing the generated code in the terminal. `./compile -m code -p <src_program>`  

![Code diagram](git_ressources/code.drawio.png?raw=true)  

* Compiling the generated code with GCC to make sure it doesn't give any errors and run smoothly. `./compile -m code -p <src_program> -r`  

![Code diagram](git_ressources/code_compile.drawio.png?raw=true)  

The target code will be stored as **src_program.c** in the **code_generated** folder and their compiled version will be named **src_program.out**

## Additional functionalities

On top of the [language specification](git_ressources/definition_SPL_language.pdf) I had to define some behaviors for the compiler to work.

### Type coercion

* Integers **can** be assigned to real numbers, it won't give any warning.
* Reals **can** be assigned to integer but it will give a warning.
* Characters **can't** be assigned to anything else than character variables.
* Arithmetic **can** be done between integers and reals.
* Arithmetic **can't** be done with characters and another type.

### Code optimization

The compiler does some sort of type optimization, when there is an arithmetic expression containing only integers, the expression is precalculated at compile time.  
For example **78 - 5 -> a** will be compiled as **a = 73;**.  
Also **WRITE( (26 - 7) )** will be compiled as **printf("%d",19);**.  
It doesn't work with arithmetic expressions containing reals.