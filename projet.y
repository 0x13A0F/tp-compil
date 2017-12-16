%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ts.h"
#include "quad.h"
extern int line;
extern int col;
extern int line;
int yylex();
int yyerror(char* s);
Liste sym_tab;
ListeQuad Quads;
int cmp=1, qc=0;
int col;
int Type;
char t[10];
%}

%union {
  char* chaine;
  int Int;
  float Real;
  struct s {char* val;  int Type; } s;
}

%token <chaine> idf
%token Uint Ufloat
%token define CHECK ENDCHECK REPEAT ENDREPEAT
%token affect
%left or and not
%left sup sup_eg egal not_egal inf_eg inf
%left Plus Minus
%left Mul Div
%token '{' '}' '(' ')' ',' ';' ':'
%token <Int> integer
%token <Real> real
%type <s> val;
%type <s> arithm_exp;
%type <s> comp_exp;
%start s

%%

s: idf '{' part_decl '{' part_instruc '}' '}'  {
                                                puts("\n-------------------\n| Programme juste |\n-------------------\n");
                                                afficher(sym_tab);
                                                afficherQuad(Quads);
                                              }

part_decl:        dec_var part_decl         {puts("Declaration des variables");}
                | dec_const part_decl       {puts("Declaration des constantes");}
                |
                ;

part_instruc:      Affectation ';' part_instruc   {puts("instruction d'Affectation");}
                |  CHECK_Cond part_instruc    {puts("CHECK condition");}
                |  Boucle part_instruc        {puts("Boucle");}
                |
                ;

dec_var:        type noms ';'
                ;

noms:           idf ',' noms          {
                                      if (rechercherNom(sym_tab,$1)==1)
                                        { fprintf(stderr,"Erreur semantique:(%d:%d) %s a deja ete declare\n",line,col,$1); exit(1); }
                                      else
                                        inserer(&sym_tab,$1,Type,0, 0);
                                      }
                | idf                 {
                                      if (rechercherNom(sym_tab,$1)==1)
                                        { fprintf(stderr,"Erreur semantique:(%d:%d) %s a deja ete declare\n",line,col,$1); exit(1); }
                                      else
                                        inserer(&sym_tab,$1,Type,0, 0);
                                      }
                ;

dec_const:      define type idf affect val ';'    {
                                                  if (rechercherNom(sym_tab,$3)==1)
                                                    { fprintf(stderr,"Erreur semantique:(%d:%d) %s a deja ete declare\n",line,col,$3); exit(1); }
                                                  if ($5.Type != Type)
                                                    { fprintf(stderr,"Erreur semantique:(%d:%d) incompatibilite des types\n",line,col); exit(1);}
                                                  else    {
                                                    if ($5.Type==0) inserer(&sym_tab,$3,Type,1,(float)atoi($5.val));
                                                    else inserer(&sym_tab,$3,Type,1,atof($5.val));
                                                  }
                                                  }
                ;

type:           Uint                  {Type=0;}
                |Ufloat               {Type=1;}
                ;

val:            integer {$$.Type=0; }
                | real  {$$.Type=1; }
                ;

Affectation:    idf affect arithm_exp     {
                                              if (rechercherNom(sym_tab,$1)==-1)
                                                { fprintf(stderr,"Erreur semantique:(%d:%d) %s n'est pas declare\n",line,col,$1); exit(1); }
                                              else if (GetType(sym_tab,$1) != $3.Type)
                                                { fprintf(stderr,"Erreur semantique:(%d:%d) incompatibilite des types entre %s et %s\n",line,col,$1,$3); exit(1);}
                                              else if (GetNature(sym_tab,$1))
                                                { fprintf(stderr,"Erreur semantique:(%d:%d) On peut pas modifier la valeur d'une Constante\n",line,col); exit(1);}
                                              else{
                                                if ($3.Type==0) setIdfVal(sym_tab,$1,(float)atoi($3.val));
                                                else setIdfVal(sym_tab,$1,atof($3.val));
                                                insererQuad(&Quads,"=",$3.val," ",$1);
                                                printf("%d-(=,%s,,%s)\n",qc,$3.val,$1);
                                                qc++;
                                                }
                                              }
                ;

