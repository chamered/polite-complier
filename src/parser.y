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
    SymbolType type_val;
}

// Tokens coming from the lexer.
%token <str_val> IDENTIFIER
%token <int_val> INT_LITERAL
%token <float_val> FLOAT_LITERAL
%token <int_val> BOOL_LITERAL // 0 = false, 1 = true

%type <type_val> expr

%token TYPE_INT TYPE_FLOAT TYPE_BOOL
%token ASSIGN
%token PLUS MINUS MULTIPLY DIVIDE
%token EQUAL NOT_EQUAL LESS GREATER LESS_EQUAL GREATER_EQUAL
%token AND OR NOT
%token LPAREN RPAREN COMMA
%token IF WHILE OTHERWISE
%token SAY PLS THANKS DO_THIS

// Priority operators
// from weakest (bottom) to strongest (top)
%left PLUS MINUS
%left MULTIPLY DIVIDE

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
    | TYPE_INT IDENTIFIER ASSIGN INT_LITERAL PLS
    {
        printf("Parsed int declaration and assignement. Var: %s Value: %d\n", $2, $4);
        if (!insert_symbol($2, SYMBOL_TYPE_INT, 1)) {
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
    | TYPE_FLOAT IDENTIFIER ASSIGN FLOAT_LITERAL PLS
    {
        printf("Parsed float declaration and assignement. Var: %s Value: %f\n", $2, $4);
        if (!insert_symbol($2, SYMBOL_TYPE_FLOAT, 1)) {
            fprintf(stderr, "Semantic Error: variable '%s' already declared.\n", $2);
        }
        free($2); // Free the memory allocated by Flex for the identifier
    }
    | TYPE_BOOL IDENTIFIER PLS
    {
        printf("Parsed bool declaration for variable: %s\n", $2);
        if (!insert_symbol($2, SYMBOL_TYPE_BOOL, 0)) {
            fprintf(stderr, "Semantic Error: variable '%s' already declared.\n", $2);
        }
        free($2);
    }
    | TYPE_BOOL IDENTIFIER ASSIGN BOOL_LITERAL PLS
    {
        printf("Parsed bool declaration and assignement. Var: %s Value: %d\n", $2, $4);
        if (!insert_symbol($2, SYMBOL_TYPE_BOOL, 1)) {
            fprintf(stderr, "Semantic Error: variable '%s' already declared.\n", $2);
        }
        free($2); // Free the memory allocated by Flex for the identifier
    }
    ;

assignment: 
    IDENTIFIER ASSIGN expr PLS
    {
        Symbol *sym = lookup_symbol($1);
        if(sym == NULL) {
            fprintf(stderr, "Semantic Error: variable '%s' not declared.\n", $1);
        } else if ($3 != SYMBOL_TYPE_ERROR) {
            if (sym->type != $3) {
                fprintf(stderr, "Semantic Error: type mismatch. Cannot assign %s to variable '%s' (type %s).\n",
                        type_to_string($3), $1, type_to_string(sym->type));
            } else {
                printf("Parsed valid assignment to '%s'.\n", $1);
                sym->initialized = 1;
            }
        }

        free($1);
    }
    ;

say_statement: 
    SAY LPAREN IDENTIFIER RPAREN PLS
    {
        printf("Parsed say statement for variable: %s\n", $3);

        Symbol *sym = lookup_symbol($3);
        if(sym == NULL) {
            fprintf(stderr, "Semantic Error: cannot say undeclared variable '%s'.\n", $3);
        } else if(sym->initialized == 0) {
            fprintf(stderr, "Semantic Error: variable '%s' is used but not initialized.\n", $3);
        }

        free($3);
    }
    ;

expr:
    INT_LITERAL
    {
        $$ = SYMBOL_TYPE_INT;
    }
    | FLOAT_LITERAL
    {
        $$ = SYMBOL_TYPE_FLOAT;
    }
    | BOOL_LITERAL
    {
        $$ = SYMBOL_TYPE_BOOL;
    }
    | IDENTIFIER
    {
        Symbol *sym = lookup_symbol($1);
        if (sym == NULL) {
            fprintf(stderr, "Semantic Error: variable '%s' is undeclared in expression.\n", $1);
            $$ = SYMBOL_TYPE_ERROR;
        } else if (sym->initialized == 0) {
            fprintf(stderr, "Semantic Error: variable '%s' is used but not initialized.\n", $1);
            $$ = SYMBOL_TYPE_ERROR;
        } else {
            $$ = sym->type;
        }

        free($1);
    }
    | expr PLUS expr
    {
        if ($1 == SYMBOL_TYPE_INT && $3 == SYMBOL_TYPE_INT) {
            $$ = SYMBOL_TYPE_INT;    
        } else {
            fprintf(stderr, "Semantic Error: type mismatch in addition expression.\n");
            $$ = SYMBOL_TYPE_ERROR;
        }
    }
    | expr MINUS expr
    {
        if ($1 == SYMBOL_TYPE_INT && $3 == SYMBOL_TYPE_INT) {
            $$ = SYMBOL_TYPE_INT;
        } else {
            fprintf(stderr, "Semantic Error: type mismatch in subtraction expression.\n");
            $$ = SYMBOL_TYPE_ERROR;
        }
    }
    | expr MULTIPLY expr
    { 
        if ($1 == SYMBOL_TYPE_INT && $3 == SYMBOL_TYPE_INT) {
            $$ = SYMBOL_TYPE_INT;
        } else {
            fprintf(stderr, "Semantic Error: type mismatch in multiplication expression.\n");
            $$ = SYMBOL_TYPE_ERROR;
        }
    }
    | expr DIVIDE expr
    { 
        if ($1 == SYMBOL_TYPE_INT && $3 == SYMBOL_TYPE_INT) {
            $$ = SYMBOL_TYPE_INT;
        } else {
            fprintf(stderr, "Semantic Error: type mismatch in division expression.\n");
            $$ = SYMBOL_TYPE_ERROR;
        }
    }
    ;

%%

void yyerror(const char* s) {
    fprintf(stderr, "Parse error: %s\n", s);
}