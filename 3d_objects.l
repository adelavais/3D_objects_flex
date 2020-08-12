%{
// VAIS Adela
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include "helper.h"

int i, j, t;
int simple_objects = 0;
int composed_objects = 0;
int inside_object = -1;
int idx_simple = 0;
int idx_composed = 0;
char *current_object;
bool vertex_values_present = false;
bool colors_values_present = false;
bool faces_value_present = false;
bool faces_ended = false;

%}

digit 							[0-9]
double_number 					{digit}+"."{digit}*
whitespace 						[ |\t|\n]
double_and_whitespace 			{double_number}{whitespace}+
integer 						{digit}+
integer_and_whitespace 			{integer}{whitespace}+
integer_and_semicolon 			{integer};
double_color 					"0"|"1"|"1.0"|"0."{digit}+
double_color_and_whitespace 	{double_color}{whitespace}+
object_name 					[A-Za-z][_A-Za-z0-9]*

%x START_PARANTHESIS
%x CHECK_VERTEX
%x CHECK_COLORS
%x CHECK_FACES
%x INSIDE_OBJECT

%%
<INITIAL>
"Object "{object_name} 				{
										inside_object++;
										simple_objects++;
										free(current_object);
										current_object = malloc(yyleng * sizeof(char));
										strcpy(current_object, yytext + 7);
										vertex_values_present = false;
										faces_value_present = false;
										colors_values_present = false;
										BEGIN(START_PARANTHESIS);
									}

{whitespace}*"}"{whitespace}*"\n"	{
										inside_object--;
										if (inside_object < -1)
											return -1;
									}
							

.|\n 								{
										return -1;
									}

<START_PARANTHESIS>
{whitespace}*"{"{whitespace}*"\n""vertexes"	{
										BEGIN(CHECK_VERTEX);
									}

<START_PARANTHESIS>						
.|\n 								{
									return -1;
									}
			
<CHECK_VERTEX>
"faces" 							{
										if (!vertex_values_present)
											return -1;
										faces_ended = false;
										BEGIN(CHECK_FACES);
									}


<CHECK_VERTEX>
{whitespace}*"("{whitespace}*{double_and_whitespace}{2,3}{double_number}{whitespace}*")"{whitespace}*"\n""colors" {
										vertex_values_present = true;
										BEGIN(CHECK_COLORS);
									}
								
<CHECK_VERTEX>
{whitespace}*"("{whitespace}*{double_and_whitespace}{2,3}{double_number}{whitespace}*")"{whitespace}* {
										vertex_values_present = true;
									}

<CHECK_VERTEX>
.|\n 								{
										return -1;
									}

 
<CHECK_COLORS>
{whitespace}*"("{whitespace}*{double_color_and_whitespace}{2,3}{double_color}{whitespace}*")"{whitespace}* {
										colors_values_present = true;
									}

<CHECK_COLORS>
{whitespace}*"faces" 				{
										if (!colors_values_present)
											return -1;
										faces_ended = false;
										BEGIN(CHECK_FACES);
									}

<CHECK_COLORS>
.|\n 								{
										return -1;
									}

<CHECK_FACES>
{whitespace}*{integer_and_whitespace}{2}{integer_and_semicolon}{whitespace}*"\n""Object"{whitespace}* {
					if (inside_object == 0) {
						insertComposedObject(&array_composed_objects, current_object, inside_object);
					}
					insertObject(&composed_objects_names, current_object);
					composed_objects++;
					BEGIN(INSIDE_OBJECT);
				}

<CHECK_FACES>
{whitespace}*{integer_and_whitespace}{3}"\n""Object"{whitespace}* {
					if (inside_object == 0) {
						insertComposedObject(&array_composed_objects, current_object, inside_object);
					}
					insertObject(&composed_objects_names, current_object);
					composed_objects++;
					BEGIN(INSIDE_OBJECT);
				}

			
<CHECK_FACES>
{whitespace}*{integer_and_whitespace}{2}{integer_and_semicolon} {
										faces_value_present = true;
										if (faces_ended)
											return -1;
									}

