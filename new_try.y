%{
# include <unistd.h>
# include <stdio.h>   
# include "lab.h"

%}


%union{
    sytreenode stnode;
}

%token <stnode> INT FLOAT ID
%token <stnode> SEMI COMMA ASSIGNOP RELOP PLUS MINUS STAR DIV  
%token <stnode> AND OR DOT NOT TYPE LP RP LB RB LC RC
%token <stnode> STRUCT RETURN IF ELSE WHILE
%token <stnode> COMMENT SPACE AERROR NUM_ERROR ID_ERROR
%token <stnode> FORMATERROR

%type <stnode> PROGRAM ExtDefList ExtDef ExtDecList
%type <stnode> Specifier StrcutSpecifier OptTag Tag 
%type <stnode> VarDec FunDec VarList ParamDec CompSt
%type <stnode> StmtList Stmt DefList Def DecList Dec Exp Args
%start PROGRAM

%right ASSIGNOP
%left OR
%left AND
%left RELOP
%left PLUS MINUS
%left STAR DIV
%right NOT
%left LP RP RB LB DOT

%nonassoc eelse
%nonassoc ELSE
%nonassoc l4
%nonassoc l3
%nonassoc l2
%nonassoc l1


%%

PROGRAM : 
    ExtDefList          {Arraylist child = init_arraylist();
                        append_arraylist($1,child);
                        $$ = createnewnode(0,"PROGRAM",$1->line,child,0);
                        preordertree($$,0);
                        printf("\nTO PRO\n");
                        }
    ;

ExtDefList  :   ExtDef ExtDefList {Arraylist child = init_arraylist();
                                append_arraylist($1,child);append_arraylist($2,child);
                                $$ = createnewnode(0,"ExtDefList",$1->line,child,0);
                                printf("\nTO ExtDecList\n");}
    |   {$$ = createnewnode(1,"ExtDefList",yylineno,NULL,1);}
    ;
ExtDef  :   Specifier ExtDecList SEMI %prec l1 {Arraylist child = init_arraylist();
                                                append_arraylist($1,child);
                                                append_arraylist($2,child);
                                                append_arraylist($3,child);
                                                $$ = createnewnode(0,"ExtDef",$1->line,child,0);
                                                printf("\nTO ExtDef 111%d\n",$1->line);}
        |   Specifier SEMI     %prec l1        {Arraylist child = init_arraylist();
                                                append_arraylist($1,child);
                                                append_arraylist($2,child);
                                                $$ = createnewnode(0,"ExtDef",$1->line,child,0);
                                                printf("\nTO ExtDef\n");}
        |   Specifier FunDec CompSt            {Arraylist child = init_arraylist();
                                                append_arraylist($1,child);
                                                append_arraylist($2,child);
                                                append_arraylist($3,child);
                                                $$ = createnewnode(0,"ExtDef",$1->line,child,0);
                                                printf("\nTO ExtDef%d\n",$1->line);}
        |   Specifier FunDec SEMI     %prec l1 {Arraylist child = init_arraylist();
                                                append_arraylist($1,child);
                                                append_arraylist($2,child);
                                                append_arraylist($3,child);
                                                $$ = createnewnode(0,"ExtDef",$1->line,child,0);
                                                printf("\nTO ExtDef\n");}
        |   Specifier ExtDecList  %prec l2   {
                                                yyerror("syntax error");
                                                printf("missing ;\n");}
        |   Specifier             %prec l2      {
                                                yyerror("syntax error");
                                                printf("missing ;\n");}
        |   Specifier FunDec      %prec l2    {
                                                yyerror("syntax error");
                                                printf("missing ;\n");}
        |   error ExtDef          %prec l3           {
                                    yyerror("syntax error");
                                    printf("\nerror extdef\n");
    }
    ;

    ExtDecList :  VarDec                            {Arraylist child = init_arraylist();
                                                    append_arraylist($1,child);
                                                    $$ = createnewnode(0,"ExtDecList",$1->line,child,0);
                                                    printf("\nTO ExtDecList\n");}
    |VarDec COMMA ExtDecList                        {Arraylist child = init_arraylist();
                                                    append_arraylist($1,child);
                                                    append_arraylist($2,child);
                                                    append_arraylist($3,child);
                                                    $$ = createnewnode(0,"ExtDecList",$1->line,child,0);
                                                    printf("TO ExtDecList\n");}
    | VarDec ExtDecList                             {
                                                        yyerror("syntax error");
                                                        printf("\nmising \",\"\n");
                                                    }
    ;

    Specifier : TYPE                    {Arraylist child = init_arraylist();
                                        append_arraylist($1,child);
                                    $$ = createnewnode(0,"Specifier",$1->line,child,0);
                                    printf("\nTO Specifier\n");}
    | StrcutSpecifier              {Arraylist child = init_arraylist();
                                        append_arraylist($1,child);
                                    $$ = createnewnode(0,"Specifier",$1->line,child,0);
                                    printf("\nTO Specifier\n");}
    ;

    StrcutSpecifier : STRUCT OptTag LC DefList RC {Arraylist child = init_arraylist();
                                        append_arraylist($1,child);
                                        append_arraylist($2,child);
                                        append_arraylist($3,child);
                                        append_arraylist($4,child);
                                        append_arraylist($5,child);
                                    $$ = createnewnode(0,"StrcutSpecifier",$1->line,child,0);
                                    printf("\nStrcutSpecifier\n");}
    | STRUCT Tag                    {Arraylist child = init_arraylist();
                                        append_arraylist($1,child);
                                        append_arraylist($2,child);
                                    $$ = createnewnode(0,"StrcutSpecifier",$1->line,child,0);
                                    printf("\nStrcutSpecifier\n");}
    ;

