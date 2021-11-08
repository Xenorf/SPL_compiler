/* A Bison parser, made by GNU Bison 3.5.1.  */

/* Bison implementation for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2020 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

/* Identify Bison output.  */
#define YYBISON 1

/* Bison version.  */
#define YYBISON_VERSION "3.5.1"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1




/* First part of user prologue.  */
#line 1 "spl.y"

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
#include <ctype.h>
#include "tinyexpr.h"

/* make forward declarations to avoid compiler warnings */
int yylex (void);
void yyerror (char *);

/* Some constants.*/

#define SYMTABSIZE     50
#define IDLENGTH       15
#define TYPELENGTH     15
#define NOTHING        -1
#define DEST_SIZE 40

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
int ContainsLetter(char*);

/* ------------- symbol table definition --------------------------- */

struct symTabNode {
    char identifier[IDLENGTH];
    char type;
    char state;
};

typedef  struct symTabNode SYMTABNODE;
typedef  SYMTABNODE        *SYMTABNODEPTR;

SYMTABNODEPTR  symTab[SYMTABSIZE]; 

int currentSymTabSize = 0;
char currentType;
int inDeclarationBlock = 0;
int nbForLoop = 0;
char * expressionToParse = "0";
char peek();
char get();
int expression();
int number();
int factor();
int term();
char EvaluateExpressionType(char*);
char* OptimizeExpression(char*);


#line 168 "spl.tab.c"

# ifndef YY_CAST
#  ifdef __cplusplus
#   define YY_CAST(Type, Val) static_cast<Type> (Val)
#   define YY_REINTERPRET_CAST(Type, Val) reinterpret_cast<Type> (Val)
#  else
#   define YY_CAST(Type, Val) ((Type) (Val))
#   define YY_REINTERPRET_CAST(Type, Val) ((Type) (Val))
#  endif
# endif
# ifndef YY_NULLPTR
#  if defined __cplusplus
#   if 201103L <= __cplusplus
#    define YY_NULLPTR nullptr
#   else
#    define YY_NULLPTR 0
#   endif
#  else
#   define YY_NULLPTR ((void*)0)
#  endif
# endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 0
#endif


/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 1
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    ENDP = 258,
    DECLARATIONS = 259,
    CODE = 260,
    TYPE = 261,
    CHARACTER_TYPE = 262,
    INTEGER_TYPE = 263,
    REAL_TYPE = 264,
    IF = 265,
    THEN = 266,
    ENDIF = 267,
    ELSE = 268,
    DO = 269,
    WHILE = 270,
    ENDDO = 271,
    ENDWHILE = 272,
    FOR = 273,
    IS = 274,
    BY = 275,
    TO = 276,
    ENDFOR = 277,
    WRITE = 278,
    NEWLINE = 279,
    READ = 280,
    NOT = 281,
    AND = 282,
    OR = 283,
    OF = 284,
    GREATER_THAN_OR_EQUAL = 285,
    LESS_THAN_OR_EQUAL = 286,
    NOT_EQUAL = 287,
    LESS_THAN = 288,
    GREATER_THAN = 289,
    EQUAL = 290,
    ASSIGNEMENT = 291,
    MINUS = 292,
    PLUS = 293,
    TIMES = 294,
    DIVIDE = 295,
    BRA = 296,
    KET = 297,
    COLON = 298,
    PERIOD = 299,
    COMMA = 300,
    SEMICOLON = 301,
    IDENTIFIER = 302,
    NUMBER = 303,
    CHARACTER = 304
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 101 "spl.y"

    int iVal;
    TERNARY_TREE  tVal;

#line 272 "spl.tab.c"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);





#ifdef short
# undef short
#endif

/* On compilers that do not define __PTRDIFF_MAX__ etc., make sure
   <limits.h> and (if available) <stdint.h> are included
   so that the code can choose integer types of a good width.  */

#ifndef __PTRDIFF_MAX__
# include <limits.h> /* INFRINGES ON USER NAME SPACE */
# if defined __STDC_VERSION__ && 199901 <= __STDC_VERSION__
#  include <stdint.h> /* INFRINGES ON USER NAME SPACE */
#  define YY_STDINT_H
# endif
#endif

/* Narrow types that promote to a signed type and that can represent a
   signed or unsigned integer of at least N bits.  In tables they can
   save space and decrease cache pressure.  Promoting to a signed type
   helps avoid bugs in integer arithmetic.  */

#ifdef __INT_LEAST8_MAX__
typedef __INT_LEAST8_TYPE__ yytype_int8;
#elif defined YY_STDINT_H
typedef int_least8_t yytype_int8;
#else
typedef signed char yytype_int8;
#endif

#ifdef __INT_LEAST16_MAX__
typedef __INT_LEAST16_TYPE__ yytype_int16;
#elif defined YY_STDINT_H
typedef int_least16_t yytype_int16;
#else
typedef short yytype_int16;
#endif

#if defined __UINT_LEAST8_MAX__ && __UINT_LEAST8_MAX__ <= __INT_MAX__
typedef __UINT_LEAST8_TYPE__ yytype_uint8;
#elif (!defined __UINT_LEAST8_MAX__ && defined YY_STDINT_H \
       && UINT_LEAST8_MAX <= INT_MAX)
typedef uint_least8_t yytype_uint8;
#elif !defined __UINT_LEAST8_MAX__ && UCHAR_MAX <= INT_MAX
typedef unsigned char yytype_uint8;
#else
typedef short yytype_uint8;
#endif

#if defined __UINT_LEAST16_MAX__ && __UINT_LEAST16_MAX__ <= __INT_MAX__
typedef __UINT_LEAST16_TYPE__ yytype_uint16;
#elif (!defined __UINT_LEAST16_MAX__ && defined YY_STDINT_H \
       && UINT_LEAST16_MAX <= INT_MAX)
typedef uint_least16_t yytype_uint16;
#elif !defined __UINT_LEAST16_MAX__ && USHRT_MAX <= INT_MAX
typedef unsigned short yytype_uint16;
#else
typedef int yytype_uint16;
#endif

#ifndef YYPTRDIFF_T
# if defined __PTRDIFF_TYPE__ && defined __PTRDIFF_MAX__
#  define YYPTRDIFF_T __PTRDIFF_TYPE__
#  define YYPTRDIFF_MAXIMUM __PTRDIFF_MAX__
# elif defined PTRDIFF_MAX
#  ifndef ptrdiff_t
#   include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  endif
#  define YYPTRDIFF_T ptrdiff_t
#  define YYPTRDIFF_MAXIMUM PTRDIFF_MAX
# else
#  define YYPTRDIFF_T long
#  define YYPTRDIFF_MAXIMUM LONG_MAX
# endif
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif defined __STDC_VERSION__ && 199901 <= __STDC_VERSION__
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned
# endif
#endif

#define YYSIZE_MAXIMUM                                  \
  YY_CAST (YYPTRDIFF_T,                                 \
           (YYPTRDIFF_MAXIMUM < YY_CAST (YYSIZE_T, -1)  \
            ? YYPTRDIFF_MAXIMUM                         \
            : YY_CAST (YYSIZE_T, -1)))

#define YYSIZEOF(X) YY_CAST (YYPTRDIFF_T, sizeof (X))

/* Stored state numbers (used for stacks). */
typedef yytype_int8 yy_state_t;

/* State numbers in computations.  */
typedef int yy_state_fast_t;

#ifndef YY_
# if defined YYENABLE_NLS && YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(Msgid) dgettext ("bison-runtime", Msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(Msgid) Msgid
# endif
#endif

#ifndef YY_ATTRIBUTE_PURE
# if defined __GNUC__ && 2 < __GNUC__ + (96 <= __GNUC_MINOR__)
#  define YY_ATTRIBUTE_PURE __attribute__ ((__pure__))
# else
#  define YY_ATTRIBUTE_PURE
# endif
#endif

