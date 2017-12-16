#include <stdio.h>
#include <stdlib.h>

typedef struct infoQuad {char *op;char *op1;char *op2;char *R;}infoQuad;
typedef struct idq2 * ListeQuad ;

typedef struct idq2 { infoQuad element;
ListeQuad suivant; } noeudQuad;
typedef struct pileQuad {int nbrelement; ListeQuad element[60]; }pileQuad;


ListeQuad desempilerQuad (pileQuad *l)
{
    pileQuad *p=l;
    ListeQuad elm;
    elm=p->element[0];
    p->nbrelement--;
    int i;
    for (i=0;i<p->nbrelement;i++)
    {
        p->element[i]=p->element[i+1];
    }
    return elm;
}


void empilerQuad(pileQuad *l,ListeQuad elm)
{
    pileQuad *p=l;
    p->nbrelement++;
    int i=0;
    for (i=p->nbrelement;i>0;i--)
    {
        p->element[i]=p->element[i-1];
    }
    p->element[0]=elm;


}


pileQuad creerpileQuad()
{
    pileQuad p;
    p.nbrelement=0;
    return p;
}

ListeQuad creer_noeudQuad(){
ListeQuad L= (ListeQuad)malloc(sizeof(noeudQuad)) ;
if ( ! L) { printf("erreur d’allocation\n") ;
exit(-1) ;
}
return(L) ;
}


void ajouterTeteQuad(ListeQuad *l,infoQuad elm)
{
    ListeQuad nouv=creer_noeudQuad();
    nouv->element=elm;
    nouv->suivant=*l;
    *l=nouv;
}
void afficherQuad(ListeQuad l)
{int i=1;
  printf("\n\n\t\tQuadruples:\n\n---------------------------------------------\n");

while(l!=NULL){

printf ("|  %d - (%s,%s,%s,%s)\n",i,l->element.op,l->element.op1,l->element.op2,l->element.R);i++;
l=l->suivant;
}
printf("---------------------------------------------\n\n");
}


void insererQuad(ListeQuad *l,char* op,char* op1,char* op2,char* R)
{
ListeQuad p=*l;
ListeQuad nouv;
infoQuad Elm;

//strcpy(Elm.op,op);
//printf ("i am here\n");
//strcpy(Elm.op1,op1);
//strcpy(Elm.op2,op2);
//strcpy(Elm.R,R);
Elm.op=op;
Elm.op1=op1;
Elm.op2=op2;
Elm.R=R;

    if (p==NULL)
    {
        //printf("here too\n");
        //p=creer_noeud();
        ajouterTeteQuad(&p,Elm);
        *l=p;
    }

    else
    {
        //printf("no here\n");
        while (p->suivant!=NULL)
        {
            p=p->suivant;
        }
        nouv=(ListeQuad)malloc(sizeof(noeudQuad));
        nouv->element=Elm;
        p->suivant=nouv;
    }

}


infoQuad RechercherQuad (ListeQuad l,int nb)
{   nb--;
    while (nb!=0)
    {
        l=l->suivant;
        nb--;
    }
    return (l->element);
}
