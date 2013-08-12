

MGCollectionViewFlowLayout
==========================

1) Will take a list of UIViewControllerCells and display them in a 5xN sized grid in a mix of 1x1, 2x2, and 3x3 square cells.

2) Will randomly select different layouts each time a layout is created.

3) Will display items in "priority size" order.  The first items in data set
        The first few items in each section will use 3x3 (from top to bottom, left to right),
        the next few items in the section will use 2x2, (top to bottom, left to right) and
        the last section use 1x1. (top to bottom, left to right)
    It should always display a mix of all 3.

4) Should effectively and quickly compute layouts of almost ANY size (by seamlessly appending smaller ramdom layouts together).

5) May need to ignore the last item in the section, in order to make items "fit" without any gaps in the section.

6) Can Supports animated rotatation.


--- TODOS:

- Support caching layout combinations onto disk for faster loading, and supporting wider set of combinations.

- Support precomputing val