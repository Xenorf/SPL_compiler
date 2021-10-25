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

  enum ParseTreeNodeType { PROGRAM, BLOCK, DECLARATION_BLOCK, IDENTIFIER_LIST, TYPE_VALUE, STATEMENT_LIST, STATEMENT, ASSIGNMENT_STATEMENT, IF_STATEMENT, DO_STATEMENT, WHILE_STATEMENT, FOR_STATEMENT, WRITE_STATEMENT, READ_STATEMENT, OUTPUT_LIST, CONDITIONAL, COMPARATOR, EXPRESSION, TERM, VALUE, CONSTANT, CHARACTER_CONSTANT, NUMBER_CONSTANT, INTEGER, IDENTIFIER_VALUE, NUMBER_VALUE } ;  
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
void PrintTree(TERNARY_TREE);

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

%token ENDP DECLARATIONS CODE TYPE CHARACTER_TYPE INTEGER_TYPE REAL_TYPE IF THEN ENDIF ELSE DO WHILE ENDDO ENDWHILE FOR IS BY TO ENDFOR WRITE NEWLINE READ NOT AND OR OF GREATER_THAN_OR_EQUAL LESS_THAN_OR_EQUAL NOT_EQUAL LESS_THAN GREATER_THAN EQUAL ASSIGNEMENT MINUS PLUS TIMES DIVIDE BRA KET COLON PERIOD COMMA SEMICOLON CHARACTER
%token<iVal> IDENTIFIER NUMBER
%type<tVal> program block declaration_block identifier_list type statement_list statement assignment_statement if_statement do_statement while_statement for_statement write_statement read_statement output_list conditional comparator expression term value constant character_constant number_constant integer
%type<iVal> identifier number
%%
program : identifier COLON block ENDP identifier PERIOD
    {       
        TERNARY_TREE ParseTree;
        ParseTree = create_node($1,PROGRAM,$3,NULL,NULL);
        PrintTree(ParseTree);
    }
    ;
block : DECLARATIONS declaration_block CODE statement_list
    {
        $$ = create_node(NOTHING,BLOCK,$2,$4,NULL);
    }
    | CODE statement_list
    {
        $$ = create_node(NOTHING,BLOCK,$2,NULL,NULL);
    }
    ;
declaration_block : identifier_list OF TYPE type SEMICOLON
    {
        $$ = create_node(NOTHING,DECLARATION_BLOCK,$1,$4,NULL);
    }
    | identifier_list OF TYPE type SEMICOLON declaration_block
    {
        $$ = create_node(NOTHING,DECLARATION_BLOCK,$1,$4,$6);
    }
    ;
identifier_list : identifier
    {
        $$ = create_node($1,IDENTIFIER_LIST,NULL,NULL,NULL);//is it good to pass identifier like this ?
    }
    | identifier_list COMMA identifier
    {
        $$ = create_node($3,IDENTIFIER_LIST,$1,NULL,NULL);
    }
    ;
type : CHARACTER_TYPE
    {
        $$ = create_node(CHARACTER_TYPE,TYPE_VALUE,NULL,NULL,NULL);
    }
    | INTEGER_TYPE
    {
        $$ = create_node(INTEGER_TYPE,TYPE_VALUE,NULL,NULL,NULL);
    }
    | REAL_TYPE
    {
        $$ = create_node(REAL_TYPE,TYPE_VALUE,NULL,NULL,NULL);
    }
    ;
statement_list : statement
    {
        $$ = create_node(NOTHING,STATEMENT_LIST,$1,NULL,NULL);
    }
    | statement_list SEMICOLON statement
    {
        $$ = create_node(NOTHING,STATEMENT_LIST,$1,$3,NULL);
    }
    ;
statement : assignment_statement 
    {
        $$ = create_node(NOTHING,STATEMENT,$1,NULL,NULL);
    }
    | if_statement
    {
        $$ = create_node(NOTHING,STATEMENT,$1,NULL,NULL);
    }
    | do_statement
    {
        $$ = create_node(NOTHING,STATEMENT,$1,NULL,NULL);
    }
    | while_statement
    {
        $$ = create_node(NOTHING,STATEMENT,$1,NULL,NULL);
    }
    | for_statement
    {
        $$ = create_node(NOTHING,STATEMENT,$1,NULL,NULL);
    }
    | write_statement
    {
        $$ = create_node(NOTHING,STATEMENT,$1,NULL,NULL);
    }
    | read_statement
    {
        $$ = create_node(NOTHING,STATEMENT,$1,NULL,NULL);
    }
    ;
assignment_statement : expression ASSIGNEMENT identifier
    {
        $$ = create_node($3,ASSIGNMENT_STATEMENT,$1,NULL,NULL);
    }
    ;
if_statement : IF conditional THEN statement_list ENDIF
    {
        $$ = create_node(NOTHING,IF_STATEMENT,$2,$4,NULL);
    }
    | IF conditional THEN statement_list ELSE statement_list ENDIF
    {
        $$ = create_node(NOTHING,IF_STATEMENT,$2,$4,$6);
    }
    ;
do_statement : DO statement_list WHILE conditional ENDDO
    {
        $$ = create_node(NOTHING,DO_STATEMENT,$2,$4,NULL);
    }
    ;
while_statement : WHILE conditional DO statement_list ENDWHILE
    {
        $$ = create_node(NOTHING,WHILE_STATEMENT,$2,$4,NULL);
    }
    ;