arithm_exp:    val  {$$.Type = $1.Type; if ($$.Type==0) sprintf($$.val,"%d",atoi($1.val)); else sprintf($$.val,"%f",atof($1.val));}
               |idf  {
                 if (rechercherNom(sym_tab,$1)==-1)
                   { fprintf(stderr,"Erreur semantique:(%d:%d) %s n'est pas declare\n",line,col,$1); exit(1); }
                 $$.Type=GetType(sym_tab,$1);
                 //if ($$.Type==0)
                //    sprintf($$.val,"%d",(int)getIdfVal(sym_tab,$1));
                // else
                  //  sprintf($$.val,"%f",getIdfVal(sym_tab,$1));
               }
               |arithm_exp Plus arithm_exp {
                                            if ($1.Type == $3.Type){
                                                $$.Type=$1.Type;
                                                  //if ($$.Type == 0)   sprintf($$.val,"%d",atoi($1.val)+atoi($3.val));
                                                  //else                sprintf($$.val,"%f",atof($1.val)+atof($3.val));
                                                sprintf(t,"T%d",cmp++);
                                                insererQuad(&Quads,"+",$1.val,$3.val,strdup(t));
                                                printf("\n\n%d-(+,%s,%s,%s)\n\n",qc,$3.val,$1.val,t);
                                                qc++;
                                                $$.val=strdup(t);
                                            }
                                            else {
                                                fprintf(stderr,"Erreur semantique:(%d:%d) types incompatibles entre %s et %s\n",line,col,$1.val,$3.val);
                                                exit(1);
                                            }
                                           }
                |arithm_exp Minus arithm_exp {
                                              if ($1.Type == $3.Type){
                                                $$.Type=$1.Type;
                                                //if ($$.Type == 0) sprintf($$.val,"%d",atoi($1.val)-atoi($3.val));
                                                //else      sprintf($$.val,"%f",atof($1.val)-atof($3.val));
                                                sprintf(t,"T%d",cmp++);

                                                insererQuad(&Quads,"-",$1.val,$3.val,strdup(t));
                                                printf("\n\n%d-(-,%s,%s,%s)\n\n",qc,$3.val,$1.val,t);
                                                qc++;
                                                $$.val=strdup(t);

                                              }
                                              else {
                                                  fprintf(stderr,"Erreur semantique:(%d:%d) types incompatibles entre %s et %s\n",line,col,$1.val,$3.val);
                                                  exit(1);
                                                  }
                                            }
                |arithm_exp Mul arithm_exp {
                                              if ($1.Type == $3.Type){
                                                $$.Type=$1.Type;
                                                //if ($$.Type == 0)   sprintf($$.val,"%d",atoi($1.val)*atoi($3.val));
                                                //else  sprintf($$.val,"%f",atof($1.val)*atof($3.val));
                                                sprintf(t,"T%d",cmp++);
                                                insererQuad(&Quads,"*",$1.val,$3.val,strdup(t));
                                                printf("\n\n%d-(*,%s,%s,%s)\n\n",qc,$3.val,$1.val,t);
                                                qc++;
                                                $$.val=strdup(t);
                                              }
                                              else {
                                                  fprintf(stderr,"Erreur semantique:(%d:%d) types incompatibles entre %s et %s\n",line,col,$1.val,$3.val);
                                                  exit(1);
                                                  }
                }
               |arithm_exp Div arithm_exp {
                                             if ($1.Type == $3.Type){
                                               $$.Type=$1.Type;
                                               if (atoi($3.val)==0)  { fprintf(stderr,"Erreur semantique:(%d:%d) divison par zero\n",line,col); exit(1); }
                                               //if ($$.Type == 0)    sprintf($$.val,"%d",atoi($1.val)/atoi($3.val));
                                               //else   sprintf($$.val,"%f",atof($1.val)/atof($3.val));
                                               sprintf(t,"T%d",cmp++);
                                               insererQuad(&Quads,"/",$1.val,$3.val,strdup(t));
                                               printf("\n\n%d-(/,%s,%s,%s)\n\n",qc,$3.val,$1.val,t);
                                               qc++;
                                               $$.val=strdup(t);
                                             }
                                             else {
                                                 fprintf(stderr,"Erreur semantique:(%d:%d) types incompatibles entre %s et %s\n",line,col,$1.val,$3.val);
                                                 exit(1);
                                                 }
               }
               ;

CHECK_Cond:     CHECK '(' Condition ')' ':' part_instruc ':' part_instruc ENDCHECK  ;
                ;

Condition:       '(' comp_exp ')' or Condition   ;
                |'(' comp_exp ')' and Condition  ;
                | '(' comp_exp ')'  ;
                ;

comp_exp:       comp_exp inf comp_exp      {
                                            printf("Inferieur\n");
                                            sprintf(t,"T%d",cmp++);
                                            insererQuad(&Quads,"BGE"," ",$1.val,$3.val);
                                            printf("%d-(BGE, ,%s,%s)\n",qc,$1.val,$3.val);
                                            qc++;
                                           }
                |comp_exp inf_eg comp_exp    {
                                              printf("Inferieur ou Egale\n");
                                              sprintf(t,"T%d",cmp++);
                                              insererQuad(&Quads,"BG"," ",$1.val,$3.val);
                                              printf("%d-(BG, ,%s,%s)\n",qc,$1.val,$3.val);
                                              qc++;
                                              }
                |comp_exp sup comp_exp      {
                                              printf("Inferieur ou Egale\n");
                                              sprintf(t,"T%d",cmp++);
                                              insererQuad(&Quads,"BLE"," ",$1.val,$3.val);
                                              printf("%d-(BLE, ,%s,%s)\n",qc,$1.val,$3.val);
                                              qc++;
                                            }
                |comp_exp sup_eg comp_exp  {
                                              printf("Inferieur ou Egale\n");
                                              sprintf(t,"T%d",cmp++);
                                              insererQuad(&Quads,"BL"," ",$1.val,$3.val);
                                              printf("%d-(BL, ,%s,%s)\n",qc,$1.val,$3.val);
                                              qc++;
                                              }
                |comp_exp egal comp_exp   {
                                            printf("Inferieur ou Egale\n");
                                            sprintf(t,"T%d",cmp++);
                                            insererQuad(&Quads,"BE"," ",$1.val,$3.val);
                                            printf("%d-(BE, ,%s,%s)\n",qc,$1.val,$3.val);
                                            qc++;
                }
                |comp_exp not_egal comp_exp {
                                            printf("Inferieur ou Egale\n");
                                            sprintf(t,"T%d",cmp++);
                                            insererQuad(&Quads,"BNE"," ",$1.val,$3.val);
                                            printf("%d-(BNE, ,%s,%s)\n",qc,$1.val,$3.val);
                                            qc++;
                }
                |arithm_exp ;
                ;


Boucle:         REPEAT ':' Affectation  ':'  Condition  ':' Affectation ':' part_instruc ENDREPEAT    ;
                ;


%%

int yyerror(char* s){
  fprintf(stderr,"Erreur fatale:(%d:%d): %s \n",line,col,s);
  return 1;
}
int main(){
  yyparse();
  return 0;
}
