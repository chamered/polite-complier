# Compiler used to build the project
CC = gcc

# Compilation flags:
# -Wall   enables common warnings
# -Wextra enables extra warnings
# -g      adds debug information
CFLAGS = -Wall -Wextra -g

# Name of the executable that will be generated
TARGET = poLite

# Default target.
# When you run just `make`, this target is executed.
all: $(TARGET)

# Current temporary build:
# for now, poLite is generated using the Symbol Table test file.
#
# This compiles:
# - test/test_symbol_table.c  -> temporary C test for the Symbol Table
# - src/symbol_table.c        -> actual Symbol Table implementation
#
# Later, when main.c becomes the real compiler entry point,
# replace test/test_symbol_table.c with src/main.c.
$(TARGET): test/test_symbol_table.c src/symbol_table.c src/symbol_table.h
	$(CC) $(CFLAGS) test/test_symbol_table.c src/symbol_table.c -o $(TARGET)

# Removes the generated executable.
# Run with:
# make clean
clean:
	rm -f $(TARGET)