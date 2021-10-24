%{
/* SPL01.y - SPL01 parser */
/* Author: Peter Parsons */
/* Revision: Oct 08 BCT */
/*              BCT Aug 21  - Added out of memory check */

/* Skeleton yacc file that can be used */
/* This file shows how a parser could build up a parse tree

   Do not use this until you need to, and understand some
   of the material on tree building and walking.             */

/* declare some standard headers to be used to import declarations
   and libraries into the parser. */

#include <stdio.h>
#include <stdlib.h>

/* make forward declarations to avoid compiler warnings */
int yylex (void);
void yyerror (char *);

/* 
   Some constants.
*/

  /* These constants are used later in the code */
#define SYMTABSIZE     50
#define IDLENGTH       15
#define NOTHING        -1
#define INDENTOFFSET    2

  enum ParseTreeNodeType { PROGRAM, BLOCK } ;  
                          /* Add more types here, as more nodes
                                           added to tree */

#ifndef TRUE
#define TRUE 1
#endif

#ifndef FALSE
#define FALSE 0
#endif

#ifndef NULL
#define NULL 0
#endif

/* ------------- parse tree definition --------------------------- */

struct treeNode {
    int  item;
    int  nodeIdentifier;
    struct treeNode *first;
    struct treeNode *second;
    struct treeNode *third;
  };

typedef  struct treeNode TREE_NODE;
typedef  TREE_NODE        *TERNARY_TREE;

/* ------------- forward declarations --------------------------- */

TERNARY_TREE create_node(int,int,TERNARY_TREE,TERNARY_TREE,TERNARY_TREE);

/* ------------- symbol table definition --------------------------- */

struct symTabNode {
    char identifier[IDLENGTH];
};

typedef  struct symTabNode SYMTABNODE;
typedef  SYMTABNODE        *SYMTABNODEPTR;

SYMTABNODEPTR  symTab[SYMTABSIZE]; 

int currentSymTabSize = 0;

%}

/****************/
/* Start symbol */
/****************/

%start  program

/**********************/
/* Action value types */
/**********************/

%union {
    int iVal;
    TERNARY_TREE  tVal;
}

%token ENDP DECLARATIONS CODE TYPE CHARACTER_TYPE INTEGER_TYPE REAL_TYPE IF THEN ENDIF ELSE DO WHILE ENDDO ENDWHILE FOR IS BY TO ENDFOR WRITE NEWLINE READ NOT AND OR OF GREATER_THAN_OR_EQUAL LESS_THAN_OR_EQUAL NOT_EQUAL LESS_THAN GREATER_THAN EQUAL ASSIGNEMENT MINUS PLUS TIMES DIVIDE BRA KET COLON PERIOD COMMA SEMICOLON IDENTIFIER NUMBER CHARACTER
%%
program : identifier COLON block ENDP identifier PERIOD
    ;
block : DECLARATIONS declaration_block CODE statement_list | CODE statement_list
    ;
declaration_block : identifier_list OF TYPE type SEMICOLON | identifier_list OF TYPE type SEMICOLON declaration_block
    ;
identifier_list : identifier | identifier_list COMMA identifier
    ;
type : CHARACTER_TYPE | INTEGER_TYPE | REAL_TYPE
    ;
statement_list : statement | statement_list SEMICOLON statement
    ;
statement : assignment_statement | if_statement | do_statement | while_statement | for_statement | write_statement | read_statement
    ;
assignment_statement : expression ASSIGNEMENT identifier
    ;
if_statement : IF conditional THEN statement_list ENDIF
				| IF conditional THEN statement_list ELSE statement_list ENDIF
    ;
do_statement : DO statement_list WHILE conditional ENDDO
    ;
while_statement : WHILE conditional DO statement_list ENDWHILE
    ;
for_statement : FOR identifier IS expression BY expression TO expression DO statement_list ENDFOR
    ;
write_statement : WRITE BRA output_list KET | NEWLINE
    ;
read_statement : READ BRA identifier KET
    ;
output_list : value | output_list COMMA value
    ;
conditional : NOT conditional | expression comparator expression AND conditional | expression comparator expression OR conditional | expression comparator expression
    ;
comparator : EQUAL | NOT_EQUAL | LESS_THAN | GREATER_THAN | GREATER_THAN_OR_EQUAL | LESS_THAN_OR_EQUAL
    ;
expression : term | expression PLUS term | expression MINUS term 
    ;
term : value | term TIMES value | term DIVIDE value  
    ;
value : identifier | constant | BRA expression KET
    ;
constant : character_constant | number_constant
    ;
character_constant : CHARACTER
    ;
number_constant : MINUS integer | MINUS integer PERIOD integer | integer PERIOD integer | integer
    ;
integer : integer number | number
    ;
identifier : IDENTIFIER
    ;
number : NUMBER
    ;
%%

/* Code for routines for managing the Parse Tree */

TERNARY_TREE create_node(int ival, int case_identifier, TERNARY_TREE p1,
			 TERNARY_TREE  p2, TERNARY_TREE  p3)
{
    TERNARY_TREE t;
    t = (TERNARY_TREE)malloc(sizeof(TREE_NODE));
    if (t == NULL) { 
	    fprintf(stderr, "create_node:Out of memory: %d %lu bytes\n", case_identifier, sizeof(TREE_NODE));
		return(t); 
		} 
    t->item = ival;
    t->nodeIdentifier = case_identifier;
    t->first = p1;
    t->second = p2;
    t->third = p3;
    return (t);
}

#include "lex.yy.c"