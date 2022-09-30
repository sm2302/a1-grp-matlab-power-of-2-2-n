# Contents
1. [Animations (Solution Output)](#animations-solution-output)
2. [Relevant Files' Descriptions](#relevant-files-descriptions)
3. [Procedure in running each Cellular Automaton](#procedure-in-running-each-cellular-automaton)
   1. [Initialization or Loading of a Start State](#initialization-or-loading-of-a-start-state)
   2. [Within the Loop](#within-the-loop)
      1. [The Plot Function `plotGrid`](#the-plot-function-plotgrid)
         1. [Plot Marker Configurations](#plot-marker-configurations)
         2. [Aspect Ratios](#aspect-ratios)
         3. [Title Setting](#title-setting)
      2. [The Step Function](#the-step-function)
         1. [Usage of `ncAlive = nnz(A)` and `spalloc`](#usage-of-ncalive--nnza-and-spalloc)
         2. [Coordinates System](#coordinates-system)
            1. [Hexagonal Grid](#hexagonal-grid)
            2. [Triangular Grid](#triangular-grid)
         3. [Usage of Matrix Operations](#usage-of-matrix-operations)
            1. [Binary & Boolean Operations](#binary--boolean-operations)
            2. [Usage of `conv2`](#usage-of-conv2)
            3. [Usage of `getLattice`](#usage-of-getlattice)
         4. [Neighbourhood Computation](#neighbourhood-computation)
         5. [Next Cell State Computation](#next-cell-state-computation)
   3. [Maintaining Data for Re-Displaying All Final States](#maintaining-data-for-re-displaying-all-final-states)

## Animations (Solution Output)
<sup>[Back to list of contents](#contents)</sup>

## Relevant Files' Descriptions
<sup>[Back to list of contents](#contents)</sup>
| File | Description |
| ----- | ----------- |
| solutions.m | The main script where all functions are pieced together to demonstrate their collective result |
| plotGrid.m | The function which handles all plot/figure related procedures, e.g. setting the figure title, aspect ratio, displaying each cell according to its type (e.g. downward pointing or upward pointing triangle), etc |
| **stepFunction** <br /> (folder) | Folder containing all step functions that generally take in a current state `A0` as argument and computes and returns the next state `A1` |
| stepLife.m | The most basic and most concise step function. Refer to this file first in understanding the procedures common in all step functions. |
| stepSquare.m | Almost exactly similar to stepLife, except that it expects 2 additional input arguments, the birth condition and survival condition (vector of numbers of neighbours to cause birth or survival) |
| stepTriangle.m | Like stepLife.m, it has fixed rules (for simplicity), but has two different methods of computing neighbourhood depending on the cell's location in the grid (upward pointing or downward pointing triangle) |
| stepHex.m | Similar to stepLife.m with the exception of its own fixed set of rules (for simplicity) and neighbourhood computation due to its grid shape and coordinates system (refer down below) |
| stepHex3.m | Modification to stepHex.m. Different than the other step functions in that it computes for a world where cells have three different states e.g. dead, blue (alive) and red (alive) instead of 2 (dead and alive). This allows for a more LIFE-like activity pattern, as shown in [animation below](#Square-Grid-Cellular-Automata-with-Different-Rules)|
| getLattice.m | Generates one of two types of checkerboard pattern, i.e., either starting with 1, or starting with 0, of size determined by the `height` and `width` values passed as numeric arguments (along with the single character argument, the lattice `type`) |
| im2gif.m | Accepts as input arguments (1) a cell array of `im`s and (2) a string of the intended filename, to create a .gif image file (such as the ones used in the animations further below)|
| fig2png.m | Accepts as its arguments (1) a figure handle and (2) a string of the intended filename, to create a .png image (not animated) of everything currently on the figure |

## Procedure in running each Cellular Automaton
<sup>[Back to list of contents](#contents)</sup>

### Initialization or Loading of a Start State
<sup>[Back to list of contents](#contents)</sup>

### Within the Loop
<sup>[Back to list of contents](#contents)</sup>

#### The Plot Function `plotGrid`
<sup>[Back to list of contents](#contents)</sup>

##### Plot Marker Configurations
<sup>[Back to list of contents](#contents)</sup>

##### Aspect Ratios
<sup>[Back to list of contents](#contents)</sup>

##### Title Setting
<sup>[Back to list of contents](#contents)</sup>

#### The Step Function
<sup>[Back to list of contents](#contents)</sup>

##### Usage of `ncAlive = nnz(A)` and `spalloc`
<sup>[Back to list of contents](#contents)</sup>

##### Coordinates System
<sup>[Back to list of contents](#contents)</sup>

###### Hexagonal Grid
<sup>[Back to list of contents](#contents)</sup>

###### Triangular Grid
<sup>[Back to list of contents](#contents)</sup>

##### Usage of Matrix Operations
<sup>[Back to list of contents](#contents)</sup>

###### Binary & Boolean Operations
<sup>[Back to list of contents](#contents)</sup>

###### Usage of `conv2`
<sup>[Back to list of contents](#contents)</sup>

###### Usage of `getLattice`
<sup>[Back to list of contents](#contents)</sup>

##### Neighbourhood Computation
<sup>[Back to list of contents](#contents)</sup>

##### Next Cell State Computation
<sup>[Back to list of contents](#contents)</sup>

### Maintaining Data for Re-Displaying All Final States
<sup>[Back to list of contents](#contents)</sup>
