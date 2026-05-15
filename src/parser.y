%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symbol_table.h"

// Variables to communicate the main with Flex and Bison
extern int yylex();
extern int line_number;

// Error function called by Bison.
void yyerror(const char *s);
%}

// Union to define the type of the tokens.
%union {
    char *str_val;
    int int_val;
    float float_val;
}

// Tokens coming from the lexer.
%token <str_val> IDENTIFIER
%token <int_val> INT_LITERAL
%token <float_val> FLOAT_LITERAL
%token <int_val> BOOL_LITERAL // 0 = false, 1 = true
%token TYPE_INT TYPE_FLOAT TYPE_BOOL
%token ASSIGN
%token PLUS MINUS MULTIPLY DIVIDE
%token EQUAL NOT_EQUAL LESS GREATER LESS_EQUAL GREATER_EQUAL
%token AND OR NOT
%token LPAREN RPAREN COMMA
%token IF WHILE OTHERWISE
%token SAY PLS THANKS DO_THIS

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
        printf("Parsed int declaration for variable: %s\n", $2);
        if (!insert_symbol($2, SYMBOL_TYPE_INT, 0)) {
            fprintf(stderr, "Semantic Error: variable '%s' already declared.\n", $2);
        }
        free($2); // Free the memory allocated by Flex for the identifier
    }
    | TYPE_FLOAT IDENTIFIER PLS
    {
        printf("Parsed float declaration for variable: %s\n", $2);
        if (!insert_symbol($2, SYMBOL_TYPE_FLOAT, 0)) {
            fprintf(stderr, "Semantic Error: variable '%s' already declared.\n", $2);
        }
        free($2);
    }
    | TYPE_BOOL IDENTIFIER PLS
    {
        printf("Parsed bool declaration for variable: %s\n", $2);
        if (!insert_symbol($2, SYMBOL_TYPE_BOOL, 0)) {
            fprintf(stderr, "Semantic Error: variable '%s' already declared.\n", $2);
        }
        free($2);
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