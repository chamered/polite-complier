%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

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

"do"[ \t]+"this"                        { printf("DO_THIS\n"); }

"int"                                   { printf("TYPE_INT\n"); }
"float"                                 { printf("TYPE_FLOAT\n"); }
"bool"                                  { printf("TYPE_BOOL\n"); }

"true"                                  { printf("BOOL_LITERAL(true)\n"); }
"false"                                 { printf("BOOL_LITERAL(false)\n"); }

"if"                                    { printf("IF\n"); }
"while"                                 { printf("WHILE\n"); }
"otherwise"                             { printf("OTHERWISE\n"); }
"say"                                   { printf("SAY\n"); }
"pls"                                   { printf("PLS\n"); }
"thanks"                                { printf("THANKS\n"); }

"=="                                    { printf("EQUAL\n"); }
"!="                                    { printf("NOT_EQUAL\n"); }
"<="                                    { printf("LESS_EQUAL\n"); }
">="                                    { printf("GREATER_EQUAL\n"); }
"&&"                                    { printf("AND\n"); }
"||"                                    { printf("OR\n"); }

"="                                     { printf("ASSIGN\n"); }
"+"                                     { printf("PLUS\n"); }
"-"                                     { printf("MINUS\n"); }
"*"                                     { printf("MULTIPLY\n"); }
"/"                                     { printf("DIVIDE\n"); }
"<"                                     { printf("LESS\n"); }
">"                                     { printf("GREATER\n"); }
"!"                                     { printf("NOT\n"); }

"("                                     { printf("LPAREN\n"); }
")"                                     { printf("RPAREN\n"); }
","                                     { printf("COMMA\n"); }

{FLOAT}                                 { printf("FLOAT_LITERAL(%s)\n", yytext); }
{INT}                                   { printf("INT_LITERAL(%s)\n", yytext); }

{ID}                                    { printf("IDENTIFIER(%s)\n", yytext); }

.                                       {
                                            printf("Lexical error at line %d: unknown character '%s'\n",
                                                   line_number,
                                                   yytext);
                                        }

%%

int main(int argc, char **argv) {
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
}

int yywrap() {
    return 1;
}