<CHECK_FACES>
{whitespace}*{integer_and_whitespace}{3} {
										faces_value_present = true;
										faces_ended = true;
									}


<CHECK_FACES>
{whitespace}*"}"{whitespace}*	{
					if (!faces_value_present)
						return -1;
					insertObject(&simple_objects_names, current_object);
					inside_object--;
					if (inside_object == 0) {
						insertComposedObject(&array_composed_objects, current_object, inside_object + 1);
					}
					BEGIN(INITIAL);
				}

<CHECK_FACES>
.|\n 								{
										return -1;
									}

<INSIDE_OBJECT>
{object_name}  						{
										inside_object++;
										free(current_object);
										current_object = malloc(yyleng * sizeof(char));
										strcpy(current_object, yytext);
										insertComposedObject(&array_composed_objects, current_object, inside_object);
										vertex_values_present = false;
										faces_value_present = false;
										colors_values_present = false;
										BEGIN(START_PARANTHESIS);
									}

<INSIDE_OBJECT>
.|\n 								{
										return -1;
									}

%%

// reading files
char **FileList;
unsigned int CurrentFile = 0;
unsigned int NoFiles;

int main(int argc, char **argv)
{
	current_object = malloc(20);
	
	initComposedObjects(&array_composed_objects, 2);
	initObjects(&simple_objects_names, 2);
	initObjects(&composed_objects_names, 2);
	
	FILE *file;
	FileList = argv + 1;
	NoFiles = argc - 1;
	

	if (argc > 1){
		CurrentFile = 0;
		file = fopen(FileList[CurrentFile], "r");
		if (!file){
			printf("!!!error!!!\n");
			exit(1);
		}
		yyin = file;
	
		//call flex
		int ret = yylex();
		
		//error
		if (ret == -1 || inside_object != -1){
			printf("Wrong input!\n");
		}

		else {
		
			//correct input	
			if (simple_objects == 0){
			}
			else if (simple_objects == 1){
				printf("1 obiect simplu: %s\n", simple_objects_names.names[0]);
			} else {
				printf("%d obiecte simple: ", simple_objects);
				for (i = 0; i < simple_objects; i++){
					printf("%s ", simple_objects_names.names[i]);
				}
				printf("\n");
			}
			for (i = 0; i < simple_objects; i++)
				free(simple_objects_names.names[i]);
			
			if (composed_objects == 0){
			}
			else if (composed_objects == 1){
				printf("1 obiect compus: %s\n", composed_objects_names.names[0]);
			} else {
				printf("%d obiecte compuse: ", composed_objects);
				for (i = 0; i < composed_objects; i++){
					printf("%s ", composed_objects_names.names[i]);
				}
				printf("\n");
			}
			for (i = 0; i < composed_objects; i++)
				free(composed_objects_names.names[i]);
			
			for (i = 0; i < array_composed_objects.used - 1; i++){
				int start_depth = array_composed_objects.array_composed_object[i].depth;
				array_composed_objects.array_composed_object[i].depth--;
				if (start_depth >= 0){
					if (array_composed_objects.array_composed_object[i + 1].depth > start_depth){
						printf("\n");
						for (t = 0; t < start_depth; t++){
							printf("  ");
						}
						printf("Object %s\n", array_composed_objects.array_composed_object[i].name);
					}
					for (j = i + 1; j < array_composed_objects.used; j++){
						if (array_composed_objects.array_composed_object[j].depth > start_depth ){
							for (t = 0; t < array_composed_objects.array_composed_object[j].depth; t++){
								printf("  ");
							}
							printf("Object %s\n", array_composed_objects.array_composed_object[j].name);
							array_composed_objects.array_composed_object[j].depth--;
						} else {
							break;
						}
					}
				}
			}
		}
	}
	return 0;
}

int yywrap(){
	FILE *file = NULL;
	
	fclose(yyin);
	
	CurrentFile++;
	
	if (CurrentFile > NoFiles)
		return 1;
	
	file = fopen(FileList[CurrentFile], "r");

	yyin = file;
	
	return(file ? 0:1);
}

