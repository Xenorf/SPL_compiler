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
#include <string.h>

/* make forward declarations to avoid compiler warnings */
int yylex (void);
void yyerror (char *);

/* Some constants.*/

#define SYMTABSIZE     50
#define IDLENGTH       15
#define TYPELENGTH     15
#define NOTHING        -1
#define DEST_SIZE 40

  enum ParseTreeNodeType { PROGRAM, BLOCK, DECLARATION_BLOCK, IDENTIFIER_LIST, TYPE_VALUE, STATEMENT_LIST, STATEMENT, ASSIGNMENT_STATEMENT, IF_STATEMENT, DO_STATEMENT, WHILE_STATEMENT, FOR_STATEMENT, WRITE_STATEMENT, READ_STATEMENT, OUTPUT_LIST, CONDITIONAL, COMPARATOR, EXPRESSION, TERM, VALUE, CONSTANT, CHARACTER_CONSTANT, NUMBER_CONSTANT, INTEGER, IDENTIFIER_VALUE, NUMBER_VALUE } ;  

  char *NodeName[] = {"PROGRAM", "BLOCK", "DECLARATION_BLOCK", "IDENTIFIER_LIST", "TYPE_VALUE", "STATEMENT_LIST", "STATEMENT", "ASSIGNMENT_STATEMENT", "IF_STATEMENT", "DO_STATEMENT", "WHILE_STATEMENT", "FOR_STATEMENT", "WRITE_STATEMENT", "READ_STATEMENT", "OUTPUT_LIST", "CONDITIONAL", "COMPARATOR", "EXPRESSION", "TERM", "VALUE", "CONSTANT", "CHARACTER_CONSTANT", "NUMBER_CONSTANT", "INTEGER", "IDENTIFIER_VALUE", "NUMBER_VALUE"} ;

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
typedef  TREE_NODE *TERNARY_TREE;

/* ------------- forward declarations --------------------------- */

TERNARY_TREE create_node(int,int,TERNARY_TREE,TERNARY_TREE,TERNARY_TREE);
void PrintTree(TERNARY_TREE);
char* GenerateCode(TERNARY_TREE);

/* ------------- symbol table definition --------------------------- */

struct symTabNode {
    char identifier[IDLENGTH];
    char type;
};

typedef  struct symTabNode SYMTABNODE;
typedef  SYMTABNODE        *SYMTABNODEPTR;

SYMTABNODEPTR  symTab[SYMTABSIZE]; 

int currentSymTabSize = 0;
char currentType;
int inDeclarationBlock = 0;

%}

%start  program

%union {
    int iVal;
    TERNARY_TREE  tVal;
}

