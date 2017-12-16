#include <stdio.h>
#include <stdlib.h>
#include<string.h>

typedef struct Information {char* nom;int nat;int type;int taille; float valeur;} Information;
typedef struct id1 * Liste ;
typedef struct id1 { Information element ;Liste suivant; } noeud;

Information getElementListe(Liste l,char* nom)
{
   while (l!=NULL&&(strcmp(l->element.nom,nom)!=0))
           {

               l=l->suivant;
           }


                return (l->element);

}
int GetType(Liste l,char* nom)
{
	while (l!=NULL&&(strcmp(l->element.nom,nom)!=0))
           {

               l=l->suivant;
           }

                if(l!=NULL){
                return (l->element.type);
				}
				else {return -1;}
}
int GetNature(Liste l,char* nom)
{
	while (l!=NULL&&(strcmp(l->element.nom,nom)!=0))
           {

               l=l->suivant;
           }

if(l!=NULL){
                return (l->element.nat);
}
else {return -1;}
}

Liste creer_noeud( )
{ Liste l= (Liste)malloc(sizeof(noeud)) ;
if ( ! l) { printf("erreur d’allocation\n") ;
exit(-1) ;
}
return(l) ;
}


void ajouterTete(Liste *l,Information Elm)
{

    Liste NewListe=creer_noeud();
    NewListe->element=Elm;
    NewListe->suivant=*l;
    *l=NewListe;
    //afficher(NewListe);
}

void inserer(Liste *l,char* nom, int type, int nature,float valeur)
{
Liste p=*l;
Liste NewListe;
Information Elm;
strcpy(Elm.nom,nom);

Elm.type=type;
Elm.nat=nature;
Elm.valeur=valeur;


    if (p==NULL)
    {
        ajouterTete(&p,Elm);
        *l=p;
    }

    else
    {

        while (p->suivant!=NULL)
        {
            p=p->suivant;
        }
        NewListe=(Liste)malloc(sizeof(noeud));
        NewListe->element=Elm;
        p->suivant=NewListe;
	       NewListe->suivant=NULL;
    }
}

void centerText(char *s)
{
        printf("%*s%*s|",7+strlen(s)/2,s,7-strlen(s)/2,"");
}


void afficher (Liste p)
{
    Liste l = p;
    printf("\t      Table des symboles : \n\n");
    printf("----------------------------------------------\n");
    printf("|     Name     |    Nature    |     Type     |\n");
    printf("----------------------------------------------\n");

    while (l!=NULL)
    {
        printf("|");
        centerText(l->element.nom);
        centerText((l->element.nat==0) ? "0 (var)" : "1 (const)");
        centerText((l->element.type==0) ? "0 (integer)" : "1 (real)");
        printf("\n");
        l=l->suivant;
    }
    puts("----------------------------------------------");

}
float getIdfVal(Liste p,char* nom){
  Liste l = p;
  while (l!=NULL && (strcmp(l->element.nom,nom)!=0)){
    l=l->suivant;
  }
  if (l==NULL)  return 0;
  else
      return l->element.valeur;
}

void setIdfVal(Liste p,char* nom,float valeur){
  Liste l = p;
  while (l!=NULL && (strcmp(l->element.nom,nom)!=0)){
    l=l->suivant;
  }
  if (l==NULL)  return ;
  else
      l->element.valeur=valeur;
}

int rechercherNom(Liste p,char* nom)
{

    Liste l = p;
    while (l!=NULL&&(strcmp(l->element.nom,nom)!=0))
           {


               l=l->suivant;
           }
           if (l==NULL)
            {

                return -1;
            }
            else
            {
                return 1;
            }
}


Liste queue (Liste l)
{
    while (l->suivant!=NULL)
    {
        l=l->suivant;
    }
    return l;
}
