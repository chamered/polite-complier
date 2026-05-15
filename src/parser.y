%{
#include <stdio.h>
#include <stdlib.h>
#include "symbol_table.h"

// yylex() comes from Flex.
int yylex();
// Error function called by Bison.
void yyerror(const char *s);
%}

// Tokens coming from the lexer.
%token TYPE_INT
%token TYPE_FLOAT
%token TYPE_BOOL

%token IDENTIFIER

%token INT_LITERAL
%token FLOAT_LITERAL
%token BOOL_LITERAL

%token ASSIGN

%token PLUS
%token MINUS
%token MULTIPLY
%token DIVIDE

%token EQUAL
%token NOT_EQUAL

%token LESS
%token GREATER
%token LESS_EQUAL
%token GREATER_EQUAL

%token AND
%token OR
%token NOT

%token LPAREN
%token RPAREN
%token COMMA

%token IF
%token WHILE
%token OTHERWISE

%token SAY
%token PLS
%token THANKS

%token DO_THIS

%%

program:
    statements
    ;

statements:
    statement
    | statements statement
    ;
    
statement:
    declaration
    | assignment
    | say_statement
    ;

declaration:
    TYPE_INT IDENTIFIER PLS
    {
        printf("Parsed int declaration\n");
    }
    | TYPE_FLOAT IDENTIFIER PLS
    {
        printf("Parsed float declaration\n");
    }
    | TYPE_BOOL IDENTIFIER PLS
    {
        printf("Parsed bool declaration\n");
    }
    ;

assignment: 
    IDENTIFIER ASSIGN INT_LITERAL PLS
    {
        printf("Parsed integer assignment\n");
    }
    ;

say_statement: 
    SAY LPAREN IDENTIFIER RPAREN PLS
    {
        printf("Parsed say statement\n");
    }
    ;

%%

void yyerror(const char* s) {
    fprintf(stderr, "Parse error: %s\n", s);
}