OptTag : ID                         {Arraylist child = init_arraylist();
                                        append_arraylist($1,child);
                                    $$ = createnewnode(0,"OptTag",$1->line,child,0);}
    |                               {$$ = createnewnode(1,"OptTag",yylineno,NULL,1);}
    ;

Tag : ID                            {Arraylist child = init_arraylist();
                                        append_arraylist($1,child);
                                    $$ = createnewnode(0,"Tag",$1->line,child,0);}
    ;



    VarDec : ID                             {Arraylist child = init_arraylist();
                                        append_arraylist($1,child);
                                    $$ = createnewnode(0,"VarDec",$1->line,child,0);
                                    printf("\nTO VarDec\n");}
    | VarDec LB INT RB       %prec l1               {Arraylist child = init_arraylist();
                                        append_arraylist($1,child);
                                        append_arraylist($2,child);
                                        append_arraylist($3,child);
                                        append_arraylist($4,child);
                                    $$ = createnewnode(0,"VarDec",$1->line,child,0);
                                    }
    | VarDec LB INT          %prec l2       {
        yyerror("syntax error");
        printf("\nMISSING ']'\n");}


    ;
FunDec : ID LP VarList RP %prec l1               {Arraylist child = init_arraylist();
                                        append_arraylist($1,child);
                                        append_arraylist($2,child);
                                        append_arraylist($3,child);
                                        append_arraylist($4,child);
                                    $$ = createnewnode(0,"FunDec",$1->line,child,0);}
    | ID LP RP         %prec l1             {Arraylist child = init_arraylist();
                                        append_arraylist($1,child);
                                        append_arraylist($2,child);
                                        append_arraylist($3,child);
                                    $$ = createnewnode(0,"FunDec",$1->line,child,0);}
    | ID LP VarList    %prec l2     {
                            yyerror("syntax error");
                            printf("\nMISSING RP\n");
    }
    ;

VarList : ParamDec COMMA ParamDec   %prec l1   {Arraylist child = init_arraylist();
                                        append_arraylist($1,child);
                                        append_arraylist($2,child);
                                        append_arraylist($3,child);
                                    $$ = createnewnode(0,"VarList",$1->line,child,0);}
    |   ParamDec                    {Arraylist child = init_arraylist();
                                        append_arraylist($1,child);
                                    $$ = createnewnode(0,"VarList",$1->line,child,0);}
    ;
