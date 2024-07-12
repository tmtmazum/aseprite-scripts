# aseprite-scripts
Collection of aseprite scripts to simplify some common workflows.

## Outline Layers
Creates a combined outline over all layers. Logically it does the following:
- copy all layers to a new sprite
- flatten all layers into one
- create an outline of the flattened layer
- copy back to original

Useful for quickly adding outlines to multi-layered sprites. Where normally the outline command would apply to the image of a single layer, this script allows applying it to the combined silhouette.

BEFORE:
![image](https://github.com/user-attachments/assets/c97b32ed-1996-41ec-ab95-110d27f87fd7)

AFTER:
![image](https://github.com/user-attachments/assets/c2fb5fa7-f909-4700-a804-a422ead9e242)