#ifndef YY_ATTRIBUTE_UNUSED
# if defined __GNUC__ && 2 < __GNUC__ + (7 <= __GNUC_MINOR__)
#  define YY_ATTRIBUTE_UNUSED __attribute__ ((__unused__))
# else
#  define YY_ATTRIBUTE_UNUSED
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YYUSE(E) ((void) (E))
#else
# define YYUSE(E) /* empty */
#endif

#if defined __GNUC__ && ! defined __ICC && 407 <= __GNUC__ * 100 + __GNUC_MINOR__
/* Suppress an incorrect diagnostic about yylval being uninitialized.  */
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN                            \
    _Pragma ("GCC diagnostic push")                                     \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")              \
    _Pragma ("GCC diagnostic ignored \"-Wmaybe-uninitialized\"")
# define YY_IGNORE_MAYBE_UNINITIALIZED_END      \
    _Pragma ("GCC diagnostic pop")
#else
# define YY_INITIAL_VALUE(Value) Value
#endif
#ifndef YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_END
#endif
#ifndef YY_INITIAL_VALUE
# define YY_INITIAL_VALUE(Value) /* Nothing. */
#endif

#if defined __cplusplus && defined __GNUC__ && ! defined __ICC && 6 <= __GNUC__
# define YY_IGNORE_USELESS_CAST_BEGIN                          \
    _Pragma ("GCC diagnostic push")                            \
    _Pragma ("GCC diagnostic ignored \"-Wuseless-cast\"")
# define YY_IGNORE_USELESS_CAST_END            \
    _Pragma ("GCC diagnostic pop")
#endif
#ifndef YY_IGNORE_USELESS_CAST_BEGIN
# define YY_IGNORE_USELESS_CAST_BEGIN
# define YY_IGNORE_USELESS_CAST_END
#endif


#define YY_ASSERT(E) ((void) (0 && (E)))

#if ! defined yyoverflow || YYERROR_VERBOSE

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined EXIT_SUCCESS
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
      /* Use EXIT_SUCCESS as a witness for stdlib.h.  */
