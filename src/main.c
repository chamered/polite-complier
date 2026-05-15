#include <stdio.h>
#include <stdlib.h>
#include "symbol_table.h"

// External declarations to communicate the main with Flex and Bison
extern int yyparse();
extern FILE *yyin; // yyin is the pointer to the file that Flex reads

int main(int argc, char **argv) {
    printf("Starting poLite compiler...\n");

    // 1. Input handling (File or Interactive)
    if (argc > 1) {
        FILE *file = fopen(argv[1], "r");
        if (file == NULL) {
            fprintf(stderr, "Error: could not open file '%s'\n", argv[1]);
            return 1;
        }
        yyin = file; // Say Flex to read from this file
        printf("Compiling file: %s\n", argv[1]);
    } else {
        printf("Interactive mode. Type poLite code and press Ctrl+D to finish.\n");
    }

    // 2. Init data structures
    init_symbol_table();

    // 3. Start parser
    if (yyparse() == 0) {
        printf("\nParsing completed successfully.\n");
    } else {
        printf("\nParsing failed.\n");
    }

    // (Optional for now) Print symbol table to see what's inside
    // print_symbol_table();

    // 4. Final cleanup
    free_symbol_table();

    // Close file if we had opened it
    if (argc > 1) {
        fclose(yyin);
    }

    return 0;
}