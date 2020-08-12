# VAIS Adela
all: flex

flex:
	flex 3d_objects.l
	gcc -o 3d_objects lex.yy.c helper.c

clean: 
	rm -f 3d_objects lex.yy.c
