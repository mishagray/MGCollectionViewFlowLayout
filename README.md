

MGCollectionViewFlowLayout
==========================

1) Will take a list of UIViewControllerCells and display them in a 5xN sized grid in a mix of 1x1, 2x2, and 3x3 square cells.

2) Will randomly select different layouts each time a layout is created.

3) Will display items in "priority size" order.
        The first few items in each section will use 3x3 (from top to bottom, left to right),
        the next few items in the section will use 2x2, (top to bottom, left to right) and
        the last section use 1x1. (top to bottom, left to right)
    It should always display a mix of all 3 sizes.

4) Should effectively and quickly compute layouts of almost ANY size (by seamlessly appending smaller ramdom layouts together).

5) May need to ignore the last item in the section, in order to make items "fit" without any gaps in the section.

6) Can Supports animated rotatation.


TO COMPILE EXAMPLE
==========================
Requires cocopods.  
Run pod setup to create workspace.

Uses SDWebImage and AFNetworking to add support for Async photo loading (and animated GIF support).



POSSIBLE improvements (If I have time):
==========================

- Support caching layout combinations onto disk for faster loading, and supporting wider set of combinations, instead of just a single combination for list size.

- Support larger layout combinations,

- add 4x4 support (for iPad?).  Requires a slightly more complicated DepthFirstSearch algorithm.

- make a real cocopod.

