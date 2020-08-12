// VAIS Adela

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>

typedef struct{
    int depth;
    char* name;
} Composed_object;

typedef struct{
    int size;
    int used;
    Composed_object* array_composed_object;
} ArrayComposedObject;

typedef struct{
    int size;
    int used;
    char** names;
} ArrayObject;

ArrayComposedObject array_composed_objects;
ArrayObject simple_objects_names;
ArrayObject composed_objects_names;

void initComposedObjects(ArrayComposedObject* a, int initialSize);
void initObjects(ArrayObject* a, int initialSize);
void insertComposedObject(ArrayComposedObject* a, char* name, int depth);
void insertObject(ArrayObject* a, char* name);