%token ENDP DECLARATIONS CODE TYPE CHARACTER_TYPE INTEGER_TYPE REAL_TYPE IF THEN ENDIF ELSE DO WHILE ENDDO ENDWHILE FOR IS BY TO ENDFOR WRITE NEWLINE READ NOT AND OR OF GREATER_THAN_OR_EQUAL LESS_THAN_OR_EQUAL NOT_EQUAL LESS_THAN GREATER_THAN EQUAL ASSIGNEMENT MINUS PLUS TIMES DIVIDE BRA KET COLON PERIOD COMMA SEMICOLON
%token<iVal> IDENTIFIER NUMBER CHARACTER
%type<tVal> program block declaration_block identifier_list type statement_list statement assignment_statement if_statement do_statement while_statement for_statement write_statement read_statement output_list conditional comparator expression term value constant number_constant integer
%%
program : IDENTIFIER COLON block ENDP IDENTIFIER PERIOD
    {       
        TERNARY_TREE ParseTree;
        ParseTree = create_node($1,PROGRAM,$3,NULL,NULL);
        #ifdef PRINTTREE
        PrintTree(ParseTree);
        #endif
        #ifdef GENCODE
        GenerateCode(ParseTree);
        #endif
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
identifier_list : IDENTIFIER
    {
        $$ = create_node($1,IDENTIFIER_VALUE,NULL,NULL,NULL);
    }
    | identifier_list COMMA IDENTIFIER
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
assignment_statement : expression ASSIGNEMENT IDENTIFIER
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
for_statement : FOR IDENTIFIER IS expression BY expression TO expression DO statement_list ENDFOR
    {
        $$ = create_node($2,FOR_STATEMENT,$4,create_node($2,FOR_STATEMENT,$6,$8,NULL),$10);
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
read_statement : READ BRA IDENTIFIER KET
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
        $$ = create_node(NOT,CONDITIONAL,$2,NULL,NULL);
    }
    | expression comparator expression AND conditional
    {
        $$ = create_node(AND,CONDITIONAL,create_node(NOTHING,CONDITIONAL,$1,$2,$3),$5,NULL);
    }
    | expression comparator expression OR conditional//how ? more than 3
    {
        $$ = create_node(OR,CONDITIONAL,create_node(NOTHING,CONDITIONAL,$1,$2,$3),$5,NULL);
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
        $$ = create_node(PLUS,EXPRESSION,$1,$3,NULL);
    }
    | expression MINUS term 
    {
        $$ = create_node(MINUS,EXPRESSION,$1,$3,NULL);
    }
    ;
term : value
    {
        $$ = create_node(NOTHING,TERM,$1,NULL,NULL);
    }
    | term TIMES value
    {
        $$ = create_node(TIMES,TERM,$1,$3,NULL);
    }
    | term DIVIDE value
    {
        $$ = create_node(DIVIDE,TERM,$1,$3,NULL);
    }
    ;
value : IDENTIFIER
    {
        $$ = create_node($1,IDENTIFIER_VALUE,NULL,NULL,NULL);
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
constant : CHARACTER
    {
        $$ = create_node($1,CHARACTER_CONSTANT,NULL,NULL,NULL);
    }
    | number_constant
    {
        $$ = create_node(NOTHING,CONSTANT,$1,NULL,NULL);
    }
    ;
number_constant : MINUS integer
    {
        $$ = create_node(MINUS,NUMBER_CONSTANT,$2,NULL,NULL);
    }
    | MINUS integer PERIOD integer
    {
        $$ = create_node(MINUS+PERIOD,NUMBER_CONSTANT,$2,$4,NULL);
    }
    | integer PERIOD integer
    {
        $$ = create_node(PERIOD,NUMBER_CONSTANT,$1,$3,NULL);
    }
    | integer
    {
        $$ = create_node(NOTHING,NUMBER_CONSTANT,$1,NULL,NULL);
    }
    ;
integer : NUMBER
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
#ifdef PRINTTREE
void PrintTree(TERNARY_TREE t)
{
    if (t == NULL) {
        printf("\"NULL\"");
        return;
    }
    if (t->item != NOTHING) {
        if (t->item == NEWLINE) {
            printf("{\"%s\":\"NEWLINE\"}",NodeName[t->nodeIdentifier]);
            return;
        } else if (t->nodeIdentifier == IDENTIFIER_VALUE) {
            printf("{\"%s\":\"%s\"}",NodeName[t->nodeIdentifier],symTab[t->item]->identifier);
            return;
        } else if (t->nodeIdentifier == TYPE_VALUE && t->item == CHARACTER_TYPE) {
            printf("{\"%s\":\"CHARACTER_TYPE\"}",NodeName[t->nodeIdentifier]);
            return;
        } else if (t->nodeIdentifier == TYPE_VALUE && t->item == INTEGER_TYPE) {
            printf("{\"%s\":\"INTEGER_TYPE\"}",NodeName[t->nodeIdentifier]);
            return;
        } else if (t->nodeIdentifier == TYPE_VALUE && t->item == REAL_TYPE) {
            printf("{\"%s\":\"REAL_TYPE\"}",NodeName[t->nodeIdentifier]);
            return;
        } else if (t->nodeIdentifier == COMPARATOR && t->item == EQUAL) {
            printf("{\"%s\":\"=\"}",NodeName[t->nodeIdentifier]);
            return;
        } else if (t->nodeIdentifier == COMPARATOR && t->item == NOT_EQUAL) {
            printf("{\"%s\":\"<>\"}",NodeName[t->nodeIdentifier]);
            return;
        } else if (t->nodeIdentifier == COMPARATOR && t->item == GREATER_THAN) {
            printf("{\"%s\":\">\"}",NodeName[t->nodeIdentifier]);
            return;
        } else if (t->nodeIdentifier == COMPARATOR && t->item == LESS_THAN) {
            printf("{\"%s\":\"<\"}",NodeName[t->nodeIdentifier]);
            return;
        } else if (t->nodeIdentifier == COMPARATOR && t->item == LESS_THAN_OR_EQUAL) {
            printf("{\"%s\":\"<=\"}",NodeName[t->nodeIdentifier]);
            return;
        } else if (t->nodeIdentifier == COMPARATOR && t->item == GREATER_THAN_OR_EQUAL) {
            printf("{\"%s\":\">=\"}",NodeName[t->nodeIdentifier]);
            return;
        } else if (t->nodeIdentifier == PROGRAM || t->nodeIdentifier == IDENTIFIER_LIST || t->nodeIdentifier == ASSIGNMENT_STATEMENT || t->nodeIdentifier == FOR_STATEMENT || t->nodeIdentifier == READ_STATEMENT || t->nodeIdentifier == IDENTIFIER_LIST) {
            printf("{\"%s\":\"%s\",\"children\":[",NodeName[t->nodeIdentifier],symTab[t->item]->identifier);
        } else if (t->nodeIdentifier == NUMBER_VALUE){
            printf("{\"%s\":\"%d\"}",NodeName[t->nodeIdentifier],t->item);
            return;
        } else if (t->nodeIdentifier == CHARACTER_CONSTANT) {
            printf("{\"%s\":\"%s\"}",NodeName[t->nodeIdentifier],symTab[t->item]->identifier);
            return;
        } else {
            printf("{\"%s\":\"%d\",\"children\":[",NodeName[t->nodeIdentifier],t->item);
        }
    } else {
        printf("{\"%s\":\"NOTHING\",\"children\":[",NodeName[t->nodeIdentifier]);
    }
    PrintTree(t->first);
    printf(",");
    PrintTree(t->second);
    printf(",");
    PrintTree(t->third);
    printf("]}");
}
#endif

#ifdef GENCODE
char* GenerateCode(TERNARY_TREE t)
{
    switch(t->nodeIdentifier){
        case PROGRAM:
        printf("#include <stdio.h>\n#include <stdlib.h>\nint main() {\n");
        GenerateCode(t->first);
        printf("return 0;\n}\n");
        break;

        case BLOCK:
        if (t->second == NULL) {
            GenerateCode(t->first);
        } else {
            GenerateCode(t->first);
            GenerateCode(t->second);
        }
        break;

        case DECLARATION_BLOCK: ;
        inDeclarationBlock = 1;
        char *myDeclaration = malloc (sizeof (char) * DEST_SIZE);
        GenerateCode(t->second);
        myDeclaration = GenerateCode(t->first);
        if (t->first->nodeIdentifier == IDENTIFIER_VALUE) {
            strcpy(myDeclaration,symTab[t->first->item]->identifier);
        }
        printf("%s;\n",myDeclaration);
        if (t->third != NULL) {
            GenerateCode(t->third);
        }
        inDeclarationBlock = 0;
        break;

        case TYPE_VALUE:
        if (t->item == CHARACTER_TYPE) {
            currentType = 'c';
            printf("char ");
        } else if (t->item == INTEGER_TYPE) {
            currentType = 'd';
            printf("int ");
        } else if (t->item == REAL_TYPE) {
            currentType = 'f';
            printf("float ");
        }
        break;

        case IDENTIFIER_VALUE: ;
        if (inDeclarationBlock) {
            symTab[t->item]->type = currentType;
        }
        int length = snprintf( NULL, 0, "%d", t->item );
        char* myIdentifier = malloc( length + 1 );
        snprintf( myIdentifier, length + 1, "%d", t->item );
        return myIdentifier;
        break;

        case IDENTIFIER_LIST: ;
        if (inDeclarationBlock) {//define type when we are in the declaration block
            symTab[t->item]->type = currentType;
        }
        char *myIdentifierList = malloc (sizeof (char) * DEST_SIZE);
        if (t->first->nodeIdentifier == IDENTIFIER_VALUE) {
            GenerateCode(t->first);
            strcpy(myIdentifierList,symTab[t->first->item]->identifier);
        } else {
            myIdentifierList = GenerateCode(t->first);
        }
        strcat(myIdentifierList,",");
        strcat(myIdentifierList,symTab[t->item]->identifier);
        
        return myIdentifierList;
        break;

        case STATEMENT_LIST:
        if (t->second == NULL) {
            GenerateCode(t->first);
        } else {
            GenerateCode(t->first);
            GenerateCode(t->second);
        }
        break;

        case STATEMENT:
        GenerateCode(t->first);
        break;

        case READ_STATEMENT:
        printf("scanf(\" %%%c\", &%s);\n",symTab[t->item]->type,symTab[t->item]->identifier);
        break;

        case ASSIGNMENT_STATEMENT:
        printf("%s = %s;\n",symTab[t->item]->identifier,GenerateCode(t->first));
        break;

        case EXPRESSION: ;
        char *myExpression = malloc (sizeof (char) * DEST_SIZE);
        strcpy(myExpression,GenerateCode(t->first));
        if (t->item == PLUS) {
            strcat(myExpression," + ");
            strcat(myExpression,GenerateCode(t->second));
        } else if (t->item == MINUS) {
            strcat(myExpression," - ");
            strcat(myExpression,GenerateCode(t->second));
        }
        return myExpression;
        break;

        case TERM: ;
        char *myTerm = malloc (sizeof (char) * DEST_SIZE);
        if (t->first->nodeIdentifier == IDENTIFIER_VALUE) {
            strcpy(myTerm,symTab[t->first->item]->identifier);
        } else {
            strcpy(myTerm,GenerateCode(t->first));
        }
        if (t->item == TIMES) {
            strcat(myTerm," * ");
        } else if (t->item == DIVIDE) {
            strcat(myTerm," / ");
        }
        if (t->item != NOTHING) {
            if (t->second->nodeIdentifier == IDENTIFIER_VALUE) {
                strcat(myTerm,symTab[t->second->item]->identifier);
            } else {
                strcat(myTerm,GenerateCode(t->second));
            }
        }
        return myTerm;
        break;

        case WRITE_STATEMENT:
        if (t->item == NEWLINE) {
            printf("printf(\"\\n\");\n");
        }
        else {
            char* myWriteStatement = GenerateCode(t->first);
            if (myWriteStatement!=0){
                if (strpbrk(myWriteStatement,"+-/*")){
                    printf("printf(\"%%d\",(%s));\n",myWriteStatement);
                } else {
                    printf("printf(\"%%s\",\"%s\");\n",myWriteStatement);
                }
            }
        }
        break;

        case IF_STATEMENT:
        if (t->third == NULL) {
            printf("if (");
            GenerateCode(t->first);
            printf("){\n");
            GenerateCode(t->second);
            printf("}\n");
        }
        else {
            printf("if (");
            GenerateCode(t->first);
            printf("){\n");
            GenerateCode(t->second);
            printf("} else {\n");
            GenerateCode(t->third);
            printf("}\n");
        }
        break;

        case WHILE_STATEMENT:
        printf("while (");
        GenerateCode(t->first);
        printf("){\n");
        GenerateCode(t->second);
        printf("}\n");
        break;

        case DO_STATEMENT:
        printf("do {\n");
        GenerateCode(t->first);
        printf("} while (");
        GenerateCode(t->second);
        printf(");\n");
        break;

        case FOR_STATEMENT: ;
        char *isStatement = malloc (sizeof (char) * DEST_SIZE);
        char *byStatement = malloc (sizeof (char) * DEST_SIZE);
        char *toStatement = malloc (sizeof (char) * DEST_SIZE);
        if (t->third!=NULL) {
            isStatement=GenerateCode(t->first);
            printf("for (%s=%s;",symTab[t->item]->identifier,isStatement);
            GenerateCode(t->second);
            printf("){\n");
            GenerateCode(t->third);
            printf("}\n");
        } else {
            byStatement = GenerateCode(t->first);
            toStatement = GenerateCode(t->second);
            printf("(%s-(%s))*(%s/abs(%s))<=0;%s+=%s",symTab[t->item]->identifier,toStatement,byStatement,byStatement,symTab[t->item]->identifier,byStatement);
        }
        break;

        case OUTPUT_LIST: ;
        char *myOutputList = malloc (sizeof (char) * DEST_SIZE);
        strcpy(myOutputList,GenerateCode(t->first));
        if (t->first->nodeIdentifier == IDENTIFIER_VALUE) {
            printf("printf(\"%%%c\", %s);\n",symTab[t->first->item]->type,symTab[t->first->item]->identifier);
            return 0;
        }
        if (t->second != NULL) {
            strcat(myOutputList,GenerateCode(t->second));
        } else {
            return myOutputList;
        }
        break;

        case CONDITIONAL:
        if (t->item == AND) {
            GenerateCode(t->first);
            printf(" && ");
            GenerateCode(t->second);
        } else if (t->item == OR) {
            GenerateCode(t->first);
            printf(" || ");
            GenerateCode(t->second);
        } else if (t->item == NOT) {
            printf("!(");
            GenerateCode(t->first);
            printf(")");
        } else {
            printf("%s",GenerateCode(t->first));
            GenerateCode(t->second);
            printf("%s",GenerateCode(t->third));
        }
        break;

        case COMPARATOR:
        if (t->item == EQUAL) {
            printf(" == ");
        } else if (t->item == NOT_EQUAL) {
            printf(" != ");
        } else if (t->item == LESS_THAN) {
            printf(" < ");
        } else if (t->item == GREATER_THAN) {
            printf(" > ");
        } else if (t->item == GREATER_THAN_OR_EQUAL) {
            printf(" >= ");
        } else if (t->item == LESS_THAN_OR_EQUAL) {
            printf(" <= ");
        }
        break;

        case VALUE: ;
        char* myValue = GenerateCode(t->first);
        return myValue;
        break;

        case CONSTANT: ;
        char* myConstant = GenerateCode(t->first);
        return myConstant;
        break;

        case CHARACTER_CONSTANT:
        return symTab[t->item]->identifier;
        break;

        case NUMBER_CONSTANT: ;
        char *myNumberConstant = malloc (sizeof (char) * DEST_SIZE);
        if (t->item == PERIOD) {
            strcpy(myNumberConstant,GenerateCode(t->first));
            strcat(myNumberConstant,".");
            strcat(myNumberConstant,GenerateCode(t->second));
        } else if (t->item == MINUS+PERIOD) {
            strcpy(myNumberConstant,"-");
            strcat(myNumberConstant,GenerateCode(t->first));
            strcat(myNumberConstant,".");
            strcat(myNumberConstant,GenerateCode(t->second));
        } else if (t->item == MINUS) {
            strcpy(myNumberConstant,"-");
            strcat(myNumberConstant,GenerateCode(t->first));
        } else {
            strcpy(myNumberConstant,GenerateCode(t->first));
        }
        return myNumberConstant;
        printf("%s",myNumberConstant);
        break;

        case NUMBER_VALUE: ;
        int length_number_value = snprintf( NULL, 0, "%d", t->item );
        char* myNumberValue = malloc( length_number_value + 1 );
        snprintf( myNumberValue, length_number_value + 1, "%d", t->item );
        return myNumberValue;
        break;
    }
}
#endif

#include "lex.yy.c"