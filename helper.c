// VAIS Adela

#include <stdio.h>
#include <stdlib.h>
#include "helper.h"

void initComposedObjects(ArrayComposedObject* a, int initialSize){
    a->array_composed_object = (Composed_object *)malloc(initialSize * sizeof(Composed_object));
    a->used = 0;
    a->size = initialSize;
}

void initObjects(ArrayObject* a, int initialSize){
    a->names = (char**)malloc(initialSize * sizeof(char*));
    a->used = 0;
    a->size = initialSize;
}

void insertComposedObject(ArrayComposedObject* a, char* name, int depth){
    if (a->used == a->size){
        a->size *= 2;
        a->array_composed_object = (Composed_object*)realloc(a->array_composed_object, a->size * sizeof(Composed_object));
    }
    a->array_composed_object[a->used].name = malloc(sizeof(name) * sizeof(char));
    strcpy(a->array_composed_object[a->used].name, name);
    a->array_composed_object[a->used].depth = depth;
    a->used++;
}

void insertObject(ArrayObject* a, char* name){
    if (a->used == a->size){
        a->size *= 2;
        a->names = (char**)realloc(a->names, a->size * sizeof(char*));
    }
    a->names[a->used] = malloc(sizeof(name) * sizeof(char));
    strcpy(a->names[a->used], name);
    a->used++;
}