#     ifndef EXIT_SUCCESS
#      define EXIT_SUCCESS 0
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's 'empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (0)
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined EXIT_SUCCESS \
       && ! ((defined YYMALLOC || defined malloc) \
             && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef EXIT_SUCCESS
#    define EXIT_SUCCESS 0
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined EXIT_SUCCESS
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined EXIT_SUCCESS
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* ! defined yyoverflow || YYERROR_VERBOSE */


#if (! defined yyoverflow \
     && (! defined __cplusplus \
         || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yy_state_t yyss_alloc;
  YYSTYPE yyvs_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (YYSIZEOF (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (YYSIZEOF (yy_state_t) + YYSIZEOF (YYSTYPE)) \
      + YYSTACK_GAP_MAXIMUM)

# define YYCOPY_NEEDED 1

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)                           \
    do                                                                  \
      {                                                                 \
        YYPTRDIFF_T yynewbytes;                                         \
        YYCOPY (&yyptr->Stack_alloc, Stack, yysize);                    \
        Stack = &yyptr->Stack_alloc;                                    \
        yynewbytes = yystacksize * YYSIZEOF (*Stack) + YYSTACK_GAP_MAXIMUM; \
        yyptr += yynewbytes / YYSIZEOF (*yyptr);                        \
      }                                                                 \
    while (0)

#endif

#if defined YYCOPY_NEEDED && YYCOPY_NEEDED
/* Copy COUNT objects from SRC to DST.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(Dst, Src, Count) \
      __builtin_memcpy (Dst, Src, YY_CAST (YYSIZE_T, (Count)) * sizeof (*(Src)))
#  else
#   define YYCOPY(Dst, Src, Count)              \
      do                                        \
        {                                       \
          YYPTRDIFF_T yyi;                      \
          for (yyi = 0; yyi < (Count); yyi++)   \
            (Dst)[yyi] = (Src)[yyi];            \
        }                                       \
      while (0)
#  endif
# endif
#endif /* !YYCOPY_NEEDED */

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  4
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   131

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  50
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  24
/* YYNRULES -- Number of rules.  */
#define YYNRULES  57
/* YYNSTATES -- Number of states.  */
#define YYNSTATES  121

#define YYUNDEFTOK  2
#define YYMAXUTOK   304


/* YYTRANSLATE(TOKEN-NUM) -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex, with out-of-bounds checking.  */
#define YYTRANSLATE(YYX)                                                \
  (0 <= (YYX) && (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[TOKEN-NUM] -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex.  */
static const yytype_int8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
      35,    36,    37,    38,    39,    40,    41,    42,    43,    44,
      45,    46,    47,    48,    49
};

#if YYDEBUG
  /* YYRLINE[YYN] -- Source line where rule number YYN was defined.  */
static const yytype_int16 yyrline[] =
{
       0,   110,   110,   121,   125,   130,   134,   139,   143,   148,
     152,   156,   161,   165,   170,   174,   178,   182,   186,   190,
     194,   199,   204,   208,   213,   218,   223,   228,   232,   237,
     242,   246,   251,   255,   259,   263,   268,   272,   276,   280,
     284,   288,   293,   297,   301,   306,   310,   314,   319,   323,
     327,   332,   336,   341,   345,   349,   353,   358
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || 0
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "ENDP", "DECLARATIONS", "CODE", "TYPE",
  "CHARACTER_TYPE", "INTEGER_TYPE", "REAL_TYPE", "IF", "THEN", "ENDIF",
  "ELSE", "DO", "WHILE", "ENDDO", "ENDWHILE", "FOR", "IS", "BY", "TO",
  "ENDFOR", "WRITE", "NEWLINE", "READ", "NOT", "AND", "OR", "OF",
  "GREATER_THAN_OR_EQUAL", "LESS_THAN_OR_EQUAL", "NOT_EQUAL", "LESS_THAN",
  "GREATER_THAN", "EQUAL", "ASSIGNEMENT", "MINUS", "PLUS", "TIMES",
  "DIVIDE", "BRA", "KET", "COLON", "PERIOD", "COMMA", "SEMICOLON",
  "IDENTIFIER", "NUMBER", "CHARACTER", "$accept", "program", "block",
  "declaration_block", "identifier_list", "type", "statement_list",
  "statement", "assignment_statement", "if_statement", "do_statement",
  "while_statement", "for_statement", "write_statement", "read_statement",
  "output_list", "conditional", "comparator", "expression", "term",
  "value", "constant", "number_constant", "integer", YY_NULLPTR
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[NUM] -- (External) token number corresponding to the
   (internal) symbol number NUM (which must be that of a token).  */
static const yytype_int16 yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
     275,   276,   277,   278,   279,   280,   281,   282,   283,   284,
     285,   286,   287,   288,   289,   290,   291,   292,   293,   294,
     295,   296,   297,   298,   299,   300,   301,   302,   303,   304
};
# endif

#define YYPACT_NINF (-47)

#define yypact_value_is_default(Yyn) \
  ((Yyn) == YYPACT_NINF)

#define YYTABLE_NINF (-1)

#define yytable_value_is_error(Yyn) \
  0

  /* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
     STATE-NUM.  */
static const yytype_int8 yypact[] =
{
     -46,   -30,    20,    46,   -47,   -24,     7,    26,   -47,    21,
     -21,    32,     7,    32,   -13,     2,   -47,     5,    18,    23,
     -47,   -47,   -47,    40,   -47,   -47,   -47,   -47,   -47,   -47,
     -47,   -47,    52,    58,   -47,   -47,   -47,    34,   -10,     7,
      98,    67,    32,    94,    78,    -1,   103,    99,    23,    72,
      76,    45,     7,    74,    23,    23,    23,    23,    18,    79,
      40,    85,   -47,   -47,     7,   -47,   -47,   -47,   -47,   -47,
     -47,    23,    32,     7,    23,    80,    81,    82,    18,   -47,
     -47,   -47,    58,    58,   -47,   -47,   -47,   -47,   -47,   -47,
     -47,    83,    -7,    47,   109,    11,    39,   -47,    23,   -47,
     -47,   -24,   -47,     7,    32,    32,   -47,   -47,    23,   -47,
     -47,     3,   -47,   -47,    -2,   -47,    23,     4,     7,    -6,
     -47
};

  /* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
     Performed when YYTABLE does not specify something else to do.  Zero
     means the default is an error.  */
static const yytype_int8 yydefact[] =
{
       0,     0,     0,     0,     1,     0,     0,     0,     7,     0,
       0,     0,     0,     0,     0,     0,    28,     0,     0,     0,
      48,    57,    51,     4,    12,    14,    15,    16,    17,    18,
      19,    20,     0,    42,    45,    49,    52,    56,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
      53,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       3,     0,     8,    32,     0,    40,    41,    37,    38,    39,
      36,     0,     0,     0,     0,     0,    30,     0,     0,    50,
      13,    21,    44,    43,    46,    47,    55,     2,     9,    10,
      11,     0,     0,    35,     0,     0,     0,    27,     0,    29,
      54,     5,    22,     0,     0,     0,    24,    25,     0,    31,
       6,     0,    33,    34,     0,    23,     0,     0,     0,     0,
      26
};

  /* YYPGOTO[NTERM-NUM].  */
static const yytype_int8 yypgoto[] =
{
     -47,   -47,   -47,    27,   -47,   -47,   -12,    75,   -47,   -47,
     -47,   -47,   -47,   -47,   -47,    33,    -4,   -47,    -9,    48,
     -45,   -47,   -47,   -11
};

  /* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int8 yydefgoto[] =
{
      -1,     2,     7,     9,    10,    91,    23,    24,    25,    26,
      27,    28,    29,    30,    31,    75,    43,    71,    32,    33,
      34,    35,    36,    37
};

  /* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
     positive, shift that token.  If negative, reduce the rule whose
     number is the opposite.  If YYTABLE_NINF, syntax error.  */
static const yytype_int8 yytable[] =
{
      45,     1,    44,    76,    44,   102,   103,    50,    40,    46,
      51,    84,    85,     3,    72,   115,   120,    11,   118,   116,
       4,    12,    13,     8,    41,    14,    39,    60,   107,    38,
      15,    16,    17,    44,    47,    54,    55,    59,    63,    52,
      52,    54,    55,    48,    18,    52,    49,    86,    19,    52,
       5,     6,    92,    76,    20,    21,    22,    52,    42,   108,
      18,    95,    93,    44,    19,    96,    21,   100,    94,    18,
      20,    21,    22,    19,   104,   105,    54,    55,    58,    20,
      21,    22,    54,    55,    54,    55,    52,    79,    53,    54,
      55,   111,    88,    89,    90,    44,    44,    56,    57,   114,
     112,   113,    82,    83,    61,    64,   119,   117,    65,    66,
      67,    68,    69,    70,    62,    54,    55,    73,    74,    77,
      78,    81,    97,    87,    99,   106,    98,    80,   110,   101,
       0,   109
};

static const yytype_int8 yycheck[] =
{
      12,    47,    11,    48,    13,    12,    13,    18,    29,    13,
      19,    56,    57,    43,    15,    12,    22,    10,    14,    21,
       0,    14,    15,    47,    45,    18,     5,    39,    17,     3,
      23,    24,    25,    42,    47,    37,    38,    47,    42,    46,
      46,    37,    38,    41,    37,    46,    41,    58,    41,    46,
       4,     5,    64,    98,    47,    48,    49,    46,    26,    20,
      37,    73,    71,    72,    41,    74,    48,    78,    72,    37,
      47,    48,    49,    41,    27,    28,    37,    38,    44,    47,
      48,    49,    37,    38,    37,    38,    46,    42,    36,    37,
      38,   103,     7,     8,     9,   104,   105,    39,    40,   108,
     104,   105,    54,    55,     6,    11,   118,   116,    30,    31,
      32,    33,    34,    35,    47,    37,    38,    14,    19,    47,
      44,    47,    42,    44,    42,    16,    45,    52,   101,    46,
      -1,    98
};

  /* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
     symbol of state STATE-NUM.  */
static const yytype_int8 yystos[] =
{
       0,    47,    51,    43,     0,     4,     5,    52,    47,    53,
      54,    10,    14,    15,    18,    23,    24,    25,    37,    41,
      47,    48,    49,    56,    57,    58,    59,    60,    61,    62,
      63,    64,    68,    69,    70,    71,    72,    73,     3,     5,
      29,    45,    26,    66,    68,    56,    66,    47,    41,    41,
      73,    68,    46,    36,    37,    38,    39,    40,    44,    47,
      56,     6,    47,    66,    11,    30,    31,    32,    33,    34,
      35,    67,    15,    14,    19,    65,    70,    47,    44,    42,
      57,    47,    69,    69,    70,    70,    73,    44,     7,     8,
       9,    55,    56,    68,    66,    56,    68,    42,    45,    42,
      73,    46,    12,    13,    27,    28,    16,    17,    20,    65,
      53,    56,    66,    66,    68,    12,    21,    68,    14,    56,
      22
};

  /* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_int8 yyr1[] =
{
       0,    50,    51,    52,    52,    53,    53,    54,    54,    55,
      55,    55,    56,    56,    57,    57,    57,    57,    57,    57,
      57,    58,    59,    59,    60,    61,    62,    63,    63,    64,
      65,    65,    66,    66,    66,    66,    67,    67,    67,    67,
      67,    67,    68,    68,    68,    69,    69,    69,    70,    70,
      70,    71,    71,    72,    72,    72,    72,    73
};

  /* YYR2[YYN] -- Number of symbols on the right hand side of rule YYN.  */
static const yytype_int8 yyr2[] =
{
       0,     2,     6,     4,     2,     5,     6,     1,     3,     1,
       1,     1,     1,     3,     1,     1,     1,     1,     1,     1,
       1,     3,     5,     7,     5,     5,    11,     4,     1,     4,
       1,     3,     2,     5,     5,     3,     1,     1,     1,     1,
       1,     1,     1,     3,     3,     1,     3,     3,     1,     1,
       3,     1,     1,     2,     4,     3,     1,     1
};


#define yyerrok         (yyerrstatus = 0)
#define yyclearin       (yychar = YYEMPTY)
#define YYEMPTY         (-2)
#define YYEOF           0

#define YYACCEPT        goto yyacceptlab
#define YYABORT         goto yyabortlab
#define YYERROR         goto yyerrorlab


#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)                                    \
  do                                                              \
    if (yychar == YYEMPTY)                                        \
      {                                                           \
        yychar = (Token);                                         \
        yylval = (Value);                                         \
        YYPOPSTACK (yylen);                                       \
        yystate = *yyssp;                                         \
        goto yybackup;                                            \
      }                                                           \
    else                                                          \
      {                                                           \
        yyerror (YY_("syntax error: cannot back up")); \
        YYERROR;                                                  \
      }                                                           \
  while (0)

/* Error token number */
#define YYTERROR        1
#define YYERRCODE       256



/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)                        \
do {                                            \
  if (yydebug)                                  \
    YYFPRINTF Args;                             \
} while (0)

/* This macro is provided for backward compatibility. */
#ifndef YY_LOCATION_PRINT
# define YY_LOCATION_PRINT(File, Loc) ((void) 0)
#endif


# define YY_SYMBOL_PRINT(Title, Type, Value, Location)                    \
do {                                                                      \
  if (yydebug)                                                            \
    {                                                                     \
      YYFPRINTF (stderr, "%s ", Title);                                   \
      yy_symbol_print (stderr,                                            \
                  Type, Value); \
      YYFPRINTF (stderr, "\n");                                           \
    }                                                                     \
} while (0)


/*-----------------------------------.
| Print this symbol's value on YYO.  |
`-----------------------------------*/

static void
yy_symbol_value_print (FILE *yyo, int yytype, YYSTYPE const * const yyvaluep)
{
  FILE *yyoutput = yyo;
  YYUSE (yyoutput);
  if (!yyvaluep)
    return;
# ifdef YYPRINT
  if (yytype < YYNTOKENS)
    YYPRINT (yyo, yytoknum[yytype], *yyvaluep);
# endif
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YYUSE (yytype);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}


/*---------------------------.
| Print this symbol on YYO.  |
`---------------------------*/

static void
yy_symbol_print (FILE *yyo, int yytype, YYSTYPE const * const yyvaluep)
{
  YYFPRINTF (yyo, "%s %s (",
             yytype < YYNTOKENS ? "token" : "nterm", yytname[yytype]);

  yy_symbol_value_print (yyo, yytype, yyvaluep);
  YYFPRINTF (yyo, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

static void
yy_stack_print (yy_state_t *yybottom, yy_state_t *yytop)
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)                            \
do {                                                            \
  if (yydebug)                                                  \
    yy_stack_print ((Bottom), (Top));                           \
} while (0)


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

static void
yy_reduce_print (yy_state_t *yyssp, YYSTYPE *yyvsp, int yyrule)
{
  int yylno = yyrline[yyrule];
  int yynrhs = yyr2[yyrule];
  int yyi;
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %d):\n",
             yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr,
                       yystos[+yyssp[yyi + 1 - yynrhs]],
                       &yyvsp[(yyi + 1) - (yynrhs)]
                                              );
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)          \
do {                                    \
  if (yydebug)                          \
    yy_reduce_print (yyssp, yyvsp, Rule); \
} while (0)

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args)
# define YY_SYMBOL_PRINT(Title, Type, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif


