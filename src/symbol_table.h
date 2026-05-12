#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H
/*
    Defining variables Types, such as int, float, bool
*/
typedef enum {
    TYPE_INT,
    TYPE_FLOAT,
    TYPE_BOOL,
    TYPE_ERROR
} Type;

/*
    Defining Symbol, every sumbol has a:
    - Name (string, which in c is char points to next)
    - Type (defined before)
    - Initialized (0 is not initialized, 1 is initialized)
    - Symbol *(Connects Symbol as a linked list)
*/ 
typedef struct Symbol {
    char *name;
    Type type;
    int initialized;
    struct Symbol *next;
} Symbol;

void init_symbol_table();

/*
    Insert new variable into symbol table. E.G:

    `insert_symbol("x", TYPE_INT, 0);`

    declared as `int` because it returns an int that will be used
    to see if it is inserted correctly
*/
int insert_symbol(const char *name, Type type, int initialized);

/*
    Useful to see if a symbol is already initialized.
    Before: `x = 5 pls`, use `lookup_symbol("x")` to see if x is
    already initialized. Outputs pointer to symbol
*/
Symbol *lookup_symbol(const char *name);

/*
    Can use lookup_symbol, just Outputs an int, more useful if only
    checking for existence (yes/no) of a symbol. Keep it for readibility
*/
int symbol_exists(const char *name);

/*
    Converts internal type to a readable string. E.G:
    
    `type_to_string(TYPE_INT)` outputs "int", for more readable and cleaner
    error generations. 
    
    E.G:
    
    `printf("Expected int, got %s\n", type_to_string(actual_type));`
*/
const char *type_to_string(Type type);

//Debugging purposes
void print_symbol_table();

//Free the memory used by symbol table
void free_symbol_table();
#endif