for_statement : FOR identifier IS expression BY expression TO expression DO statement_list ENDFOR
    {
        $$ = create_node($2,FOR_STATEMENT,create_node(NOTHING,FOR_STATEMENT,$4,$6,$8),$10,NULL);
    }
    ;
write_statement : WRITE BRA output_list KET
    {
        $$ = create_node(NOTHING,WRITE_STATEMENT,$3,NULL,NULL);
    }
    | NEWLINE
    {
        $$ = create_node(NEWLINE,WRITE_STATEMENT,NULL,NULL,NULL);
    }
    ;
read_statement : READ BRA identifier KET
    {
        $$ = create_node($3,READ_STATEMENT,NULL,NULL,NULL);
    }
    ;
output_list : value
    {
        $$ = create_node(NOTHING,OUTPUT_LIST,$1,NULL,NULL);
    }
    | output_list COMMA value
    {
        $$ = create_node(NOTHING,OUTPUT_LIST,$1,$3,NULL);
    }
    ;
conditional : NOT conditional
    {
        $$ = create_node(NOTHING,CONDITIONAL,$2,NULL,NULL);
    }
    | expression comparator expression AND conditional//how ? more than 3
    {
        $$ = create_node(NOTHING,CONDITIONAL,create_node(NOTHING,CONDITIONAL,$1,$2,$3),$5,NULL);
    }
    | expression comparator expression OR conditional//how ? more than 3
    {
        $$ = create_node(NOTHING,CONDITIONAL,create_node(NOTHING,CONDITIONAL,$1,$2,$3),$5,NULL);
    }
    | expression comparator expression
    {
        $$ = create_node(NOTHING,CONDITIONAL,$1,$2,$3);
    }
    ;
comparator : EQUAL
    {
        $$ = create_node(EQUAL,COMPARATOR,NULL,NULL,NULL);
    }
    | NOT_EQUAL
    {
        $$ = create_node(NOT_EQUAL,COMPARATOR,NULL,NULL,NULL);
    }
    | LESS_THAN
    {
        $$ = create_node(LESS_THAN,COMPARATOR,NULL,NULL,NULL);
    }
    | GREATER_THAN
    {
        $$ = create_node(GREATER_THAN,COMPARATOR,NULL,NULL,NULL);
    }
    | GREATER_THAN_OR_EQUAL
    {
        $$ = create_node(GREATER_THAN_OR_EQUAL,COMPARATOR,NULL,NULL,NULL);
    }
    | LESS_THAN_OR_EQUAL
    {
        $$ = create_node(LESS_THAN_OR_EQUAL,COMPARATOR,NULL,NULL,NULL);
    }
    ;
expression : term
    {
        $$ = create_node(NOTHING,EXPRESSION,$1,NULL,NULL);
    }
    | expression PLUS term
    {
        $$ = create_node(NOTHING,EXPRESSION,$1,$3,NULL);
    }
    | expression MINUS term 
    {
        $$ = create_node(NOTHING,EXPRESSION,$1,$3,NULL);
    }
    ;
term : value
    {
        $$ = create_node(NOTHING,TERM,$1,NULL,NULL);
    }
    | term TIMES value
    {
        $$ = create_node(NOTHING,TERM,$1,$3,NULL);
    }
    | term DIVIDE value
    {
        $$ = create_node(NOTHING,TERM,$1,$3,NULL);
    }
    ;
value : identifier
    {
        $$ = create_node($1,VALUE,NULL,NULL,NULL);
    }
    | constant
    {
        $$ = create_node(NOTHING,VALUE,$1,NULL,NULL);
    }
    | BRA expression KET
    {
        $$ = create_node(NOTHING,VALUE,$2,NULL,NULL);
    }
    ;
constant : character_constant
    {
        $$ = create_node(NOTHING,CONSTANT,$1,NULL,NULL);
    }
    | number_constant
    {
        $$ = create_node(NOTHING,CONSTANT,$1,NULL,NULL);
    }
    ;
character_constant : CHARACTER
    {
        $$ = create_node(CHARACTER,CHARACTER_CONSTANT,NULL,NULL,NULL);
    }
    ;
number_constant : MINUS integer
    {
        $$ = create_node(NOTHING,NUMBER_CONSTANT,$2,NULL,NULL);
    }
    | MINUS integer PERIOD integer
    {
        $$ = create_node(NOTHING,NUMBER_CONSTANT,$2,$4,NULL);
    }
    | integer PERIOD integer
    {
        $$ = create_node(NOTHING,NUMBER_CONSTANT,$1,$3,NULL);
    }
    | integer
    {
        $$ = create_node(NOTHING,NUMBER_CONSTANT,$1,NULL,NULL);
    }
    ;
integer : integer number
    {
        $$ = create_node($2,INTEGER,$1,NULL,NULL);
    }
    | number
    {
        $$ = create_node($1,INTEGER,NULL,NULL,NULL);
    }
    ;
identifier : IDENTIFIER
    {
        $$ = create_node($1,IDENTIFIER_VALUE,NULL,NULL,NULL);
    }
    ;
number : NUMBER
    {
        $$ = create_node($1,NUMBER_VALUE,NULL,NULL,NULL);
    }
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

void PrintTree(TERNARY_TREE t)
{
   if (t == NULL) return;
   printf("Item: %d", t->item);
   printf(" nodeIdentifier: %d\n",t->nodeIdentifier);
   PrintTree(t->first);
   PrintTree(t->second);
   PrintTree(t->third);
}

#include "lex.yy.c"