#if YYERROR_VERBOSE

# ifndef yystrlen
#  if defined __GLIBC__ && defined _STRING_H
#   define yystrlen(S) (YY_CAST (YYPTRDIFF_T, strlen (S)))
#  else
/* Return the length of YYSTR.  */
static YYPTRDIFF_T
yystrlen (const char *yystr)
{
  YYPTRDIFF_T yylen;
  for (yylen = 0; yystr[yylen]; yylen++)
    continue;
  return yylen;
}
#  endif
# endif

# ifndef yystpcpy
#  if defined __GLIBC__ && defined _STRING_H && defined _GNU_SOURCE
#   define yystpcpy stpcpy
#  else
/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
   YYDEST.  */
static char *
yystpcpy (char *yydest, const char *yysrc)
{
  char *yyd = yydest;
  const char *yys = yysrc;

  while ((*yyd++ = *yys++) != '\0')
    continue;

  return yyd - 1;
}
#  endif
# endif

# ifndef yytnamerr
/* Copy to YYRES the contents of YYSTR after stripping away unnecessary
   quotes and backslashes, so that it's suitable for yyerror.  The
   heuristic is that double-quoting is unnecessary unless the string
   contains an apostrophe, a comma, or backslash (other than
   backslash-backslash).  YYSTR is taken from yytname.  If YYRES is
   null, do not copy; instead, return the length of what the result
   would have been.  */
static YYPTRDIFF_T
yytnamerr (char *yyres, const char *yystr)
{
  if (*yystr == '"')
    {
      YYPTRDIFF_T yyn = 0;
      char const *yyp = yystr;

      for (;;)
        switch (*++yyp)
          {
          case '\'':
          case ',':
            goto do_not_strip_quotes;

          case '\\':
            if (*++yyp != '\\')
              goto do_not_strip_quotes;
            else
              goto append;

          append:
          default:
            if (yyres)
              yyres[yyn] = *yyp;
            yyn++;
            break;

          case '"':
            if (yyres)
              yyres[yyn] = '\0';
            return yyn;
          }
    do_not_strip_quotes: ;
    }

  if (yyres)
    return yystpcpy (yyres, yystr) - yyres;
  else
    return yystrlen (yystr);
}
# endif

/* Copy into *YYMSG, which is of size *YYMSG_ALLOC, an error message
   about the unexpected token YYTOKEN for the state stack whose top is
   YYSSP.

   Return 0 if *YYMSG was successfully written.  Return 1 if *YYMSG is
   not large enough to hold the message.  In that case, also set
   *YYMSG_ALLOC to the required number of bytes.  Return 2 if the
   required number of bytes is too large to store.  */
static int
yysyntax_error (YYPTRDIFF_T *yymsg_alloc, char **yymsg,
                yy_state_t *yyssp, int yytoken)
{
  enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
  /* Internationalized format string. */
  const char *yyformat = YY_NULLPTR;
  /* Arguments of yyformat: reported tokens (one for the "unexpected",
     one per "expected"). */
  char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
  /* Actual size of YYARG. */
  int yycount = 0;
  /* Cumulated lengths of YYARG.  */
  YYPTRDIFF_T yysize = 0;

  /* There are many possibilities here to consider:
     - If this state is a consistent state with a default action, then
       the only way this function was invoked is if the default action
       is an error action.  In that case, don't check for expected
       tokens because there are none.
     - The only way there can be no lookahead present (in yychar) is if
       this state is a consistent state with a default action.  Thus,
       detecting the absence of a lookahead is sufficient to determine
       that there is no unexpected or expected token to report.  In that
       case, just report a simple "syntax error".
     - Don't assume there isn't a lookahead just because this state is a
       consistent state with a default action.  There might have been a
       previous inconsistent state, consistent state with a non-default
       action, or user semantic action that manipulated yychar.
     - Of course, the expected token list depends on states to have
       correct lookahead information, and it depends on the parser not
       to perform extra reductions after fetching a lookahead from the
       scanner and before detecting a syntax error.  Thus, state merging
       (from LALR or IELR) and default reductions corrupt the expected
       token list.  However, the list is correct for canonical LR with
       one exception: it will still contain any token that will not be
       accepted due to an error action in a later state.
  */
  if (yytoken != YYEMPTY)
    {
      int yyn = yypact[+*yyssp];
      YYPTRDIFF_T yysize0 = yytnamerr (YY_NULLPTR, yytname[yytoken]);
      yysize = yysize0;
      yyarg[yycount++] = yytname[yytoken];
      if (!yypact_value_is_default (yyn))
        {
          /* Start YYX at -YYN if negative to avoid negative indexes in
             YYCHECK.  In other words, skip the first -YYN actions for
             this state because they are default actions.  */
          int yyxbegin = yyn < 0 ? -yyn : 0;
          /* Stay within bounds of both yycheck and yytname.  */
          int yychecklim = YYLAST - yyn + 1;
          int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
          int yyx;

          for (yyx = yyxbegin; yyx < yyxend; ++yyx)
            if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR
                && !yytable_value_is_error (yytable[yyx + yyn]))
              {
                if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
                  {
                    yycount = 1;
                    yysize = yysize0;
                    break;
                  }
                yyarg[yycount++] = yytname[yyx];
                {
                  YYPTRDIFF_T yysize1
                    = yysize + yytnamerr (YY_NULLPTR, yytname[yyx]);
                  if (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM)
                    yysize = yysize1;
                  else
                    return 2;
                }
              }
        }
    }

  switch (yycount)
    {
# define YYCASE_(N, S)                      \
      case N:                               \
        yyformat = S;                       \
      break
    default: /* Avoid compiler warnings. */
      YYCASE_(0, YY_("syntax error"));
      YYCASE_(1, YY_("syntax error, unexpected %s"));
      YYCASE_(2, YY_("syntax error, unexpected %s, expecting %s"));
      YYCASE_(3, YY_("syntax error, unexpected %s, expecting %s or %s"));
      YYCASE_(4, YY_("syntax error, unexpected %s, expecting %s or %s or %s"));
      YYCASE_(5, YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s"));
# undef YYCASE_
    }

  {
    /* Don't count the "%s"s in the final size, but reserve room for
       the terminator.  */
    YYPTRDIFF_T yysize1 = yysize + (yystrlen (yyformat) - 2 * yycount) + 1;
    if (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM)
      yysize = yysize1;
    else
      return 2;
  }

  if (*yymsg_alloc < yysize)
    {
      *yymsg_alloc = 2 * yysize;
      if (! (yysize <= *yymsg_alloc
             && *yymsg_alloc <= YYSTACK_ALLOC_MAXIMUM))
        *yymsg_alloc = YYSTACK_ALLOC_MAXIMUM;
      return 1;
    }

  /* Avoid sprintf, as that infringes on the user's name space.
     Don't have undefined behavior even if the translation
     produced a string with the wrong number of "%s"s.  */
  {
    char *yyp = *yymsg;
    int yyi = 0;
    while ((*yyp = *yyformat) != '\0')
      if (*yyp == '%' && yyformat[1] == 's' && yyi < yycount)
        {
          yyp += yytnamerr (yyp, yyarg[yyi++]);
          yyformat += 2;
        }
      else
        {
          ++yyp;
          ++yyformat;
        }
  }
  return 0;
}
#endif /* YYERROR_VERBOSE */

