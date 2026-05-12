# poLite Language Specification

## Overview

poLite is a small C-like language with polite syntax.

The language replaces some traditional C symbols with polite keywords.

| C-like syntax | poLite syntax |
|---|---|
| `;` | `pls` |
| `{` | `do this` |
| `}` | `thanks` |
| `print()` | `say()` |
| `else` | `otherwise` |

## Supported Types

The first version of poLite supports:

- `int`
- `float`
- `bool`

The extended version may also support:

- `char`
- `string`

## Supported Statements

The first version of poLite supports:

- variable declarations
- variable assignments
- `say` statements
- `if` statements
- `while` statements

## Example

```c
int x = 5 pls
float y = 2.5 pls
bool active = true pls

x = x + 1 pls

say(x) pls

if (x > 0) do this
    say(x) pls
thanks

while (x < 10) do this
    x = x + 1 pls
thanks
```

## Minimum Grammar Sketch

```text
program:
    statement_list

statement_list:
    statement
    statement_list statement

statement:
    declaration
    assignment
    say_statement
    if_statement
    while_statement

declaration:
    type identifier pls
    type identifier = expression pls

assignment:
    identifier = expression pls

say_statement:
    say expression pls

if_statement:
    if (expression) block
    if (expression) block otherwise block

while_statement:
    while (expression) block

block:
    do this statement_list thanks
```