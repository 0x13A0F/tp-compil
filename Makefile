all:
	flex projet.l
	bison -d projet.y
	gcc lex.yy.c projet.tab.c -o projet
clean:
	rm lex.yy.c projet.tab.c projet.tab.h projet
