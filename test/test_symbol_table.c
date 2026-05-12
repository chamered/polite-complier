#include <stdio.h>

/*
    Include the header file, not the .c file.

    The header contains the declarations of the Symbol Table structures,
    types and functions, so this file knows that they exist.

    The actual implementation is inside symbol_table.c, which must be
    compiled together with main.c.
*/
#include "../src/symbol_table.h"

int main() {
    init_symbol_table();

    insert_symbol("x", TYPE_INT, 1);
    insert_symbol("price", TYPE_FLOAT, 1);
    insert_symbol("active", TYPE_BOOL, 0);

    print_symbol_table();

    Symbol *symbol = lookup_symbol("x");

    if (symbol != NULL) {
        printf("Found variable '%s' of type %s.\n",
               symbol->name,
               type_to_string(symbol->type));
    }

    free_symbol_table();

    return 0;
}