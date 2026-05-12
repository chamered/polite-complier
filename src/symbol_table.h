#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

/*
    Defines the supported variable types.

    For now, the language only supports:
    - int
    - float
    - bool

    TYPE_ERROR is used to represent semantic/type errors.
*/
typedef enum {
    TYPE_INT,
    TYPE_FLOAT,
    TYPE_BOOL,
    TYPE_ERROR
} Type;

/*
    Represents a symbol in the symbol table.

    Each symbol has:
    - name: the variable name, stored as a C string (`char *`)
    - type: the variable type
    - initialized: 0 if not initialized, 1 if initialized
    - next: pointer to the next symbol in the linked list
*/
typedef struct Symbol {
    char *name;
    Type type;
    int initialized;
    struct Symbol *next;
} Symbol;

/*
    Initializes the symbol table.
*/
void init_symbol_table();

/*
    Inserts a new variable into the symbol table.

    Example:
    insert_symbol("x", TYPE_INT, 0);

    Returns:
    - 1 if the symbol was inserted correctly
    - 0 if the symbol already exists
*/
int insert_symbol(const char *name, Type type, int initialized);

/*
    Searches for a symbol by name.

    Returns:
    - a pointer to the Symbol if found
    - NULL if the symbol does not exist

    Useful to check if a variable was declared and to access its type
    or initialization status.
*/
Symbol *lookup_symbol(const char *name);

/*
    Checks whether a symbol exists.

    Returns:
    - 1 if the symbol exists
    - 0 otherwise

    Useful when only a yes/no answer is needed.
*/
int symbol_exists(const char *name);

/*
    Converts an internal Type value to a readable string.

    Example:
    type_to_string(TYPE_INT) returns "int"

    Useful for cleaner error messages.
*/
const char *type_to_string(Type type);

/*
    Prints the current symbol table.
    Mainly useful for debugging.
*/
void print_symbol_table();

/*
    Frees all memory used by the symbol table.
*/
void free_symbol_table();

#endif