/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

static void
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep)
{
  YYUSE (yyvaluep);
  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YYUSE (yytype);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}




/* The lookahead symbol.  */
int yychar;

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval;
/* Number of syntax errors so far.  */
int yynerrs;


/*----------.
| yyparse.  |
`----------*/

int
yyparse (void)
{
    yy_state_fast_t yystate;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus;

    /* The stacks and their tools:
       'yyss': related to states.
       'yyvs': related to semantic values.

       Refer to the stacks through separate pointers, to allow yyoverflow
       to reallocate them elsewhere.  */

    /* The state stack.  */
    yy_state_t yyssa[YYINITDEPTH];
    yy_state_t *yyss;
    yy_state_t *yyssp;

    /* The semantic value stack.  */
    YYSTYPE yyvsa[YYINITDEPTH];
    YYSTYPE *yyvs;
    YYSTYPE *yyvsp;

    YYPTRDIFF_T yystacksize;

  int yyn;
  int yyresult;
  /* Lookahead token as an internal (translated) token number.  */
  int yytoken = 0;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;

#if YYERROR_VERBOSE
  /* Buffer for error messages, and its allocated size.  */
  char yymsgbuf[128];
  char *yymsg = yymsgbuf;
  YYPTRDIFF_T yymsg_alloc = sizeof yymsgbuf;
#endif

#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  yyssp = yyss = yyssa;
  yyvsp = yyvs = yyvsa;
  yystacksize = YYINITDEPTH;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY; /* Cause a token to be read.  */
  goto yysetstate;


/*------------------------------------------------------------.
| yynewstate -- push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;


/*--------------------------------------------------------------------.
| yysetstate -- set current state (the top of the stack) to yystate.  |
`--------------------------------------------------------------------*/
yysetstate:
  YYDPRINTF ((stderr, "Entering state %d\n", yystate));
  YY_ASSERT (0 <= yystate && yystate < YYNSTATES);
  YY_IGNORE_USELESS_CAST_BEGIN
  *yyssp = YY_CAST (yy_state_t, yystate);
  YY_IGNORE_USELESS_CAST_END

  if (yyss + yystacksize - 1 <= yyssp)
#if !defined yyoverflow && !defined YYSTACK_RELOCATE
    goto yyexhaustedlab;
#else
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYPTRDIFF_T yysize = yyssp - yyss + 1;

# if defined yyoverflow
      {
        /* Give user a chance to reallocate the stack.  Use copies of
           these so that the &'s don't force the real ones into
           memory.  */
        yy_state_t *yyss1 = yyss;
        YYSTYPE *yyvs1 = yyvs;

        /* Each stack pointer address is followed by the size of the
           data in use in that stack, in bytes.  This used to be a
           conditional around just the two extra args, but that might
           be undefined if yyoverflow is a macro.  */
        yyoverflow (YY_("memory exhausted"),
                    &yyss1, yysize * YYSIZEOF (*yyssp),
                    &yyvs1, yysize * YYSIZEOF (*yyvsp),
                    &yystacksize);
        yyss = yyss1;
        yyvs = yyvs1;
      }
# else /* defined YYSTACK_RELOCATE */
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
        goto yyexhaustedlab;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
        yystacksize = YYMAXDEPTH;

      {
        yy_state_t *yyss1 = yyss;
        union yyalloc *yyptr =
          YY_CAST (union yyalloc *,
                   YYSTACK_ALLOC (YY_CAST (YYSIZE_T, YYSTACK_BYTES (yystacksize))));
        if (! yyptr)
          goto yyexhaustedlab;
        YYSTACK_RELOCATE (yyss_alloc, yyss);
        YYSTACK_RELOCATE (yyvs_alloc, yyvs);
# undef YYSTACK_RELOCATE
        if (yyss1 != yyssa)
          YYSTACK_FREE (yyss1);
      }
# endif

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;

      YY_IGNORE_USELESS_CAST_BEGIN
      YYDPRINTF ((stderr, "Stack size increased to %ld\n",
                  YY_CAST (long, yystacksize)));
      YY_IGNORE_USELESS_CAST_END

      if (yyss + yystacksize - 1 <= yyssp)
        YYABORT;
    }
#endif /* !defined yyoverflow && !defined YYSTACK_RELOCATE */

  if (yystate == YYFINAL)
    YYACCEPT;

  goto yybackup;


/*-----------.
| yybackup.  |
`-----------*/
yybackup:
  /* Do appropriate processing given the current state.  Read a
     lookahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to lookahead token.  */
  yyn = yypact[yystate];
  if (yypact_value_is_default (yyn))
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid lookahead symbol.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = yylex ();
    }

  if (yychar <= YYEOF)
    {
      yychar = yytoken = YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yytable_value_is_error (yyn))
        goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the lookahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);
  yystate = yyn;
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END

  /* Discard the shifted token.  */
  yychar = YYEMPTY;
  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     '$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];


  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
  case 2:
#line 111 "spl.y"
    {       
        TERNARY_TREE ParseTree;
        ParseTree = create_node((yyvsp[-5].iVal),PROGRAM,(yyvsp[-3].tVal),create_node((yyvsp[-1].iVal),PROGRAM_SEMENTIC_CHECK,NULL,NULL,NULL),NULL);
        #ifdef DEBUG
        PrintTree(ParseTree);
        #else
        GenerateCode(ParseTree);
        #endif
    }
#line 1543 "spl.tab.c"
    break;

  case 3:
#line 122 "spl.y"
    {
        (yyval.tVal) = create_node(NOTHING,BLOCK,(yyvsp[-2].tVal),(yyvsp[0].tVal),NULL);
    }
#line 1551 "spl.tab.c"
    break;

  case 4:
#line 126 "spl.y"
    {
        (yyval.tVal) = create_node(NOTHING,BLOCK,(yyvsp[0].tVal),NULL,NULL);
    }
#line 1559 "spl.tab.c"
    break;

  case 5:
#line 131 "spl.y"
    {
        (yyval.tVal) = create_node(NOTHING,DECLARATION_BLOCK,(yyvsp[-4].tVal),(yyvsp[-1].tVal),NULL);
    }
#line 1567 "spl.tab.c"
    break;

  case 6:
#line 135 "spl.y"
    {
        (yyval.tVal) = create_node(NOTHING,DECLARATION_BLOCK,(yyvsp[-5].tVal),(yyvsp[-2].tVal),(yyvsp[0].tVal));
    }
#line 1575 "spl.tab.c"
    break;

  case 7:
#line 140 "spl.y"
    {
        (yyval.tVal) = create_node((yyvsp[0].iVal),IDENTIFIER_VALUE,NULL,NULL,NULL);
    }
#line 1583 "spl.tab.c"
    break;

  case 8:
