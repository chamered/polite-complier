# poLite Language Specification

## Overview

poLite is a small C-like language with polite syntax.

The language replaces some traditional C symbols with polite keywords.

| Traditional C symbol | poLite keyword |
|---|---|
| `;` | `pls` |
| `{` | `do this` |
| `}` | `thanks` |
| `else` | `otherwise` |
| `print()` | `say()` |

## Statement Terminator

Every statement must end with `pls`.

Example:

```c
int age = 20 pls
string name = "Nicholas" pls
say(name) pls
```