ParamDec : Specifier VarDec         {Arraylist child = init_arraylist();
                                        append_arraylist($1,child);
                                        append_arraylist($2,child);
                                    $$ = createnewnode(0,"ParamDec",$1->line,child,0);
                                    printf("to ParamDec\n");}
    |   VarDec      {
            yyerror("syntax error");
            printf("\nmissing Specifier\n");
    }
    ;

    CompSt : LC DefList StmtList RC     {Arraylist child = init_arraylist();
                                        append_arraylist($1,child);
                                        append_arraylist($2,child);
                                        append_arraylist($3,child);
                                        append_arraylist($4,child);
                                    $$ = createnewnode(0,"CompSt",$1->line,child,0);}
    ;

    StmtList : Stmt StmtList            {Arraylist child = init_arraylist();
                                        append_arraylist($1,child);
                                        append_arraylist($2,child);
                                    $$ = createnewnode(0,"StmtList",$1->line,child,0);
                                        printf("to StmtList\n");}
    |                               {$$ = createnewnode(1,"StmtList",yylineno,NULL,1);}
    ;
    Stmt    :  Exp SEMI  %prec l3            {Arraylist child = init_arraylist();
                                        append_arraylist($1,child);
                                        append_arraylist($2,child);
                                    $$ = createnewnode(0,"Stmt",$1->line,child,0);
                                        printf("to Stmt");}
            | CompSt                        {Arraylist child = init_arraylist();
                                        append_arraylist($1,child);
                                    $$ = createnewnode(0,"Stmt",$1->line,child,0);}
            | RETURN Exp SEMI    %prec l3           {Arraylist child = init_arraylist();
                                        append_arraylist($1,child);
                                        append_arraylist($2,child);
                                        append_arraylist($3,child);
                                    $$ = createnewnode(0,"Stmt",$1->line,child,0);}

            | IF LP Exp RP Stmt   %prec eelse          {Arraylist child = init_arraylist();
                                        append_arraylist($1,child);
                                        append_arraylist($2,child);
                                        append_arraylist($3,child);
                                        append_arraylist($4,child);
                                        append_arraylist($5,child);
                                    $$ = createnewnode(0,"Stmt",$1->line,child,0);
                                    printf("\n IF LP Exp RP Stmt\n");}
            | error ELSE Stmt   {
                            yyerror("syntax error");
                            printf("\nmissing ;\n");
            }

            | IF LP Exp RP Stmt ELSE Stmt   {Arraylist child = init_arraylist();
                                        append_arraylist($1,child);
                                        append_arraylist($2,child);
                                        append_arraylist($3,child);
                                        append_arraylist($4,child);
                                        append_arraylist($5,child);
                                        append_arraylist($6,child);
                                        append_arraylist($7,child);
                                    $$ = createnewnode(0,"Stmt",$1->line,child,0);}
            |   WHILE LP Exp RP Stmt          {Arraylist child = init_arraylist();
                                        append_arraylist($1,child);
                                        append_arraylist($2,child);
                                        append_arraylist($3,child);
                                        append_arraylist($4,child);
                                        append_arraylist($5,child);
                                    $$ = createnewnode(0,"Stmt",$1->line,child,0);}

            | error SEMI               %prec l4     {
                                    yyerror("syntax error");
                                    printf("\nerror stmt\n");
                                            }
    ;

    DefList : Def DefList               {Arraylist child = init_arraylist();
                                        append_arraylist($1,child);
                                        append_arraylist($2,child);
                                    $$ = createnewnode(0,"DefList",$1->line,child,0);}
    |                               {$$ = createnewnode(1,"DefList",yylineno,NULL,1);}
    ;

    Def : Specifier DecList SEMI    %prec l1        {Arraylist child = init_arraylist();
                                        append_arraylist($1,child);
                                        append_arraylist($2,child);
                                        append_arraylist($3,child);
                                    $$ = createnewnode(0,"Def",$1->line,child,0);
                                    printf("\nto Def\n");}
        | Specifier DecList     %prec l2    {
                                yyerror("syntax_error");
                                printf("error!!!!!");
        }
    ;

    DecList : Dec COMMA DecList               {Arraylist child = init_arraylist();
                                        append_arraylist($1,child);
                                        append_arraylist($2,child);
                                        append_arraylist($3,child);
                                    $$ = createnewnode(0,"DecList",$1->line,child,0);
                                    printf("\nto DecList\n");}
    |   Dec                         {Arraylist child = init_arraylist();
                                        append_arraylist($1,child);
                                    $$ = createnewnode(0,"DecList",$1->line,child,0);
                                    printf("\nto DecList\n");}
    ;

    Dec : VarDec                            {Arraylist child = init_arraylist();
                                        append_arraylist($1,child);
                                    $$ = createnewnode(0,"Dec",$1->line,child,0);
                                    printf("\nto Dec\n");}
    | VarDec ASSIGNOP Exp           {Arraylist child = init_arraylist();
                                        append_arraylist($1,child);
                                        append_arraylist($2,child);
                                        append_arraylist($3,child);
                                    $$ = createnewnode(0,"Dec",$1->line,child,0);}
    ;


    Exp : Exp ASSIGNOP Exp                 {Arraylist child = init_arraylist();
                                        append_arraylist($1,child);
                                        append_arraylist($2,child);
                                        append_arraylist($3,child);
                                    $$ = createnewnode(0,"Exp",$1->line,child,0);
                                        printf("\nexp ass exp\n");}
    | Exp AND Exp                       {Arraylist child = init_arraylist();
                                        append_arraylist($1,child);
                                        append_arraylist($2,child);
                                        append_arraylist($3,child);
                                    $$ = createnewnode(0,"Exp",$1->line,child,0);}
    | Exp OR Exp                        {Arraylist child = init_arraylist();
                                        append_arraylist($1,child);
                                        append_arraylist($2,child);
                                        append_arraylist($3,child);
                                    $$ = createnewnode(0,"Exp",$1->line,child,0);}
    | Exp RELOP Exp                     {Arraylist child = init_arraylist();
                                        append_arraylist($1,child);
                                        append_arraylist($2,child);
                                        append_arraylist($3,child);
                                    $$ = createnewnode(0,"Exp",$1->line,child,0);
                                    printf("\nexp relop exp\n");}
    | Exp PLUS Exp                      {Arraylist child = init_arraylist();
                                        append_arraylist($1,child);
                                        append_arraylist($2,child);
                                        append_arraylist($3,child);
                                        printf("\nexp plus exp\n");
                                    $$ = createnewnode(0,"Exp",$1->line,child,0);}
    | Exp MINUS Exp                     {Arraylist child = init_arraylist();
                                        append_arraylist($1,child);
                                        append_arraylist($2,child);
                                        append_arraylist($3,child);
                                    $$ = createnewnode(0,"Exp",$1->line,child,0);}
    | Exp STAR Exp                      {Arraylist child = init_arraylist();
                                        append_arraylist($1,child);
                                        append_arraylist($2,child);
                                        append_arraylist($3,child);
                                    $$ = createnewnode(0,"Exp",$1->line,child,0);}
    | Exp DIV Exp                       {Arraylist child = init_arraylist();
                                        append_arraylist($1,child);
                                        append_arraylist($2,child);
                                        append_arraylist($3,child);
                                    $$ = createnewnode(0,"Exp",$1->line,child,0);}
    | LP Exp RP                         {Arraylist child = init_arraylist();
                                        append_arraylist($1,child);
                                        append_arraylist($2,child);
                                        append_arraylist($3,child);
                                    $$ = createnewnode(0,"Exp",$1->line,child,0);}
    | MINUS Exp                         {Arraylist child = init_arraylist();
                                        append_arraylist($1,child);
                                        append_arraylist($2,child);
                                    $$ = createnewnode(0,"Exp",$1->line,child,0);}
    | NOT Exp                           {Arraylist child = init_arraylist();
                                        append_arraylist($1,child);
                                        append_arraylist($2,child);
                                    $$ = createnewnode(0,"Exp",$1->line,child,0);}
    | Exp LP Args RP                     {Arraylist child = init_arraylist();
                                        append_arraylist($1,child);
                                        append_arraylist($2,child);
                                        append_arraylist($3,child);
                                        append_arraylist($4,child);
                                    $$ = createnewnode(0,"Exp",$1->line,child,0);}
    | Exp LP RP                          {Arraylist child = init_arraylist();
                                        append_arraylist($1,child);
                                        append_arraylist($2,child);
                                        append_arraylist($3,child);
                                    $$ = createnewnode(0,"Exp",$1->line,child,0);}
    | Exp LB Exp RB                     {Arraylist child = init_arraylist();
                                        append_arraylist($1,child);
                                        append_arraylist($2,child);
                                        append_arraylist($3,child);
                                        append_arraylist($4,child);
                                        printf("\nexp lb exp rb\n");
                                    $$ = createnewnode(0,"Exp",$1->line,child,0);}
    | Exp DOT ID                        {Arraylist child = init_arraylist();
                                        append_arraylist($1,child);
                                        append_arraylist($2,child);
                                        append_arraylist($3,child);
                                    $$ = createnewnode(0,"Exp",$1->line,child,0);}
    | ID                %prec l1            {Arraylist child = init_arraylist();
                                        append_arraylist($1,child);
                                        printf("\nid to exp\n");
                                    $$ = createnewnode(0,"Exp",$1->line,child,0);}
    | INT                %prec l1            {Arraylist child = init_arraylist();
                                        append_arraylist($1,child);
                                        printf("\nint to exp\n");
                                    $$ = createnewnode(0,"Exp",$1->line,child,0);}
    | FLOAT             %prec l1             {Arraylist child = init_arraylist();
                                        append_arraylist($1,child);
                                    $$ = createnewnode(0,"Exp",$1->line,child,0);}
    | FORMATERROR              {
                                    printf("out");
                                    Arraylist child = init_arraylist();
                                        append_arraylist($1,child);
                                    $$ = createnewnode(0,"Exp",$1->line,child,0);}
    |error Exp        %prec l4          {
                                yyerror("syntax error");
                                printf("\nerror exp\n");
    }

    ;


    Args : Exp COMMA Args               {Arraylist child = init_arraylist();
                                        append_arraylist($1,child);
                                        append_arraylist($2,child);
                                        append_arraylist($3,child);
                                    $$ = createnewnode(0,"Args",$1->line,child,0);}
    | Exp                           {Arraylist child = init_arraylist();
                                        append_arraylist($1,child);
                                    $$ = createnewnode(0,"Args",$1->line,child,0);}
    ;
%%



    