#line 144 "spl.y"
    {
        (yyval.tVal) = create_node((yyvsp[0].iVal),IDENTIFIER_LIST,(yyvsp[-2].tVal),NULL,NULL);
    }
#line 1591 "spl.tab.c"
    break;

  case 9:
#line 149 "spl.y"
    {
        (yyval.tVal) = create_node(CHARACTER_TYPE,TYPE_VALUE,NULL,NULL,NULL);
    }
#line 1599 "spl.tab.c"
    break;

  case 10:
#line 153 "spl.y"
    {
        (yyval.tVal) = create_node(INTEGER_TYPE,TYPE_VALUE,NULL,NULL,NULL);
    }
#line 1607 "spl.tab.c"
    break;

  case 11:
#line 157 "spl.y"
    {
        (yyval.tVal) = create_node(REAL_TYPE,TYPE_VALUE,NULL,NULL,NULL);
    }
#line 1615 "spl.tab.c"
    break;

  case 12:
#line 162 "spl.y"
    {
        (yyval.tVal) = create_node(NOTHING,STATEMENT_LIST,(yyvsp[0].tVal),NULL,NULL);
    }
#line 1623 "spl.tab.c"
    break;

  case 13:
#line 166 "spl.y"
    {
        (yyval.tVal) = create_node(NOTHING,STATEMENT_LIST,(yyvsp[-2].tVal),(yyvsp[0].tVal),NULL);
    }
#line 1631 "spl.tab.c"
    break;

  case 14:
#line 171 "spl.y"
    {
        (yyval.tVal) = create_node(NOTHING,STATEMENT,(yyvsp[0].tVal),NULL,NULL);
    }
#line 1639 "spl.tab.c"
    break;

  case 15:
#line 175 "spl.y"
    {
        (yyval.tVal) = create_node(NOTHING,STATEMENT,(yyvsp[0].tVal),NULL,NULL);
    }
#line 1647 "spl.tab.c"
    break;

  case 16:
#line 179 "spl.y"
    {
        (yyval.tVal) = create_node(NOTHING,STATEMENT,(yyvsp[0].tVal),NULL,NULL);
    }
#line 1655 "spl.tab.c"
    break;

  case 17:
#line 183 "spl.y"
    {
        (yyval.tVal) = create_node(NOTHING,STATEMENT,(yyvsp[0].tVal),NULL,NULL);
    }
#line 1663 "spl.tab.c"
    break;

  case 18:
#line 187 "spl.y"
    {
        (yyval.tVal) = create_node(NOTHING,STATEMENT,(yyvsp[0].tVal),NULL,NULL);
    }
#line 1671 "spl.tab.c"
    break;

  case 19:
#line 191 "spl.y"
    {
        (yyval.tVal) = create_node(NOTHING,STATEMENT,(yyvsp[0].tVal),NULL,NULL);
    }
#line 1679 "spl.tab.c"
    break;

  case 20:
#line 195 "spl.y"
    {
        (yyval.tVal) = create_node(NOTHING,STATEMENT,(yyvsp[0].tVal),NULL,NULL);
    }
#line 1687 "spl.tab.c"
    break;

  case 21:
#line 200 "spl.y"
    {
        (yyval.tVal) = create_node((yyvsp[0].iVal),ASSIGNMENT_STATEMENT,(yyvsp[-2].tVal),NULL,NULL);
    }
#line 1695 "spl.tab.c"
    break;

  case 22:
#line 205 "spl.y"
    {
        (yyval.tVal) = create_node(NOTHING,IF_STATEMENT,(yyvsp[-3].tVal),(yyvsp[-1].tVal),NULL);
    }
#line 1703 "spl.tab.c"
    break;

  case 23:
#line 209 "spl.y"
    {
        (yyval.tVal) = create_node(NOTHING,IF_STATEMENT,(yyvsp[-5].tVal),(yyvsp[-3].tVal),(yyvsp[-1].tVal));
    }
#line 1711 "spl.tab.c"
    break;

  case 24:
#line 214 "spl.y"
    {
        (yyval.tVal) = create_node(NOTHING,DO_STATEMENT,(yyvsp[-3].tVal),(yyvsp[-1].tVal),NULL);
    }
#line 1719 "spl.tab.c"
    break;

  case 25:
#line 219 "spl.y"
    {
        (yyval.tVal) = create_node(NOTHING,WHILE_STATEMENT,(yyvsp[-3].tVal),(yyvsp[-1].tVal),NULL);
    }
#line 1727 "spl.tab.c"
    break;

  case 26:
#line 224 "spl.y"
    {
        (yyval.tVal) = create_node((yyvsp[-9].iVal),FOR_STATEMENT,(yyvsp[-7].tVal),create_node((yyvsp[-9].iVal),FOR_STATEMENT,(yyvsp[-5].tVal),(yyvsp[-3].tVal),NULL),(yyvsp[-1].tVal));
    }
#line 1735 "spl.tab.c"
    break;

  case 27:
#line 229 "spl.y"
    {
        (yyval.tVal) = create_node(NOTHING,WRITE_STATEMENT,(yyvsp[-1].tVal),NULL,NULL);
    }
#line 1743 "spl.tab.c"
    break;

  case 28:
#line 233 "spl.y"
    {
        (yyval.tVal) = create_node(NEWLINE,WRITE_STATEMENT,NULL,NULL,NULL);
    }
#line 1751 "spl.tab.c"
    break;

  case 29:
#line 238 "spl.y"
    {
        (yyval.tVal) = create_node((yyvsp[-1].iVal),READ_STATEMENT,NULL,NULL,NULL);
    }
#line 1759 "spl.tab.c"
    break;

  case 30:
#line 243 "spl.y"
    {
        (yyval.tVal) = create_node(NOTHING,OUTPUT_LIST,(yyvsp[0].tVal),NULL,NULL);
    }
#line 1767 "spl.tab.c"
    break;

  case 31:
#line 247 "spl.y"
    {
        (yyval.tVal) = create_node(NOTHING,OUTPUT_LIST,(yyvsp[-2].tVal),(yyvsp[0].tVal),NULL);
    }
#line 1775 "spl.tab.c"
    break;

  case 32:
#line 252 "spl.y"
    {
        (yyval.tVal) = create_node(NOT,CONDITIONAL,(yyvsp[0].tVal),NULL,NULL);
    }
#line 1783 "spl.tab.c"
    break;

  case 33:
#line 256 "spl.y"
    {
        (yyval.tVal) = create_node(AND,CONDITIONAL,create_node(NOTHING,CONDITIONAL,(yyvsp[-4].tVal),(yyvsp[-3].tVal),(yyvsp[-2].tVal)),(yyvsp[0].tVal),NULL);
    }
#line 1791 "spl.tab.c"
    break;

  case 34:
#line 260 "spl.y"
    {
        (yyval.tVal) = create_node(OR,CONDITIONAL,create_node(NOTHING,CONDITIONAL,(yyvsp[-4].tVal),(yyvsp[-3].tVal),(yyvsp[-2].tVal)),(yyvsp[0].tVal),NULL);
    }
#line 1799 "spl.tab.c"
    break;

  case 35:
#line 264 "spl.y"
    {
        (yyval.tVal) = create_node(NOTHING,CONDITIONAL,(yyvsp[-2].tVal),(yyvsp[-1].tVal),(yyvsp[0].tVal));
    }
#line 1807 "spl.tab.c"
    break;

  case 36:
#line 269 "spl.y"
    {
        (yyval.tVal) = create_node(EQUAL,COMPARATOR,NULL,NULL,NULL);
    }
#line 1815 "spl.tab.c"
    break;

  case 37:
#line 273 "spl.y"
    {
        (yyval.tVal) = create_node(NOT_EQUAL,COMPARATOR,NULL,NULL,NULL);
    }
#line 1823 "spl.tab.c"
    break;

  case 38:
#line 277 "spl.y"
    {
        (yyval.tVal) = create_node(LESS_THAN,COMPARATOR,NULL,NULL,NULL);
    }
