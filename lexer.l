%{
#include <stdio.h>
#include <stdlib.h>
#include "lab.h"
#include "new_try.tab.h"
%}

%option yylineno


PLUS \+
MINUS \-
INT8 [+-]?0[1-7][0-7]*
INT10 [+-]?(([1-9][0-9]*)|0)
INT16 [+-]?0[Xx][0-9a-fA-F]+
INT {INT8}|{INT10}|{INT16}
 /*浮点型*/
FLOAT ({INT10}\.[0-9]+)|([+-]?([0-9]*\.[0-9]+|[0-9]+\.[0-9]*)[Ee][+-]?[0-9]+)
 /*数字*/
NUMBER {INT}|{FLOAT}
 /*标识符*/
ID [a-zA-Z_][a-zA-Z0-9_]*
 /*标点*/
SEMI  ;
COMMA ,
ASSIGNOP =
STAR \*
DIV \/
AND &&
OR \|\|
DOT \.
NOT \!
LP \(
RP \)
LB \[
RB \]
LC \{
RC \}
RELOP >|<|>=|<=|==|!=
 /*关键字*/
STRUCT struct
RETURN return
IF if
ELSE else
WHILE while
TYPE int|float
 /*注释*/
LINE_COMMENT ("//"[.]*)
BLOCK_COMMENT "/\*"[.]*"\*/"
COMMENT {LINE_COMMENT}|{BLOCK_COMMENT}
 /*空格*/
SPACE [ \n\r\t]+
 /*错误*/
ERROR_all {NUM_ERROR}|{ID_ERROR}
INT8_ERROR 0[0-7]*[8-9]+[0-7]*
INT16_ERROR 0[Xx][a-fA-F0-9]*[g-zG-Z]+[a-fA-F0-9]*
FLOAT_ERROR (([0-9]*\.[0-9]+|[0-9]+\.[0-9]*)[Ee])|[0-9]+[Ee][0-9]*
NUM_ERROR {INT8_ERROR}|{INT16_ERROR}|{FLOAT_ERROR}
ID_ERROR [0-9]+[a-zA-Z_]+
AERROR .


%%
{SPACE} {
        

}
"//" { char c = input(); while (c != '\n') c = input(); }
"/*" {
    int q = 0;
    char c;
    while(1){
        if(q == 0){
            c = input();
            if(c == EOF)
                break;
            if(c == '*')
                q = 1;
        }else{
            c = input();
            if(c == EOF)
                break;
            if(c == '/')
                break;
            else if(c != '*')
                q = 0;
        }
    }
}

