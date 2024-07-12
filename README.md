# aseprite-scripts
Collection of aseprite scripts to simplify some common workflows.

Disclaimer: some of these scripts were generated with the help of Chat-GPT, those tested and refined by me. Use at your own discretion.

## Outline Layers
Creates a combined outline over all layers. Logically it does the following:
- copy all layers to a new sprite
- flatten all layers into one
- create an outline of the flattened layer
- copy back to original

I've found this really useful for quickly adding outlines to multi-layered scripts.
