#include <stdio.h>

#include <stdlib.h>

#define CHNMAX 1000

#include "arraylist.h"

#include "lab.h"

extern int yylineno;
extern int yyparse();
extern void yyrestart(FILE *);
extern char *yytext;

int hasFault = 0;

sytreenode createnewnode(int isleaf, char *name, int yyline, Arraylist child,int isempty)
{
    sytreenode thisnode = (sytreenode)malloc(sizeof(struct SyntaxTree_node));
    if (thisnode == NULL)
    {
        printf("malloc error!");
        exit(0);
    }
    thisnode->isempty = isempty;
    thisnode->isleaf = isleaf;
    thisnode->name = name;
    thisnode->child = child;
    thisnode->line = yyline;
    // 是叶子节点是终结符
    if (isleaf)
    {
        thisnode->child = NULL;
        ;
        // 是ID
        if (!strcmp(name, "ID") || !strcmp(name, "TYPE"))
        {
            char *temp = (char *)malloc(40 * sizeof(char));
            strcpy(temp, yytext);
            thisnode->ID = temp;
        }
        else if (!strcmp(name, "INT"))
        {
            thisnode->INT = stoi(yytext);
            /* code */
        }
        else if (!strcmp(name, "FLOAT"))
        {
            thisnode->FLOAT = atof(yytext);
        }
        else thisnode->ID = "null";
    }
    return thisnode;
}
void preordertree(sytreenode root, int depth)
{
    if (!hasFault)
    {   
        if(!root->isempty){
            for(int i = 0;i<depth;i++)
            printf("  ");
        if (strcmp(root->name, "TYPE") && strcmp(root->name, "INT") && strcmp(root->name, "FLOAT") && strcmp(root->name, "ID"))
        {
            if(root->isleaf)
                printf("%s\n", root->name);
            else
                printf("%s:(%d)\n", root->name,root->line);
        }
        else{
            if(!strcmp(root->name,"TYPE") || !strcmp(root->name,"ID"))
            printf("%s:%s\n", root->name,root->ID);
            if(!strcmp(root->name,"INT"))
            printf("%s:%d\n", root->name,root->INT);
            if(!strcmp(root->name,"FLOAT"))
            printf("%s:%f\n", root->name,root->FLOAT);
        }
        }
        if (root->isleaf)
            {
                return;
            }
            else
            {
                int num = root->child->num;
                for (int i = 0; i < num; i++)
                {
                    preordertree(root->child->elements[i].data, depth + 1);
                }
            }
    }
}
void yyerror(char *msg)
{
    hasFault = 1;
    fprintf(stderr, "Error type B at Line %d: %s.\n", yylineno, msg);
}
int stoi(char * p){
    int num = 0;
    // 16进制
    if (p[0] == '0' && (p[1] == 'x' || p[1] == 'X')){
         p += 2;
        while (*p != '\0'){
            if (*p >= '0' && *p <= '9')
                num = num * 16 + (*p -'0');
            else    
                num = num * 16 + (tolower(*p) - 'a' + 10);
            p ++;
        }
    }
    // 10进制
    else if (p[0] != '0' || (p[0] == '0' && p[1] == '\0')){
       num = atoi(p);
    }
    // 8进制
    else {
        p += 1;
        while (*p != '\0') {
            num = num * 8 + (*p - '0');
            p++;
        } 
    }
    return num;
}
int main(int argc, char **argv)
{
    if (argc < 2)
    {
        return 1;
    }   
    hasFault = 0;

    FILE *f = fopen(argv[1], "r");
    if (!f)
    {
        perror(argv[1]);
        return 1;
    }
    yyrestart(f);
    yyparse();
    fclose(f);
    printf("\n");

}