#line 1831 "spl.tab.c"
    break;

  case 39:
#line 281 "spl.y"
    {
        (yyval.tVal) = create_node(GREATER_THAN,COMPARATOR,NULL,NULL,NULL);
    }
#line 1839 "spl.tab.c"
    break;

  case 40:
#line 285 "spl.y"
    {
        (yyval.tVal) = create_node(GREATER_THAN_OR_EQUAL,COMPARATOR,NULL,NULL,NULL);
    }
#line 1847 "spl.tab.c"
    break;

  case 41:
#line 289 "spl.y"
    {
        (yyval.tVal) = create_node(LESS_THAN_OR_EQUAL,COMPARATOR,NULL,NULL,NULL);
    }
#line 1855 "spl.tab.c"
    break;

  case 42:
#line 294 "spl.y"
    {
        (yyval.tVal) = create_node(NOTHING,EXPRESSION,(yyvsp[0].tVal),NULL,NULL);
    }
#line 1863 "spl.tab.c"
    break;

  case 43:
#line 298 "spl.y"
    {
        (yyval.tVal) = create_node(PLUS,EXPRESSION,(yyvsp[-2].tVal),(yyvsp[0].tVal),NULL);
    }
#line 1871 "spl.tab.c"
    break;

  case 44:
#line 302 "spl.y"
    {
        (yyval.tVal) = create_node(MINUS,EXPRESSION,(yyvsp[-2].tVal),(yyvsp[0].tVal),NULL);
    }
#line 1879 "spl.tab.c"
    break;

  case 45:
#line 307 "spl.y"
    {
        (yyval.tVal) = create_node(NOTHING,TERM,(yyvsp[0].tVal),NULL,NULL);
    }
#line 1887 "spl.tab.c"
    break;

  case 46:
#line 311 "spl.y"
    {
        (yyval.tVal) = create_node(TIMES,TERM,(yyvsp[-2].tVal),(yyvsp[0].tVal),NULL);
    }
#line 1895 "spl.tab.c"
    break;

  case 47:
#line 315 "spl.y"
    {
        (yyval.tVal) = create_node(DIVIDE,TERM,(yyvsp[-2].tVal),(yyvsp[0].tVal),NULL);
    }
#line 1903 "spl.tab.c"
    break;

  case 48:
#line 320 "spl.y"
    {
        (yyval.tVal) = create_node((yyvsp[0].iVal),IDENTIFIER_VALUE,NULL,NULL,NULL);
    }
#line 1911 "spl.tab.c"
    break;

  case 49:
#line 324 "spl.y"
    {
        (yyval.tVal) = create_node(NOTHING,VALUE,(yyvsp[0].tVal),NULL,NULL);
    }
#line 1919 "spl.tab.c"
    break;

  case 50:
#line 328 "spl.y"
    {
        (yyval.tVal) = create_node(BRA,VALUE,(yyvsp[-1].tVal),NULL,NULL);
    }
#line 1927 "spl.tab.c"
    break;

  case 51:
#line 333 "spl.y"
    {
        (yyval.tVal) = create_node((yyvsp[0].iVal),CHARACTER_CONSTANT,NULL,NULL,NULL);
    }
#line 1935 "spl.tab.c"
    break;

  case 52:
#line 337 "spl.y"
    {
        (yyval.tVal) = create_node(NOTHING,CONSTANT,(yyvsp[0].tVal),NULL,NULL);
    }
#line 1943 "spl.tab.c"
    break;

  case 53:
#line 342 "spl.y"
    {
        (yyval.tVal) = create_node(MINUS,NUMBER_CONSTANT,(yyvsp[0].tVal),NULL,NULL);
    }
#line 1951 "spl.tab.c"
    break;

  case 54:
#line 346 "spl.y"
    {
        (yyval.tVal) = create_node(MINUS+PERIOD,NUMBER_CONSTANT,(yyvsp[-2].tVal),(yyvsp[0].tVal),NULL);
    }
#line 1959 "spl.tab.c"
    break;

  case 55:
#line 350 "spl.y"
    {
        (yyval.tVal) = create_node(PERIOD,NUMBER_CONSTANT,(yyvsp[-2].tVal),(yyvsp[0].tVal),NULL);
    }
#line 1967 "spl.tab.c"
    break;

  case 56:
#line 354 "spl.y"
    {
        (yyval.tVal) = create_node(NOTHING,NUMBER_CONSTANT,(yyvsp[0].tVal),NULL,NULL);
    }
#line 1975 "spl.tab.c"
    break;

  case 57:
#line 359 "spl.y"
    {
        (yyval.tVal) = create_node((yyvsp[0].iVal),NUMBER_VALUE,NULL,NULL,NULL);
    }
#line 1983 "spl.tab.c"
    break;


#line 1987 "spl.tab.c"

      default: break;
    }
  /* User semantic actions sometimes alter yychar, and that requires
     that yytoken be updated with the new translation.  We take the
     approach of translating immediately before every use of yytoken.
     One alternative is translating here after every semantic action,
     but that translation would be missed if the semantic action invokes
     YYABORT, YYACCEPT, or YYERROR immediately after altering yychar or
     if it invokes YYBACKUP.  In the case of YYABORT or YYACCEPT, an
     incorrect destructor might then be invoked immediately.  In the
     case of YYERROR or YYBACKUP, subsequent parser actions might lead
     to an incorrect destructor call or verbose syntax error message
     before the lookahead is translated.  */
  YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;

  /* Now 'shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */
  {
    const int yylhs = yyr1[yyn] - YYNTOKENS;
    const int yyi = yypgoto[yylhs] + *yyssp;
    yystate = (0 <= yyi && yyi <= YYLAST && yycheck[yyi] == *yyssp
               ? yytable[yyi]
               : yydefgoto[yylhs]);
  }

  goto yynewstate;


/*--------------------------------------.
| yyerrlab -- here on detecting error.  |
`--------------------------------------*/
yyerrlab:
  /* Make sure we have latest lookahead translation.  See comments at
     user semantic actions for why this is necessary.  */
  yytoken = yychar == YYEMPTY ? YYEMPTY : YYTRANSLATE (yychar);

  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if ! YYERROR_VERBOSE
      yyerror (YY_("syntax error"));
#else
# define YYSYNTAX_ERROR yysyntax_error (&yymsg_alloc, &yymsg, \
                                        yyssp, yytoken)
      {
        char const *yymsgp = YY_("syntax error");
        int yysyntax_error_status;
        yysyntax_error_status = YYSYNTAX_ERROR;
        if (yysyntax_error_status == 0)
          yymsgp = yymsg;
        else if (yysyntax_error_status == 1)
          {
            if (yymsg != yymsgbuf)
              YYSTACK_FREE (yymsg);
            yymsg = YY_CAST (char *, YYSTACK_ALLOC (YY_CAST (YYSIZE_T, yymsg_alloc)));
            if (!yymsg)
              {
                yymsg = yymsgbuf;
                yymsg_alloc = sizeof yymsgbuf;
                yysyntax_error_status = 2;
              }
            else
              {
                yysyntax_error_status = YYSYNTAX_ERROR;
                yymsgp = yymsg;
              }
          }
        yyerror (yymsgp);
        if (yysyntax_error_status == 2)
          goto yyexhaustedlab;
      }
