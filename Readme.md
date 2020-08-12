# 3D Objects with Flex

The 3D objects are characterized by vertexes, colors (optional), faces and contain other objects (optional).

The program reads 1 or multiple files and outputs the number of simple and composed (nested) 3D objects it has, along with their names. If there are nested objects, it will also output their structures in an arborescent way. Example of output:

        3 obiecte simple: o4 o3 o5
        2 obiecte compuse: o1 o2

        Object o1
          Object o2
            Object o4
          Object o3

        Object o2
          Object o4

If the given files don't follow the above rules, the output will be an error message.

The run command is ./3d_objects [files]

The repo includes 5 input examples.
