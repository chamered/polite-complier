# Compiler
CC = gcc

# Tools
FLEX = flex
BISON = bison

# Compiler flags
CFLAGS = -Wall -Wextra -g -Isrc

# Executable name
TARGET = poLite

# Project folders
SRC_DIR = src
BUILD_DIR = build

# Source files
LEXER = $(SRC_DIR)/lexer.l
PARSER = $(SRC_DIR)/parser.y
SYMBOL_TABLE_C = $(SRC_DIR)/symbol_table.c
MAIN_C = $(SRC_DIR)/main.c

# Generated files
LEXER_C = $(BUILD_DIR)/lex.yy.c

PARSER_C = $(BUILD_DIR)/parser.tab.c
PARSER_H = $(BUILD_DIR)/parser.tab.h

# Default target
all: $(TARGET)

# Final executable
$(TARGET): $(LEXER_C) $(PARSER_C) $(SYMBOL_TABLE_C) $(MAIN_C)
	$(CC) $(CFLAGS) $(MAIN_C) $(LEXER_C) $(PARSER_C) $(SYMBOL_TABLE_C) -o $(TARGET)

# Generate parser with Bison
$(PARSER_C) $(PARSER_H): $(PARSER)
	mkdir -p $(BUILD_DIR)
	$(BISON) -d -o $(PARSER_C) $(PARSER)

# Generate lexer with Flex
#
# IMPORTANT:
# lexer.l includes parser.tab.h,
# so parser.tab.h must exist before Flex runs.
$(LEXER_C): $(LEXER) $(PARSER_H)
	mkdir -p $(BUILD_DIR)
	$(FLEX) -o $(LEXER_C) $(LEXER)

# Run compiler
run: $(TARGET)
	./$(TARGET)

# Clean generated files
clean:
	rm -rf poLite.dSYM
	rm -rf $(BUILD_DIR)
	rm -f $(TARGET)