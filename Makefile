# Makefile for Flex and Bison

# Compiler
CC = gcc

# Flags
CFLAGS = -Wall -g

# Flex
FLEX = flex

# Bison
BISON = bison
BISONFLAGS = -d

# Source files
LEXER_SOURCE = lexer.l
BISON_SOURCE = new_try.y

# Output files
LEXER_C = lex.yy.c
BISON_C = new_try.tab.c
BISON_H = new_try.tab.h

# Executable
EXECUTABLE = parser

all: $(EXECUTABLE)

$(EXECUTABLE): $(BISON_C) $(LEXER_C)
	$(CC) $(CFLAGS) $(BISON_C) $(LEXER_C)  Syntax_Tree.c arraylist.c -lfl  -o $@
	
$(LEXER_C): $(LEXER_SOURCE)
	$(FLEX) $(LEXER_SOURCE)

$(BISON_C): $(BISON_SOURCE)
	$(BISON) $(BISONFLAGS) $(BISON_SOURCE)

clean:
	rm -f $(LEXER_C) $(BISON_C) $(BISON_H) $(EXECUTABLE)

