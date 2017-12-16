%{
#include <stdio.h>
#include <stdio.h>
#include "projet.tab.h"
extern YYSTYPE yylval;
int col=1,line=1;
%}

%option noyywrap
%x m_comment

idf               [a-zA-Z]([a-zA-Z0-9_]*[a-zA-Z0-9])?
Uint              [0-9]*
Ufloat            [0-9]+\.[0-9]+
comment           "//".*

saut              [\r\n]
espace            [ \t]
%%

"/*"              { BEGIN(m_comment); }
<m_comment>"*/"   { BEGIN(INITIAL); printf("Multiline_Comment\n");}
<m_comment>.      {;}

{comment}         {printf("Single_Comment\n");}

"Uint"              {col+=yyleng;yylval.chaine=strdup(yytext); printf("Uint ==> Keyword\n"); return Uint;}
"Ufloat"            {col+=yyleng;yylval.chaine=strdup(yytext); printf("Ufloat ==> Keyword\n"); return Ufloat;}
"define"            {col+=yyleng;yylval.chaine=strdup(yytext); printf("define ==> Keyword\n"); return define;}
"CHECK"             {col+=yyleng;yylval.chaine=strdup(yytext); printf("CHECK ==> Keyword\n"); return CHECK;}
"ENDCHECK"          {col+=yyleng;yylval.chaine=strdup(yytext); printf("ENDCHECK ==> Keyword\n"); return ENDCHECK;}
"REPEAT"            {col+=yyleng;yylval.chaine=strdup(yytext); printf("REPEAT ==> Keyword\n"); return REPEAT;}
"ENDREPEAT"         {col+=yyleng;yylval.chaine=strdup(yytext); printf("ENDREPEAT ==> Keyword\n"); return ENDREPEAT;}

{idf}             {
                  if(yyleng>8)
                      {fprintf(stderr,"Erreur lexicale %d:%d \n",line,col); exit(1);}
                  else
                      printf("%s ==> IDF\n",yytext);
                  col+=yyleng;yylval.chaine=strdup(yytext); return idf;
                  }

{Uint}            {
                  if((atoi(yytext)<0)||(atoi(yytext)>320000))
                    {fprintf(stderr,"Erreur lexicale %d:%d",line,col); exit(1); }
                  else{
                    printf("%d  ==> Uint\n",atoi(yytext));
                    yylval.Int=atoi(yytext);
                  }
                  col+=yyleng; yylval.chaine=strdup(yytext);
                  return integer;
                  }

{Ufloat}          {
                  col+=yyleng; yylval.chaine=strdup(yytext);
                  printf("%f ==> Ufloat\n",atof(yytext));

                  return real;
                  }

"="               {col+=yyleng;yylval.chaine=strdup(yytext); printf("Affectation\n"); return affect;}
"+"               {col+=yyleng;yylval.chaine=strdup(yytext); printf("Addition\n"); return Plus;}
"-"               {col+=yyleng;yylval.chaine=strdup(yytext); printf("Soustraction\n"); return Minus;}
"*"               {col+=yyleng;yylval.chaine=strdup(yytext); printf("Multiplication\n"); return Mul;}
"/"               {col+=yyleng;yylval.chaine=strdup(yytext); printf("Division\n"); return Div;}

"<"               {col+=yyleng;yylval.chaine=strdup(yytext); printf("Comparaison (Inferieure)\n"); return inf;}
">"               {col+=yyleng;yylval.chaine=strdup(yytext); printf("Comparaison (Superieure)\n"); return sup;}
"<="              {col+=yyleng;yylval.chaine=strdup(yytext); printf("Comparaison (Inferieure ou Egale)\n"); return inf_eg;}
">="              {col+=yyleng;yylval.chaine=strdup(yytext); printf("Comparaison (Superieure ou Egale)\n"); return sup_eg;}
"=="              {col+=yyleng;yylval.chaine=strdup(yytext); printf("Comparaison (Egalite)\n"); return egal;}
"!="              {col+=yyleng;yylval.chaine=strdup(yytext); printf("Comparaison (Different)\n"); return not_egal;}

"&"               {col+=yyleng;yylval.chaine=strdup(yytext); printf("Logique (ET)\n"); return and;}
"|"               {col+=yyleng;yylval.chaine=strdup(yytext); printf("Logical (OU)\n"); return or;}
"!"               {col+=yyleng;yylval.chaine=strdup(yytext); printf("Logical (NOT)\n"); return not;}

"{"               {col+=yyleng;yylval.chaine=strdup(yytext); return '{';}
"}"               {col+=yyleng;yylval.chaine=strdup(yytext); return '}';}
"("               {col+=yyleng;yylval.chaine=strdup(yytext); return '(';}
")"               {col+=yyleng;yylval.chaine=strdup(yytext); return ')';}
","               {col+=yyleng;yylval.chaine=strdup(yytext); return ',';}
";"               {col+=yyleng;yylval.chaine=strdup(yytext); return ';';}
":"               {col+=yyleng;yylval.chaine=strdup(yytext); return ':';}

{saut}              {col=0; line++;}
{espace}            {;}
.                 {printf("Errueur lexicale (%d:%d)\n",line,col); col++;}

%%
