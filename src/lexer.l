%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "symbol_table.h"
#include "../build/parser.tab.h"

int line_number = 1;
%}

DIGIT           [0-9]
LETTER          [a-zA-Z_]
ID              {LETTER}({LETTER}|{DIGIT})*
INT             {DIGIT}+
FLOAT           {DIGIT}+"."{DIGIT}+

%%

[ \t\r]+                                ;

\n                                      { line_number++; }

"do"[ \t]+"this"                        { return DO_THIS; }

"int"                                   { return TYPE_INT; }
"float"                                 { return TYPE_FLOAT; }
"bool"                                  { return TYPE_BOOL; }

"true"                                  { yylval.int_val = 1; return BOOL_LITERAL; }
"false"                                 { yylval.int_val = 0; return BOOL_LITERAL; }

"if"                                    { return IF; }
"while"                                 { return WHILE; }
"otherwise"                             { return OTHERWISE; }
"say"                                   { return SAY; }
"pls"                                   { return PLS; }
"thanks"                                { return THANKS; }

"=="                                    { return EQUAL; }
"!="                                    { return NOT_EQUAL; }
"<="                                    { return LESS_EQUAL; }
">="                                    { return GREATER_EQUAL; }
"&&"                                    { return AND; }
"||"                                    { return OR; }

"="                                     { return ASSIGN; }
"+"                                     { return PLUS; }
"-"                                     { return MINUS; }
"*"                                     { return MULTIPLY; }
"/"                                     { return DIVIDE; }
"<"                                     { return LESS; }
">"                                     { return GREATER; }
"!"                                     { return NOT; }

"("                                     { return LPAREN; }
")"                                     { return RPAREN; }
","                                     { return COMMA; }

{FLOAT}                                 { yylval.float_val = atof(yytext); return FLOAT_LITERAL; }
{INT}                                   { yylval.int_val = atoi(yytext); return INT_LITERAL; }

{ID}                                    { yylval.str_val = strdup(yytext); return IDENTIFIER; }

.                                       {
                                            printf("Lexical error at line %d: unknown character '%s'\n",
                                                   line_number,
                                                   yytext);
                                        }

%%

/*int main(int argc, char **argv) {
    if (argc > 2) {
        fprintf(stderr, "Usage: ./poLite [input_file]\n");
        return 1;
    }

    if (argc == 2) {
        FILE *file = fopen(argv[1], "r");

        if (file == NULL) {
            fprintf(stderr, "Error: could not open file '%s'\n", argv[1]);
            return 1;
        }

        yyin = file;

        yylex();

        fclose(file);

        return 0;
    }

    printf("poLite lexer interactive mode\n");
    printf("Write poLite code and press ENTER to scan the line.\n");
    printf("Write :q to quit.\n\n");

    char line[1024];

    while (1) {
        printf("> ");

        if (fgets(line, sizeof(line), stdin) == NULL) {
            break;
        }

        if (strcmp(line, ":q\n") == 0 || strcmp(line, ":q") == 0) {
            break;
        }

        YY_BUFFER_STATE buffer = yy_scan_string(line);

        yylex();

        yy_delete_buffer(buffer);
    }

    return 0;
}*/

int yywrap() {
    return 1;
}