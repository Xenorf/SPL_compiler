# SPL Compiler

This compiler was created as part of the module **Languages and their compilers** in Hull University in spring 2021.  
Big thanks to Brian Tompsett and Lydia Bryan-Smith for their help during the semester.

## Requirements
> :warning: **If you are a Windows or Mac/OS user**: This repository is meant to be used on Ubuntu. It's still possible to run the compiler on Windows but this document don't explain how.

* Install Python 3 `apt-get install python3`.
* Install Flex `apt-get install flex`.
* Install Bison `apt-get install bison`.
* Install GraphViz `apt-get install graphviz` (we will need it to generate the graphic representation of the parse tree).
* Authorize your user to execute **compile.sh** `chmod u+x compile.sh`.
* Having a folder named **test_programs** and some .spl files in it

## Functionalities

There are multiple things you can do with this repository, **compile.sh** regroup all of them so I'll link the associated commands in each section.

---
### Lexer
The lexer can be used to print the tokens of the source program recognized by the compiler.  
`./compile -m lexer -p <src_program>`

![Lexer diagram](git_images/lexer.drawio.png?raw=true)

---
### Parser
The parser can be used in debug mode to see the rules used and the stack generated for the source program.  
`./compile -m parser -p <src_program>`

![Parser diagram](git_images/parser.drawio.png?raw=true)

---
### Tree
The parse tree can be used in 2 differents ways:
* Printing the JSON format of the tree in the terminal. `./compile -m tree -p <src_program>`  

![Tree diagram](git_images/tree.drawio.png?raw=true)

> :information_source: **If you don't want to use GraphViz**: There is an alternative to visualize the tree, you can paste the JSON on https://vanya.jp.net/vtree/

* Passing the JSON into GraphViz to generate a PNG with a graphical representation of the parse tree. `./compile -m tree -p <src_program> -r`  

![Tree diagram](git_images/tree_graph.drawio.png?raw=true)

The PNG tree will be created inside the **tree_generator/** folder.

---
### Code
The code feature can also be used in 2 differents ways:
* Printing the generated code in the terminal. `./compile -m code -p <src_program>`  

![Code diagram](git_images/code.drawio.png?raw=true)  

* Compiling the generated code with GCC to make sure it doesn't give any errors and run smoothly. `./compile -m code -p <src_program> -r`  

![Code diagram](git_images/code_compile.drawio.png?raw=true)  

The target code will be stored as **src_program.c** in the **code_generated** folder and their compiled version will be named **src_program.out**