# undef YYSYNTAX_ERROR
#endif
    }



  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
         error, discard it.  */

      if (yychar <= YYEOF)
        {
          /* Return failure if at end of input.  */
          if (yychar == YYEOF)
            YYABORT;
        }
      else
        {
          yydestruct ("Error: discarding",
                      yytoken, &yylval);
          yychar = YYEMPTY;
        }
    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:
  /* Pacify compilers when the user code never invokes YYERROR and the
     label yyerrorlab therefore never appears in user code.  */
  if (0)
    YYERROR;

  /* Do not reclaim the symbols of the rule whose action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;      /* Each real token shifted decrements this.  */

  for (;;)
    {
      yyn = yypact[yystate];
      if (!yypact_value_is_default (yyn))
        {
          yyn += YYTERROR;
          if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
            {
              yyn = yytable[yyn];
              if (0 < yyn)
                break;
            }
        }

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
        YYABORT;


      yydestruct ("Error: popping",
                  yystos[yystate], yyvsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END


  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", yystos[yyn], yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturn;


/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturn;


#if !defined yyoverflow || YYERROR_VERBOSE
/*-------------------------------------------------.
| yyexhaustedlab -- memory exhaustion comes here.  |
`-------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  /* Fall through.  */
#endif


/*-----------------------------------------------------.
| yyreturn -- parsing is finished, return the result.  |
`-----------------------------------------------------*/
yyreturn:
  if (yychar != YYEMPTY)
    {
      /* Make sure we have latest lookahead translation.  See comments at
         user semantic actions for why this is necessary.  */
      yytoken = YYTRANSLATE (yychar);
      yydestruct ("Cleanup: discarding lookahead",
                  yytoken, &yylval);
    }
  /* Do not reclaim the symbols of the rule whose action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
                  yystos[+*yyssp], yyvsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif
#if YYERROR_VERBOSE
  if (yymsg != yymsgbuf)
    YYSTACK_FREE (yymsg);
#endif
  return yyresult;
}
#line 363 "spl.y"


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
            printf("BOOM %s\n",arithmetic_terms[j]);
        }
        if (!lastType) {
            lastType=type;
        } else if (type!=lastType) {
            if (type=='f' && lastType=='d'){
                lastType=type;
            } else if (type=='d' && lastType=='f') {
                lastType='f';
            } else {
                fprintf(stderr,"\033[0;31m[ERROR]\033[0m Types of the assignement don't match (%s)\n",arithmetic_terms[j]);
                exit(1);
            }
        } 
    }
    return lastType;
}

char* OptimizeExpression(char* pExpression) {
    int length,int_result;
    float float_result;
    char* expression_str;
    char type;
    if (!ContainsLetter(pExpression)) {
        type = EvaluateExpressionType(pExpression);
        if (type=='d') {
            int_result = (int)te_interp(pExpression, 0);
            length = snprintf( NULL, 0, "%d", int_result );
            expression_str = malloc( length + 1 );
            snprintf( expression_str, length + 1, "%d", int_result );
            return expression_str;
        } else if (type=='f') {
            float_result = te_interp(pExpression, 0);
            length = snprintf( NULL, 0, "%f", float_result );
            expression_str = malloc( length + 1 );
            snprintf( expression_str, length + 1, "%f", float_result );
            return expression_str;
        }
    }
    return pExpression;
}

char* GenerateCode(TERNARY_TREE t)
{
    char evalutionAssignement,*myAssignement, *myDeclaration, *myIdentifier, *myIdentifierList, *myExpression, *myTerm, *myOutputList,*isStatement,*toStatement,*byStatement,*myNumberValue, *myConstant, *myValue, *firstMember, *secondMember, *myNumberConstant;
    int length,length_number_value;
    char src[]= "e*(5.0+6)";
    switch(t->nodeIdentifier){
        case PROGRAM:
        if (t->item != t->second->item) {
            fprintf(stderr,"\033[0;33m[WARNING]\033[0m Program identifiers don't match (%s,%s)\n",symTab[t->item]->identifier,symTab[t->second->item]->identifier);
        }
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
        myDeclaration = malloc (sizeof (char) * DEST_SIZE);
        inDeclarationBlock = 1;
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
        break;

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

        case ASSIGNMENT_STATEMENT: ;
        myAssignement = malloc (sizeof (char) * DEST_SIZE);
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
        printf("%s = %s;\n",symTab[t->item]->identifier,myAssignement);
        break;

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
        break;

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
        break;

        case WRITE_STATEMENT:
        if (t->item == NEWLINE) {
            printf("printf(\"\\n\");\n");
        }
        else {
            GenerateCode(t->first);
        }
        break;

        case OUTPUT_LIST: ;
        myOutputList = malloc (sizeof (char) * DEST_SIZE);
        strcpy(myOutputList,GenerateCode(t->first));
        if (t->first->nodeIdentifier == IDENTIFIER_VALUE) {
            if (!symTab[t->first->item]->state) {
                fprintf(stderr,"\033[0;31m[ERROR]\033[0m Undeclared identifier (%s)\n",symTab[t->first->item]->identifier);
                exit(1);
            } else if (symTab[t->first->item]->state == 'd') {
                fprintf(stderr,"\033[0;33m[WARNING]\033[0m Uninitialized identifier (%s)\n",symTab[t->first->item]->identifier);
            }
            printf("printf(\"%%%c\", %s);\n",symTab[t->first->item]->type,symTab[t->first->item]->identifier);
        } else if (strpbrk(myOutputList,"+-/*")){
            if (!ContainsLetter(myOutputList)) {
                strcpy(myOutputList,OptimizeExpression(myOutputList));
                printf("printf(\"%%d\",%s);\n",myOutputList);
            } else {
                printf("printf(\"%%d\",(%s));\n",myOutputList);
            }
        } else if (strpbrk(myOutputList,"'")){
            printf("printf(\"%%c\",%s);\n",myOutputList);
        } else {
            printf("printf(\"%%d\",%s);\n",myOutputList);
        }
        if (t->second != NULL) {
            GenerateCode(t->second);
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
        isStatement = malloc (sizeof (char) * DEST_SIZE);
        byStatement = malloc (sizeof (char) * DEST_SIZE);
        toStatement = malloc (sizeof (char) * DEST_SIZE);
        if (t->third!=NULL) {
            nbForLoop+=1;
            strcpy(isStatement,OptimizeExpression(GenerateCode(t->first)));
            printf("register int _by%d;\nfor (%s=%s;",nbForLoop,symTab[t->item]->identifier,isStatement);
            GenerateCode(t->second);
            GenerateCode(t->third);
            printf("}\n");
        } else {
            strcpy(byStatement,OptimizeExpression(GenerateCode(t->first)));
            strcpy(toStatement,OptimizeExpression(GenerateCode(t->second)));
            printf("_by%d=%s,(%s-(%s))*((_by%d > 0) - (_by%d < 0)) <= 0; %s+=_by%d) {\n",nbForLoop,byStatement,symTab[t->item]->identifier,toStatement,nbForLoop,nbForLoop,symTab[t->item]->identifier,nbForLoop);
        }
        break;

        case CONDITIONAL: ;
        firstMember = malloc (sizeof (char) * DEST_SIZE);
        secondMember = malloc (sizeof (char) * DEST_SIZE);
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
            strcpy(firstMember,GenerateCode(t->first));
            if (strpbrk(firstMember,"+/-*")) {
                strcpy(firstMember,OptimizeExpression(firstMember));
            }
            printf("%s",firstMember);
            GenerateCode(t->second);
            strcpy(secondMember,GenerateCode(t->third));
            if (strpbrk(secondMember,"+-/*")) {
                strcpy(secondMember,OptimizeExpression(secondMember));
            }
            printf("%s",secondMember);
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
        myValue = malloc (sizeof (char) * DEST_SIZE);
        if (t->item == BRA) {
            strcpy(myValue,"(");
            strcat(myValue,GenerateCode(t->first));
            strcat(myValue,")");
        } else {
            myValue = GenerateCode(t->first);
        }
        return myValue;
        break;

        case CONSTANT: ;
        myConstant = GenerateCode(t->first);
        return myConstant;
        break;

        case CHARACTER_CONSTANT:
        return symTab[t->item]->identifier;
        break;

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
        break;

        case NUMBER_VALUE: ;
        length_number_value = snprintf( NULL, 0, "%d", t->item );
        myNumberValue = malloc( length_number_value + 1 );
        snprintf( myNumberValue, length_number_value + 1, "%d", t->item );
        return myNumberValue;
        break;
    }
}
#endif

#include "lex.yy.c"
