%{
/*Built upon SPL01skeleton.y - by Peter Parsons*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

/*Make forward declarations to avoid compiler warnings*/
int yylex (void);
void yyerror (char *);

/*Some constants.*/
#define SYMTABSIZE     50
#define IDLENGTH       15
#define TYPELENGTH     15
#define NOTHING        -1
#define DEST_SIZE      1000

  enum ParseTreeNodeType { PROGRAM_SEMENTIC_CHECK, PROGRAM, BLOCK, DECLARATION_BLOCK, IDENTIFIER_LIST, TYPE_VALUE, STATEMENT_LIST, STATEMENT, ASSIGNMENT_STATEMENT, IF_STATEMENT, DO_STATEMENT, WHILE_STATEMENT, FOR_STATEMENT, WRITE_STATEMENT, READ_STATEMENT, OUTPUT_LIST, CONDITIONAL, COMPARATOR, EXPRESSION, TERM, VALUE, CONSTANT, CHARACTER_CONSTANT, NUMBER_CONSTANT, INTEGER, IDENTIFIER_VALUE, NUMBER_VALUE } ;  

  char *NodeName[] = {"PROGRAM_SEMENTIC_CHECK", "PROGRAM", "BLOCK", "DECLARATION_BLOCK", "IDENTIFIER_LIST", "TYPE_VALUE", "STATEMENT_LIST", "STATEMENT", "ASSIGNMENT_STATEMENT", "IF_STATEMENT", "DO_STATEMENT", "WHILE_STATEMENT", "FOR_STATEMENT", "WRITE_STATEMENT", "READ_STATEMENT", "OUTPUT_LIST", "CONDITIONAL", "COMPARATOR", "EXPRESSION", "TERM", "VALUE", "CONSTANT", "CHARACTER_CONSTANT", "NUMBER_CONSTANT", "INTEGER", "IDENTIFIER_VALUE", "NUMBER_VALUE"} ;

#ifndef TRUE
#define TRUE 1
#endif

#ifndef FALSE
#define FALSE 0
#endif

#ifndef NULL
#define NULL 0
#endif

/*Parse tree definition */
struct treeNode {
    int  item;
    int  nodeIdentifier;
    struct treeNode *first;
    struct treeNode *second;
    struct treeNode *third;
  };

typedef  struct treeNode TREE_NODE;
typedef  TREE_NODE *TERNARY_TREE;

/*Forward declarations*/
TERNARY_TREE create_node(int,int,TERNARY_TREE,TERNARY_TREE,TERNARY_TREE);
void PrintTree(TERNARY_TREE);
char* GenerateCode(TERNARY_TREE);
char peek();
char get();
int expression();
int number();
int factor();
int term();
char EvaluateExpressionType(char*);
char* OptimizeExpression(char*);
extern int lookup(char*);
int ContainsLetter(char*);

/*Symbol table definition*/
struct symTabNode {
    char identifier[IDLENGTH];
    char type;  /*variable to determine the type of identifiers when they are declared*/
    char state; /*variable to keep track the declaration and initialization of identifiers*/
};
typedef  struct symTabNode SYMTABNODE;
typedef  SYMTABNODE        *SYMTABNODEPTR;
SYMTABNODEPTR  symTab[SYMTABSIZE]; 

/*Definition of global values used in the GenerateCode function*/
int currentSymTabSize = 0;
char currentType;
int inDeclarationBlock = 0;
int nbForLoop = 0;
char *expressionToParse;
extern int yydebug;
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
        ParseTree = create_node($1,PROGRAM,$3,create_node($5,PROGRAM_SEMENTIC_CHECK,NULL,NULL,NULL),NULL);
        #ifdef DEBUG
        PrintTree(ParseTree);
        #else
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
    |  value COMMA output_list
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
    | expression comparator expression OR conditional
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
        $$ = create_node(BRA,VALUE,$2,NULL,NULL);
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

/*Function to create a new node in the parse tree*/
TERNARY_TREE create_node(int ival, int case_identifier, TERNARY_TREE p1,
			 TERNARY_TREE  p2, TERNARY_TREE  p3)
{
    TERNARY_TREE t;
    t = (TERNARY_TREE)malloc(sizeof(TREE_NODE));
    if (t == NULL) { 
	    fprintf(stderr, "\033[0;31m[ERROR]\033[0m create_node:Out of memory: %d %lu bytes\n", case_identifier, sizeof(TREE_NODE));
		return(t); 
		} 
    t->item = ival;
    t->nodeIdentifier = case_identifier;
    t->first = p1;
    t->second = p2;
    t->third = p3;
    return (t);
}

/*Function to print a tree in a JSON format, meant to be used as input in GraphViz to generate a graphical representation of the tree*/
#ifdef DEBUG
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

#if !defined(DEBUG)
/* Set of functions taken from the user Henrik on https://stackoverflow.com/questions/9329406/evaluating-arithmetic-expressions-from-string-in-c to do arithmetic on expressions inside strings*/
char peek()
{
    return *expressionToParse;
}

char get()
{
    return *expressionToParse++;
}

int number()
{
    int result;
    result = get() - '0';
    while (peek() >= '0' && peek() <= '9')
    {
        result = 10*result + get() - '0';
    }
    return result;
}

int factor()
{
    int result;
    if (peek() >= '0' && peek() <= '9')
        return number();
    else if (peek() == '(')
    {
        get();
        result = expression();
        get();
        return result;
    }
    else if (peek() == '-')
    {
        get();
        return -factor();
    }
    return 0;
}

int term()
{
    int result;
    result = factor();
    while (peek() == '*' || peek() == '/')
        if (get() == '*')
            result *= factor();
        else
            result /= factor();
    return result;
}

int expression()
{
    int result;
    result = term();
    while (peek() == '+' || peek() == '-')
        if (get() == '+')
            result += term();
        else
            result -= term();
    return result;
}


/* Function taken from the user Magos on https://cboard.cprogramming.com/c-programming/37511-checking-if-string-contains-letter.html */
int ContainsLetter(char* string)
{
   if(string == NULL) return FALSE;
 
   while((*string) != '\0')
   {
      if(isalpha(*string)) return TRUE;
      string++;
   }
 
   return FALSE;
}

/*Function to parse the terms of an expression contained in a string*/
int Isolateterms(char src[], char *arithmetic_terms[])
{
    int toknum = 0, i = 0;
    const char delimiters[] = "+*-/()";
    char *token = strtok(src, delimiters);
    while (token != NULL)
    {
        arithmetic_terms[i] = malloc(strlen(token)+1);
        strcpy(arithmetic_terms[i], token);
        token = strtok(NULL, delimiters);
        i+=1;
    }
    return i;
}

/*Function to evaluate the type of a string and throw errors when they aren't compatible*/
char EvaluateExpressionType(char* pExpression) {
    int j,nbTerms;
    char* arithmetic_terms[10];
    char src[DEST_SIZE];
    char type,lastType;
    strcpy(src,pExpression);
    nbTerms = Isolateterms(src, arithmetic_terms);
    for (j=0;j<nbTerms;j++) {
        if (lookup(arithmetic_terms[j])!=-1 && !strpbrk(arithmetic_terms[j],"'")) {
             if (!symTab[lookup(arithmetic_terms[j])]->state){
                fprintf(stderr,"\033[0;31m[ERROR]\033[0m Undeclared identifier (%s)\n",symTab[lookup(arithmetic_terms[j])]->identifier);
                exit(1);
            } else if (symTab[lookup(arithmetic_terms[j])]->state!='i') {
                fprintf(stderr,"\033[0;33m[WARNING]\033[0m Use of uninitialized identifier (%s)\n",symTab[lookup(arithmetic_terms[j])]->identifier);
            }
            type = symTab[lookup(arithmetic_terms[j])]->type;
        } else if (!ContainsLetter(arithmetic_terms[j]) && strpbrk(arithmetic_terms[j],".")){
            type = 'f';
        } else if (!ContainsLetter(arithmetic_terms[j])) {
            type = 'd';
        } else if (ContainsLetter(arithmetic_terms[j]) && strpbrk(arithmetic_terms[j],"'")) {
            type = 'c';
        } else {
            fprintf(stderr,"\033[0;31m[ERROR]\033[0m Unknown Type (%s)\n",arithmetic_terms[j]);
            exit(1);
        }
        if (!lastType) {
            lastType=type;
        } else if (type!=lastType) {
            if (type=='f' && lastType=='d'){
                lastType=type;
            } else if (type=='d' && lastType=='f') {
                lastType='f';
            } else {
                fprintf(stderr,"\033[0;31m[ERROR]\033[0m Types of the assignement don't match (%s)\n",pExpression);
                exit(1);
            }
        } 
    }
    return lastType;
}

/*Function to evaluate a string containing only integers*/
char* OptimizeExpression(char* pExpression) {
    char *expression_str,type;
    int int_result,length;
    type = EvaluateExpressionType(pExpression);
    if (!ContainsLetter(pExpression) && type=='d') {
        expressionToParse = pExpression;
        int_result = expression();
        length = snprintf( NULL, 0, "%d", int_result );
        expression_str = malloc( length + 1 );
        snprintf( expression_str, length + 1, "%d", int_result );
        return expression_str;
    }
    return pExpression;
}

/*Function that generate the C code from the parsed tree*/
char* GenerateCode(TERNARY_TREE t)
{
    char *myRegisterStatement,*myProgramContent, *myProgram, *myBlock, *myTypeValue, *myForStatement, *myWhileStatement, *myReadStatement, *myStatement, *myStatementList, *myIfStatement, *myFinalOutputList, *myWriteStatement, *myFinalAssignement, *myDoStatement, *myConditional, *myComparator, evalutionIsStatement,evalutionByStatement,evalutionToStatement,evalutionAssignement,*myAssignement, *myDeclaration, *myIdentifier, *myIdentifierList, *myExpression, *myTerm, *myOutputList,*isStatement,*toStatement,*byStatement,*myNumberValue, *myConstant, *myValue, *firstMember, *secondMember, *myNumberConstant;
    int length,length_number_value,i,length_reserved;
    char * reserved_words [] = { "auto","else","long","switch","break","enum","register","typedef","case","extern","return","union","char","float","short","unsigned","const","for","signed","void","continue","goto","sizeof","volatile","default","if","static","while","do","int","struct","_Packed","double" };
    
    switch(t->nodeIdentifier){
        case PROGRAM:
        myProgram = malloc (sizeof (char) * DEST_SIZE);
        myProgramContent = malloc (sizeof (char) * DEST_SIZE);
        myRegisterStatement = malloc (sizeof (char) * DEST_SIZE);
        if (t->item != t->second->item) {
            fprintf(stderr,"\033[0;33m[WARNING]\033[0m Program identifiers don't match (%s,%s)\n",symTab[t->item]->identifier,symTab[t->second->item]->identifier);
        }
        strcpy(myProgram,"#include <stdio.h>\n#include <stdlib.h>\nint main() {\n");
        strcpy(myProgramContent,GenerateCode(t->first));
        for (i=0;i<nbForLoop;i++) {
            snprintf(myRegisterStatement, DEST_SIZE, "register int _by%d;\n", i+1);
            strcat(myProgram,myRegisterStatement);
        }
        strcat(myProgram,myProgramContent);
        strcat(myProgram,"return 0;\n}\n");
        
        printf("%s",myProgram);
        break;

        case BLOCK:
        myBlock = malloc (sizeof (char) * DEST_SIZE);
        if (t->second == NULL) {
            strcpy(myBlock,GenerateCode(t->first));
        } else {
            strcpy(myBlock,GenerateCode(t->first));
            strcat(myBlock,GenerateCode(t->second));
        }
        return myBlock;

        case DECLARATION_BLOCK: ;
        myDeclaration = malloc (sizeof (char) * DEST_SIZE);
        inDeclarationBlock = 1;
        strcpy(myDeclaration,GenerateCode(t->second));
        if (t->first->nodeIdentifier == IDENTIFIER_VALUE) {
            GenerateCode(t->first);
            strcat(myDeclaration,symTab[t->first->item]->identifier);
        } else {
            strcat(myDeclaration,GenerateCode(t->first));
        }
        strcat(myDeclaration,";\n");
        if (t->third != NULL) {
            strcat(myDeclaration,GenerateCode(t->third));
        }
        inDeclarationBlock = 0;
        return myDeclaration;

        case TYPE_VALUE:
        myTypeValue = malloc (sizeof (char) * DEST_SIZE);
        if (t->item == CHARACTER_TYPE) {
            currentType = 'c';
            strcpy(myTypeValue,"char ");
        } else if (t->item == INTEGER_TYPE) {
            currentType = 'd';
            strcpy(myTypeValue,"int ");
        } else if (t->item == REAL_TYPE) {
            currentType = 'f';
            strcpy(myTypeValue,"float ");
        }
        return myTypeValue;
        break;

        case IDENTIFIER_VALUE: ;
        length_reserved = sizeof(reserved_words)/sizeof(reserved_words[0]);
        for(i = 0; i < length_reserved; ++i)
        {
            if(!strcmp(reserved_words[i], symTab[t->item]->identifier))
            {
                strcat(symTab[t->item]->identifier,"_r");
            }
        }
        length = snprintf( NULL, 0, "%d", t->item );
        myIdentifier = malloc( length + 1 );
        snprintf( myIdentifier, length + 1, "%d", t->item );
        if (inDeclarationBlock) {
            symTab[t->item]->type = currentType;
            if (symTab[t->item]->state) {
                fprintf(stderr,"\033[0;31m[ERROR]\033[0m Identifier already declared (%s)\n",symTab[t->item]->identifier);
                exit(1);
            }
            symTab[t->item]->state = 'd';
        }
        return myIdentifier;

        case IDENTIFIER_LIST: ;
        if (inDeclarationBlock) {
            symTab[t->item]->type = currentType;
            if (symTab[t->item]->state) {
                fprintf(stderr,"\033[0;31m[ERROR]\033[0m Identifier already declared (%s)\n",symTab[t->item]->identifier);
                exit(1);
            }
            symTab[t->item]->state = 'd';
        }
        myIdentifierList = malloc (sizeof (char) * DEST_SIZE);
        if (t->first->nodeIdentifier == IDENTIFIER_VALUE) {
            GenerateCode(t->first);
            strcpy(myIdentifierList,symTab[t->first->item]->identifier);
        } else {
            myIdentifierList = GenerateCode(t->first);
        }
        strcat(myIdentifierList,",");
        strcat(myIdentifierList,symTab[t->item]->identifier);
        return myIdentifierList;

        case STATEMENT_LIST:
        myStatementList = malloc (sizeof (char) * DEST_SIZE);
        strcpy(myStatementList,GenerateCode(t->first));
        if (t->second != NULL) {
            strcat(myStatementList,GenerateCode(t->second));
        }
        return myStatementList;

        case STATEMENT:
        myStatement = malloc (sizeof (char) * DEST_SIZE);
        strcpy(myStatement,GenerateCode(t->first));
        return myStatement;
        break;

        case READ_STATEMENT:
        myReadStatement = malloc (sizeof (char) * DEST_SIZE);
        if (!symTab[t->item]->state) {
            fprintf(stderr,"\033[0;31m[ERROR]\033[0m Undeclared identifier (%s)\n",symTab[t->item]->identifier);
            exit(1);
        }
        symTab[t->item]->state = 'i';
        strcpy(myReadStatement,"scanf(\" %");
        myReadStatement[strlen(myReadStatement)] = symTab[t->item]->type;
        myReadStatement[strlen(myReadStatement)+1] = '\0';
        strcat(myReadStatement,"\", &");
        strcat(myReadStatement,symTab[t->item]->identifier);
        strcat(myReadStatement,");\n");
        return myReadStatement;

        case ASSIGNMENT_STATEMENT:
        myAssignement = malloc (sizeof (char) * DEST_SIZE);
        myFinalAssignement = malloc (sizeof (char) * DEST_SIZE);
        strcpy(myAssignement,GenerateCode(t->first));
        evalutionAssignement = EvaluateExpressionType(myAssignement);
        if (symTab[t->item]->type == 'd' && evalutionAssignement=='f' && evalutionAssignement!=0) {
            fprintf(stderr,"\033[0;33m[WARNING]\033[0m Casting a float to an integer (%s->%s)\n",myAssignement,symTab[t->item]->identifier);
        } else if (symTab[t->item]->type == 'c' && (evalutionAssignement=='f'||evalutionAssignement=='d') && evalutionAssignement!=0){
            fprintf(stderr,"\033[0;31m[ERROR]\033[0m Types of the assignement don't match (%s->%s)\n",myAssignement,symTab[t->item]->identifier);
            exit(1);
        } else if ((symTab[t->item]->type == 'd' || symTab[t->item]->type == 'f') && evalutionAssignement=='c') {
            fprintf(stderr,"\033[0;31m[ERROR]\033[0m Types of the assignement don't match (%s->%s)\n",myAssignement,symTab[t->item]->identifier);
            exit(1);
        }
        strcpy(myAssignement,OptimizeExpression(myAssignement));
        if (!symTab[t->item]->state) {
            fprintf(stderr,"\033[0;31m[ERROR]\033[0m Undeclared identifier (%s)\n",symTab[t->item]->identifier);
            exit(1);
        }
        symTab[t->item]->state = 'i';
        strcpy(myFinalAssignement,symTab[t->item]->identifier),
        strcat(myFinalAssignement," = ");
        strcat(myFinalAssignement,myAssignement);
        strcat(myFinalAssignement,";\n");
        return myFinalAssignement;

        case EXPRESSION: ;
        myExpression = malloc (sizeof (char) * DEST_SIZE);
        strcpy(myExpression,GenerateCode(t->first));
        if (t->item == PLUS) {
            strcat(myExpression,"+");
            strcat(myExpression,GenerateCode(t->second));
        } else if (t->item == MINUS) {
            strcat(myExpression,"-");
            strcat(myExpression,GenerateCode(t->second));
        }
        return myExpression;

        case TERM: ;
        myTerm = malloc (sizeof (char) * DEST_SIZE);
        if (t->first->nodeIdentifier == IDENTIFIER_VALUE) {
            strcpy(myTerm,symTab[t->first->item]->identifier);
        } else {
            strcpy(myTerm,GenerateCode(t->first));
        }
        if (t->item == TIMES) {
            strcat(myTerm,"*");
        } else if (t->item == DIVIDE) {
            strcat(myTerm,"/");
        }
        if (t->item != NOTHING) {
            if (t->second->nodeIdentifier == IDENTIFIER_VALUE) {
                strcat(myTerm,symTab[t->second->item]->identifier);
            } else {
                strcat(myTerm,GenerateCode(t->second));
            }
        }
        return myTerm;

        case WRITE_STATEMENT:
        myWriteStatement = malloc (sizeof (char) * DEST_SIZE);
        if (t->item == NEWLINE) {
            strcpy(myWriteStatement,"printf(\"\\n\");\n");
        }
        else {
            strcpy(myWriteStatement,GenerateCode(t->first));
        }
        return myWriteStatement;

        case OUTPUT_LIST: ;
        myOutputList = malloc (sizeof (char) * DEST_SIZE);
        myFinalOutputList = malloc (sizeof (char) * DEST_SIZE);
        strcpy(myOutputList,GenerateCode(t->first));
        if (t->first->nodeIdentifier == IDENTIFIER_VALUE) {
            if (!symTab[t->first->item]->state) {
                fprintf(stderr,"\033[0;31m[ERROR]\033[0m Undeclared identifier (%s)\n",symTab[t->first->item]->identifier);
                exit(1);
            } else if (symTab[t->first->item]->state == 'd') {
                fprintf(stderr,"\033[0;33m[WARNING]\033[0m Uninitialized identifier (%s)\n",symTab[t->first->item]->identifier);
            }
            strcpy(myFinalOutputList,"printf(\"%");
            myFinalOutputList[strlen(myFinalOutputList)] = symTab[t->first->item]->type;
            myFinalOutputList[strlen(myFinalOutputList)+1] = '\0';
            strcat(myFinalOutputList,"\", ");
            strcat(myFinalOutputList,symTab[t->first->item]->identifier);
            strcat(myFinalOutputList,");\n");
        } else if (strpbrk(myOutputList,"+-/*")){
            if (!ContainsLetter(myOutputList)) {
                strcpy(myOutputList,OptimizeExpression(myOutputList));
                strcpy(myFinalOutputList,"printf(\"%d\",");
                strcat(myFinalOutputList,myOutputList);
                strcat(myFinalOutputList,");\n");
            } else {
                strcpy(myFinalOutputList,"printf(\"%d\",(");
                strcat(myFinalOutputList,myOutputList);
                strcat(myFinalOutputList,"));\n");
            }
        } else if (strpbrk(myOutputList,"'")){
            strcpy(myFinalOutputList,"printf(\"%c\",");
            strcat(myFinalOutputList,myOutputList);
            strcat(myFinalOutputList,");\n");
        } else {
            strcpy(myFinalOutputList,"printf(\"%d\",");
            strcat(myFinalOutputList,myOutputList);
            strcat(myFinalOutputList,");\n");
        }
        if (t->second != NULL) {
            strcat(myFinalOutputList,GenerateCode(t->second));
        }
        return myFinalOutputList;

        case IF_STATEMENT:
        myIfStatement = malloc (sizeof (char) * DEST_SIZE);
        if (t->third == NULL) {
            strcpy(myIfStatement,"if (");
            strcat(myIfStatement,GenerateCode(t->first));
            strcat(myIfStatement,"){\n");
            strcat(myIfStatement,GenerateCode(t->second));
            strcat(myIfStatement,"}\n");
        }
        else {
            strcpy(myIfStatement,"if (");
            strcat(myIfStatement,GenerateCode(t->first));
            strcat(myIfStatement,"){\n");
            strcat(myIfStatement,GenerateCode(t->second));
            strcat(myIfStatement,"} else {\n");
            strcat(myIfStatement,GenerateCode(t->third));
            strcat(myIfStatement,"}\n");

        }
        return myIfStatement;

        case WHILE_STATEMENT:
        myWhileStatement = malloc (sizeof (char) * DEST_SIZE);
        strcpy(myWhileStatement,"while (");
        strcat(myWhileStatement,GenerateCode(t->first));
        strcat(myWhileStatement,"){\n");
        strcat(myWhileStatement,GenerateCode(t->second));
        strcat(myWhileStatement,"}\n");
        return myWhileStatement;

        case DO_STATEMENT:
        myDoStatement = malloc (sizeof (char) * DEST_SIZE);
        strcpy(myDoStatement,"do {\n");
        strcat(myDoStatement,GenerateCode(t->first));
        strcat(myDoStatement,"} while (");
        strcat(myDoStatement,GenerateCode(t->second));
        strcat(myDoStatement,");\n");
        return myDoStatement;

        case FOR_STATEMENT:
        myForStatement = malloc (sizeof (char) * DEST_SIZE);
        isStatement = malloc (sizeof (char) * DEST_SIZE);
        byStatement = malloc (sizeof (char) * DEST_SIZE);
        toStatement = malloc (sizeof (char) * DEST_SIZE);
        
        if (t->third!=NULL) {
            if (!symTab[t->item]->state) {
                fprintf(stderr,"\033[0;31m[ERROR]\033[0m Undeclared identifier (%s)\n",symTab[t->item]->identifier);
                exit(1);
            }
            symTab[t->item]->state = 'i';
            nbForLoop+=1;
            strcpy(isStatement,OptimizeExpression(GenerateCode(t->first)));
            evalutionIsStatement = EvaluateExpressionType(isStatement);
            if (evalutionIsStatement!='d' && evalutionIsStatement!='f') {
                fprintf(stderr,"\033[0;31m[ERROR]\033[0m Types of the for loop statement aren't valid (%s)\n",isStatement);
                exit(1);
            }
            snprintf(myForStatement, DEST_SIZE+1,"for (%s=%s;",symTab[t->item]->identifier,isStatement);
            strcat(myForStatement,GenerateCode(t->second));
            strcat(myForStatement,GenerateCode(t->third));
            strcat(myForStatement,"}\n");
        } else {
            strcpy(byStatement,OptimizeExpression(GenerateCode(t->first)));
            strcpy(toStatement,OptimizeExpression(GenerateCode(t->second)));
            evalutionByStatement = EvaluateExpressionType(byStatement);
            evalutionToStatement = EvaluateExpressionType(toStatement);
            if (evalutionByStatement!='d' || evalutionToStatement!='d') {
                fprintf(stderr,"\033[0;31m[ERROR]\033[0m Types of the for loop statement aren't valid (%s,%s)\n",byStatement,toStatement);
                exit(1);
            }
            snprintf(myForStatement, DEST_SIZE+1, "_by%d=%s,(%s-(%s))*((_by%d > 0) - (_by%d < 0)) <= 0; %s+=_by%d) {\n",nbForLoop,byStatement,symTab[t->item]->identifier,toStatement,nbForLoop,nbForLoop,symTab[t->item]->identifier,nbForLoop);
        }
        return myForStatement;

        case CONDITIONAL: ;
        firstMember = malloc (sizeof (char) * DEST_SIZE);
        secondMember = malloc (sizeof (char) * DEST_SIZE);
        myConditional = malloc (sizeof (char) * DEST_SIZE);
        if (t->item == AND) {
            strcpy(myConditional,GenerateCode(t->first));
            strcat(myConditional," && ");
            strcat(myConditional,GenerateCode(t->second));
            
        } else if (t->item == OR) {
            strcpy(myConditional,GenerateCode(t->first));
            strcat(myConditional," || ");
            strcat(myConditional,GenerateCode(t->second));
        } else if (t->item == NOT) {
            strcpy(myConditional,"!(");
            strcat(myConditional,GenerateCode(t->first));
            strcat(myConditional,")");
        } else {
            strcpy(firstMember,GenerateCode(t->first));
            if (strpbrk(firstMember,"+/-*")) {
                strcpy(firstMember,OptimizeExpression(firstMember));
            }
            strcpy(myConditional,firstMember);
            strcat(myConditional,GenerateCode(t->second));
            
            
            strcpy(secondMember,GenerateCode(t->third));
            if (strpbrk(secondMember,"+-/*")) {
                strcpy(secondMember,OptimizeExpression(secondMember));
            }
            strcat(myConditional,secondMember);
        }
        return myConditional;

        case COMPARATOR:
        if (t->item == EQUAL) {
            myComparator=" == ";
        } else if (t->item == NOT_EQUAL) {
            myComparator=" != ";
        } else if (t->item == LESS_THAN) {
            myComparator=" < ";
        } else if (t->item == GREATER_THAN) {
            myComparator=" > ";
        } else if (t->item == GREATER_THAN_OR_EQUAL) {
            myComparator=" >= ";
        } else if (t->item == LESS_THAN_OR_EQUAL) {
            myComparator=" <= ";
        }
        return myComparator;

        case VALUE: ;
        myValue = malloc (sizeof (char) * DEST_SIZE);
        if (t->item == BRA) {
            strcpy(myValue,"(");
            strcat(myValue,GenerateCode(t->first));
            strcat(myValue,")");
        } else {
            myValue = GenerateCode(t->first);
        }
        return myValue;

        case CONSTANT: ;
        myConstant = GenerateCode(t->first);
        return myConstant;

        case CHARACTER_CONSTANT:
        return symTab[t->item]->identifier;

        case NUMBER_CONSTANT: ;
        myNumberConstant = malloc (sizeof (char) * DEST_SIZE);
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

        case NUMBER_VALUE: ;
        length_number_value = snprintf( NULL, 0, "%d", t->item );
        myNumberValue = malloc( length_number_value + 1 );
        snprintf( myNumberValue, length_number_value + 1, "%d", t->item );
        return myNumberValue;
    }
}
#endif

#include "lex.yy.c"