{INT8_ERROR} {
    printf("error type A at line %d: Illegal NUMBER '%s'\n",yylineno,yytext);
    hasFault = 1;
    yylval.stnode = createnewnode(1,"FORMATERROR",yylineno,NULL,0);
    return FORMATERROR;
}
{INT16_ERROR} {
    printf("error type A at line %d: Illegal NUMBER '%s'\n",yylineno,yytext);
    hasFault = 1;
    yylval.stnode = createnewnode(1,"FORMATERROR",yylineno,NULL,0);
    return FORMATERROR;
}
{FLOAT_ERROR} {
    printf("error type A at line %d: Illegal FLOAT NUMBER '%s'\n",yylineno,yytext);
    hasFault = 1;
    yylval.stnode = createnewnode(1,"FORMATERROR",yylineno,NULL,0);
    return FORMATERROR;
}
{TYPE} {
    yylval.stnode = createnewnode(1,"TYPE",yylineno,NULL,0);
    printf("\n%s\n",yytext);
    return TYPE;
}
{SEMI} {
    yylval.stnode = createnewnode(1,"SEMI",yylineno,NULL,0);
    printf("\n%s\n",yytext);
    return SEMI;
    
}
{COMMA} {
    yylval.stnode = createnewnode(1,"COMMA",yylineno,NULL,0);
    printf("\n%s\n",yytext);
    return COMMA;
}
{ASSIGNOP} {
    yylval.stnode = createnewnode(1,"ASSIGNOP",yylineno,NULL,0);
    printf("\n%s\n",yytext);
    return ASSIGNOP;
}
{PLUS} {
    yylval.stnode = createnewnode(1,"PLUS",yylineno,NULL,0);
    printf("%s\t\t",yylval.stnode->name);
    return PLUS;
}
{MINUS} {
    yylval.stnode = createnewnode(1,"MINUS",yylineno,NULL,0);
    printf("\n%s\n",yytext);
    return MINUS;
}
{STAR} {
    yylval.stnode = createnewnode(1,"STAR",yylineno,NULL,0);
    printf("\n%s\n",yytext);
    return STAR;
}
{DIV} {
    yylval.stnode = createnewnode(1,"DIV",yylineno,NULL,0);
    printf("\n%s\n",yytext);
    return DIV;
}
{AND} {
    yylval.stnode = createnewnode(1,"AND",yylineno,NULL,0);
    printf("\n%s\n",yytext);
    return AND;
}
{OR} {
    yylval.stnode = createnewnode(1,"OR",yylineno,NULL,0);
    printf("\n%s\n",yytext);
    return OR;
}
{DOT} {
    yylval.stnode = createnewnode(1,"DOT",yylineno,NULL,0);
    printf("\n%s\n",yytext);
    return DOT;
}
{NOT} {
    yylval.stnode = createnewnode(1,"NOT",yylineno,NULL,0);
    printf("\n%s\n",yytext);
    return NOT;
}
{LP} {
    yylval.stnode = createnewnode(1,"LP",yylineno,NULL,0);
    printf("\n%s\n",yytext);
    return LP;
}
{RP} {
    yylval.stnode = createnewnode(1,"RP",yylineno,NULL,0);
    printf("\n%s\n",yytext);
    return RP;
}
{LB} {
    yylval.stnode = createnewnode(1,"LB",yylineno,NULL,0);
    printf("\n%s\n",yytext);
    return LB;
}
{RB} {
    yylval.stnode = createnewnode(1,"RB",yylineno,NULL,0);
    printf("\n%s\n",yytext);
    return RB;
}
{LC} {
    yylval.stnode = createnewnode(1,"LC",yylineno,NULL,0);
    printf("\n%s\n",yytext);
    return LC;
}
{RC} {
    yylval.stnode = createnewnode(1,"RC",yylineno,NULL,0);
    printf("\n%s\n",yytext);
    return RC;
}
{RELOP} {
    yylval.stnode = createnewnode(1,"RELOP",yylineno,NULL,0);
    printf("\n%s\n",yytext);
    return RELOP;
}
{STRUCT} {
    yylval.stnode = createnewnode(1,"STRUCT",yylineno,NULL,0);
    printf("\n%s\n",yytext);
    return STRUCT;
}
{RETURN} {
    yylval.stnode = createnewnode(1,"RETURN",yylineno,NULL,0);
    printf("\n%s\n",yytext);
    return RETURN;
}
{IF} {
    yylval.stnode = createnewnode(1,"IF",yylineno,NULL,0);
    printf("\n%s\n",yytext);
    return IF;
}
{ELSE} {
    yylval.stnode = createnewnode(1,"ELSE",yylineno,NULL,0);
    printf("\n%s\n",yytext);
    return ELSE;
}
{WHILE} {
    yylval.stnode = createnewnode(1,"WHILE",yylineno,NULL,0);
    printf("\n%s\n",yytext);
    return WHILE;
}
{ID} {yylval.stnode = createnewnode(1,"ID", yylineno, NULL , 0);
            printf("\n%s\n",yytext);
        return ID;}
{INT} {
        yylval.stnode = createnewnode(1,"INT",yylineno,NULL,0);
            printf("\n%s\n",yytext);
            return INT;
}
{FLOAT} {
        yylval.stnode = createnewnode(1,"FLOAT",yylineno,NULL,0);
            printf("\n%s\n",yytext);
            return FLOAT;
}
{AERROR} { 
    hasFault = 1;
    printf("error type A at line %d: mysterious character '%s'\n", yylineno, yytext);
}


