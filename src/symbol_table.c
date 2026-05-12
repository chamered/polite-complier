#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "symbol_table.h"

// The symbol table starts empty.
// `head` is static, so it is only visible inside this file.
static Symbol *head = NULL;

// Initializes the symbol table. Usually called in main before parsing.
void init_symbol_table() {
    head = NULL;
}

/*
    Inserts a new symbol into the symbol table.

    Returns:
    - 1 if the symbol was inserted successfully
    - 0 if the symbol already exists

    Parameters:
    - const char *name: symbol name. It is const because this function should not modify it.
    - Type type: symbol type.
    - int initialized: 1 if already initialized, 0 otherwise.
*/
int insert_symbol(const char *name, Type type, int initialized) {
    if (symbol_exists(name)) {
        return 0;
    }

    // Allocate memory for the new symbol.
    Symbol *new_symbol = malloc(sizeof(Symbol));

    /*
        Check if malloc failed.
        stderr is used for error messages, while stdout is used for normal output.
        exit(0) usually means normal exit.
        exit(1) usually means error exit.
    */
    if (new_symbol == NULL) {
        fprintf(stderr, "Memory error: sorry, could not allocate symbol.\n");
        exit(1);
    }

    // Copy the variable name into newly allocated memory.
    // `->` is used to access a field through a pointer to a struct.
    new_symbol->name = strdup(name);

    // Check if strdup failed. If it did, free the symbol before exiting.
    if (new_symbol->name == NULL) {
        fprintf(stderr, "Memory error: could not allocate symbol name.\n");
        free(new_symbol);
        exit(1);
    }

    new_symbol->type = type;
    new_symbol->initialized = initialized;

    // Insert the new symbol at the beginning of the linked list.
    new_symbol->next = head;
    head = new_symbol;

    return 1;
}

/*
    Searches for a symbol by name.

    Returns:
    - a pointer to the symbol if found
    - NULL if the symbol does not exist
*/
Symbol *lookup_symbol(const char *name) {
    Symbol *current = head;

    while (current != NULL) {
        if (strcmp(current->name, name) == 0) {
            return current;
        }

        current = current->next;
    }

    return NULL;
}

// Returns 1 if the symbol exists, 0 otherwise.
// Cleaner than using lookup_symbol directly when only a yes/no answer is needed.
int symbol_exists(const char *name) {
    return lookup_symbol(name) != NULL;
}

// Converts a Type value to a readable string.
// Useful for formatting and cleaner error output.
const char *type_to_string(Type type) {
    switch (type) {
        case TYPE_INT:
            return "int";
        case TYPE_FLOAT:
            return "float";
        case TYPE_BOOL:
            return "bool";
        case TYPE_ERROR:
            return "error";
        default:
            return "invalid";
    }
}

// Prints the current symbol table. Mainly useful for debugging.
void print_symbol_table() {
    Symbol *current = head;

    printf("\nSymbol Table:\n");
    printf("-------------------------\n");

    while (current != NULL) {
        printf("Name: %s | Type: %s | Initialized: %s\n",
               current->name,
               type_to_string(current->type),
               current->initialized ? "yes" : "no");

        current = current->next;
    }

    printf("-------------------------\n");
}

// Frees all memory used by the symbol table.
void free_symbol_table() {
    Symbol *current = head;

    while (current != NULL) {
        // Save the next symbol before freeing the current one.
        Symbol *next = current->next;

        free(current->name);
        free(current);

        current = next;
    }

    head = NULL;
}