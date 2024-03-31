# include <stdio.h>
# include <ctype.h>
# include <string.h>
# include <stdlib.h>
# include "arraylist.h"
// myheader.h

#ifndef LAB1_H

#define LAB1_H

 // MYHEADER_H


extern int yylineno;

extern char* yytext;

extern int yylex(void);

#define CHNMAX 1000

extern int hasFault;

struct SyntaxTree_node
{
    int isleaf;
    char *name;
    int line;
    union{
        char *ID;
        int INT;
        float FLOAT;
    };
    int isempty;
    Arraylist child;
};

typedef struct SyntaxTree_node *sytreenode;

sytreenode createnewnode(int isleaf,char* name,int yyline,Arraylist child,int isempty);

void preordertree(sytreenode root,int depth);

int stoi(char * p);

#endif
