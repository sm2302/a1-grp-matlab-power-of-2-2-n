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
         1. [Usage of `ncAlive = nnz(A0)` and `spalloc`](#usage-of-ncalive--nnza0-and-spalloc)
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

<table align=center>
  <tr><th align=center colspan=2>
    Cellular Automata in Different Grids
  <th></tr>
  <tr>
    <td><img src="animations/Game of LIFE.gif"></td>
    <td><img src="animations/Tri-Grid.gif"></td>
  </tr>
    <td><a href=#neighbourhood-computation>Neighbours</a> = 8</td>
    <td><a href=#neighbourhood-computation>Neighbours</a> = 12</td>
  <tr>
  </tr>
  <tr>
    <td>
      Frequently occuring activity patterns include <i>still-life</i>s (a group of neighbouring cells that do not evolve from one generation to the next), <i>oscillators</i> (group of cells that evolve but return to the same pattern after a certain number of generations (know as its period), and <i>spaceships</i> (same as oscillators, but which end up on a different location after each period)
    </td>
    <td>
      It is also possible to have the LIFE-like patterns occur in the triangular grid, with the rules Birth=<code>4,8</code> and Survival=<code>4,5,6</code>, albeit being rarer than in the Game of LIFE. Above shows the occurance of spaceships from a randomly generated initial state (but now saved in <a href=#relevant-files-descriptions>savedStates.mat</a>
    </td
  </tr>
  <tr>
    <td><img src="animations/Hex-Grid.gif"></td>
    <td><img src="animations/Hex-Grid with 3 states.gif"></td>
  </tr>
  </tr>
    <td><a href=#neighbourhood-computation>Neighbours</a> = 6</td>
    <td><a href=#neighbourhood-computation>Neighbours</a> = 6</a></td>
  <tr>
  <tr>
    <td>
      We have not been able to find any combination of rules that can fascilitate the occurance of activity patterns that closely resembles the Game of LIFE. However using the rules Birth=<code>3,4</code> and Survival=<code>2,3,4</code> leads to a nice result of hexagon structures consuming nearby neighbours. These hexagons' outline become stable when there are no more neighbours. Initially their interior are chaotic but these too slowly stabilize to mostly hexagonal lattices (and small amounts of still or oscillating spots) at some point (as can be seen happening to the small hexagon at the <b>top center / 12 o'clock</b> in the animation above). The larger the hexagon, the more time it takes (sometimes 1000+ generations) to for its interior to stabilize fully.
    </td>
    <td>
      We were, however, able to cause more LIFE-like activity patterns to occur by breaking a rule. That is, in using three states (dead, blue <sub>(yellow in Joe's post)</sub>, and red) instead of two (dead and alive), and a certain combination of state-change rules (Birth=<code>4</code>, Survival<sub><sub>b->r</sub></sub>=<code>1,2,3,4,5</code>, Survival<sub><sub>r->r</sub></sub>=<code>1,2</code> and Survival<sub><sub>r->b</sub></sub>=<code>4</code>), as mentioned in <a href="https://www.quora.com/Are-there-variations-of-Conways-Game-of-Life-based-upon-a-triangular-or-hexagonal-grid">Joe Wezorek's post</a>
    </td>
  </tr>
</table>

<table align=center>
  <tr><th align=center colspan=2>
    Square Grid Cellular Automata with Different Rules
  <th></tr>
  <tr>
    <td><img src="animations/REPLICATOR.gif"></td>
    <td><img src="animations/SEEDS.gif"></td>
  </tr>
  <tr>
    <td>Birth=<code>1,3,5,7</code> Survival=<code>1,3,5,7</code></td>
    <td>Birth=<code>2</code> Survival=<code>NEVER</code></td>
  </tr>
  <tr>
    <td align=center>
      Replicator rules, especially it requiring as few as 1 neighbour for cell births, mean that
      it is fine to start with just one living cell in the world as done in this example.
      Cells quickly replicate in a pattern extending outwards. Massive death occurs when two extending structures collide.
    </td>
    <td align=center>
      In Seeds, all cells die instantly in the generation after their birth. However because having 2 neighbours (condition for birth) is quite common, expansion occurs quickly. And once the world is dense enough the activity patterns become chaotic.
    </td>
  </tr>
  <tr>
    <td><img src="animations/LIFE WITHOUT DEATH.gif"></td>
    <td><img src="animations/DIAMOEBA.gif"></td>
  </tr>
   <tr>
    <td>Birth=<code>3</code> Survival=<code>ANY</code></td>
    <td>Birth=<code>3,5,6,7,8</code> Survival=<code>5,6,7,8</code></td>
  </tr>
  <tr>
    <td align=center>
      The "neighbourhood" of cells keep expanding without any reversal as the cells never die.
      However since having 3 neighbours (the birth condition) isn't that common, the expansion occurs quite slowly
      in contrast to Replicator. The animation is sped up 2x for better demonstration of the expansion.
    </td>
    <td align=center>
      The cells in Diamoeba stabilize to form (usually diamond shaped) structures resembling amoebas.
    </td>
  </tr>
</table>

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
| stepHex3.m | Modification to stepHex.m. Different than the other step functions in that it computes for a world where cells have three different states e.g. dead, blue (alive) and red (alive) instead of 2 (dead and alive). This allows for a more LIFE-like activity pattern, as shown in the [animation above](#animations-solution-output)|
| getLattice.m | Generates one of two types of checkerboard pattern, i.e., either starting with 1, or starting with 0, of size determined by the `height` and `width` values passed as numeric arguments (along with the single character argument, the lattice `type`) |
| im2gif.m | Accepts as input arguments (1) a cell array of `im`s and (2) a string of the intended filename, to create a .gif image file (such as the ones used in the animations further below)|
| fig2png.m | Accepts as its arguments (1) a figure handle and (2) a string of the intended filename, to create a .png image (not animated) of everything currently on the figure |

## Procedure in running each Cellular Automaton
<sup>[Back to list of contents](#contents)</sup>

In our main [`solutions.m`](solutions.m) script consists of 8 Cellular Automata runs, all done with the same procedure, as such:

```MATLAB
% Example: The Game of LIFE; Other Cellular Automata runs too follow the same format.
label = "Game of LIFE";
grid = "square";
stepFn = @stepLife; N = 100;
A = sprand(200, 200,0.075) > 0;

for i = 1:N
  plotGrid(A, grid, label, markerScale);
  A = stepFn(A);
endfor

data(1,1:3) = {A, grid, label};
```

...which is:
- Specifying variables to be used subsequent function calls:
   - `label` - name to display on figure
   - `grid` - shape of grid which determines how the cells will be plotted
   - `stepFn` - which out of the five [step functions](#the-step-function) to use for next cell state computation
   - `A` - 2X2 sparse matrix representing cells' states at the start of the loop, which is also updated in each iteration
   - `N` - number of generations to run consecutively i.e., how many times the for-loop will run
   - `markerScale` - how big or small to make the plot marker
- Running a `for-loop` for `N` iterations, in which each generation will be [plotted](#the-plot-function-plotgrid), and `A` be updated to the [next state computed](#the-step-function)
- Its latest state `A`, along with values for `grid` and `label` will be saved to a cell array (`data` to be used at the end of the script in a combined subplot figure)[#maintaining-data-for-re-displaying-all-final-states].


### Initialization or Loading of a Start State
<sup>[Back to list of contents](#contents)</sup>


Before running a Cellular Automata "simulation", its must start with an existing state, in the form of a sparse matrix. For most of our examples in the [`solutions.m`](solutions.m) script, we have used the `sprand` function as such:

```MATLAB
A = sprand(height, width, density)
```

where `A` is the start state to be assigned a value, and `sprand` used in this manner produces a sparse matrix of random numbers (0 to 1) at a certain amount of random positions determined by the density number.

`Count of filled positions = Total positions * density`. E.g. `sparse(2, 5, 0.3)` may produce a matrix of these values:

```
0.1   0.4     0     0     0
  0     0     0   0.3     0
```

... though it will be in the form of a sparse matrix, meaning each non-zero element's row and column coordinates are kept in memory and the `0`s are ignored.

Alternatively, any saved state can be used too as the initial state, such as:

```MATLAB
% Example:  CELLULAR AUTOMATA - FROM SAVED STATES
label = "Gosper & Simkin Glider Guns in Game of LIFE";
grid = "square";
stepFn = @stepLife;

load savedStates guns;
A = guns; N = 240;

for i = 1:N
  plotGrid(A, grid, label, markerScale/1.3);
  A = stepFn(A);
endfor
```

<div align=center>
   <img width=500 src="animations/Gosper & Simkin Glider Guns.gif">
</div>

### Within the Loop
<sup>[Back to list of contents](#contents)</sup>

```MATLAB
for i = 1:N
  plotGrid(A, grid, label, markerScale);
  A = stepFn(A);
endfor
```

In each iteration up to N times, calls are made to
1. [`plotGrid`](#the-plot-function-plotgrid), which handles plotting related procedures, and
2. [`stepFn`](#the-step-function) which is a handle to one of the five step functions, which takes in the current state `A` and assigns to itself (`A`) the new computed state.

#### The Plot Function `plotGrid`
<sup>[Back to list of contents](#contents)</sup>

`plotGrid` is a general function in that it is used for all different grid types (square, triangular and hexagonal). It accepts 4 input arguments

| Argument | Type | Description |
| -------- | ---- | ----------- |
| A        | Sparse matrix | A Matrix whose elements represents the state of the cells which is to be plotted |
| shape    | String | The shape of the grid: `square`, `triangle`, `hexagon` or `hexagon3`. This will determine which plot markers to use and the aspect ratio of the plot |
| label    | String | The name to display on top of the plot |
| markerScale | Double | Number which determines how small or big the plot marker is drawn relative to the number that seems to be just right. Default value and normal scale is 1. |
| titleScale| Double | Number which determines how small or big the title text is compared to the default value we set (44). Default value for the scale is 1. |

##### Plot Marker Configurations
<sup>[Back to list of contents](#contents)</sup>

It is best to make the plot markers distanced as closely to each other as possible without overlap. This is done by making it inversely proportional to the height of the matrix, i.e. have it be multiplied by `1/size(A,1)`.

```MATLAB
  spy(A, '*k', baseMarkerSize/size(A,1)*markerScale);
```

##### Aspect Ratios
<sup>[Back to list of contents](#contents)</sup>

To keep the figures plotted in proportion (one horizontal unit = one vertical unit) and not automatically stretch according to the current figure window dimensions, the `daspect` function is used

| Grid | Statement |
| ---- | --------- |
| square | `daspect([1 1])` |
| triangular | `daspect([1.3 1])` |
| hexagonal | `daspect([1.75 1])` |

The higher the Y:X ratio the more tightly packed the elements are horizontally compared to vertically.

Having this done in the triangular and hexagonal grid is necessary due to the [coordinates system](#coordinates-system) implemented in these grids.

##### Title Setting
<sup>[Back to list of contents](#contents)</sup>

$TeX$ notation `\fontsize{effected text}` is used for increasing the font size, as normally it is too small. Additionally, the optional argument `titleScale` can be set to other than `1` to enlarge or shink the font.

```MATLAB
title(['\fontsize{', sprintf("%d",44*titleScale), '}', label]);
```

The $TeX$ notation, the evaluated font size and the input argument `label` are concatenated with square brackets similar to how we would a row vector of numbers

#### The Step Function
<sup>[Back to list of contents](#contents)</sup>

The step function for the Game of Life

```MATLAB
function A1 = stepLife(A0)

  ncAlive = nnz(A0);

  [h, w] = size(A0);
  N = spalloc(h, w, ncAlive*4);
  A1 = spalloc(h, w, ncAlive);

  N += conv2(A0, [1 1 1;
                  1 0 1;
                  1 1 1], 'same');

  A1 += (~A0.*N == 3);

  A1 += (A0.*N == 2) + (A0.*N == 3);

endfunction
```

##### Usage of `ncAlive = nnz(A0)` and `spalloc`
<sup>[Back to list of contents](#contents)</sup>

> This section has mentions on cells' neighbours and neighbourhood but does not explain them. For the explanation, see [section on neighbourhood computation](#neighbourhood-computation)

`ncAlive = nnz(A0)` just assigns to `ncAlive` the count of non-zero elements in the sparse matrix A i.e. the number of alive cells in the current state

This count is useful in making operations on the sparse matrix more efficient.

How so?

A sparse matrix only takes as much storage as the amount of nonzero elements it contains (along with these elements' coordinates, or position values). Similarly the amount of time an operation on it takes is also proportional to the amount of nonzero elements it has.

In other words, operations on sparse matrices become more efficient the lower the number of non-zero values.

Additionally, the precise the amount of memory allocated for the amount of nonzero values a sparse array would have, the more efficient adding nonzero values to the already allocated memory would be.

`spalloc(h, w, nnz)` initializes an empty sparse matrix of size `h` by `w` with a soft capacity to hold `nnz` amount of nonzero values

```MATLAB
N = spalloc(h, w, ncAlive*3);
A1 = spalloc(h, w, ncAlive);
```

N in any step function is the sparse matrix whose elements are the number of alive neighbours of the corresponding cells in A0.

A1 is the sparse matrix that would hold `1`s where there are alive cells in the next state

For the variable N, the final number of nonzeros would be the total number of indices in the matrix which are neighbours of any currently living cell.

For the estimate for how many room to allocate, we just picked an arbitrary but reasonable (e.g. `3`) number that is less than the maximum number of neighbours for each cell to multiply with the amount of living cells `ncAlive`. The reason being that N should be proportional to the amount of living cells yet we acknowledge neighbouring positions of alive cells do overlap, hence not using too high of a multiplier for `ncAlive`.

For the variable A1, we just picked exactly ncAlive to be the estimate as general world state does tend to stabilize in most Cellular Automata that we included in the solutions.m file.

##### Coordinates System
<sup>[Back to list of contents](#contents)</sup>

A simple coordinate system

```
Row\Col 1 2 3 4 5 6
      1 □ □ □ □ □ □
      2 □ □ □ □ □ □
      3 □ □ □ □ □ □
      4 □ □ □ □ □ □
      5 □ □ □ □ □ □
      6 □ □ □ □ □ □
```

... which is possible for a square grid. However for the triangular and hexagonal grid, it isn't as straightforward

###### Hexagonal Grid
<sup>[Back to list of contents](#contents)</sup>

For the hexagonal grid, we used the _Doubled Coordinates_ system as described by [Red Blob Games](https://www.redblobgames.com/grids/hexagons/#coordinates) which looks like

```
Row\Col 1 2 3 4 5 6
      1 ⬡   ⬡   ⬡
      2   ⬡   ⬡   ⬡
      3 ⬡   ⬡   ⬡
      4   ⬡   ⬡   ⬡
      5 ⬡   ⬡   ⬡
      6   ⬡   ⬡   ⬡
```

... where in each row, every two positions are not used in the above manner, meaning one cell would horizontally be distanced two units apart, systematically i.e. only in their indices. However when plotting, the gaps have to be hidden, hence the high Y:X (aspect ratio)[#aspect-ratios] which scales down visual horizontal distances between cells relative to their vertical distances

###### Triangular Grid
<sup>[Back to list of contents](#contents)</sup>

After knowing the solution to implementing a hex grid, it was not difficult to come up with our own similar solution in implementing the triangular grid, i.e.

```
Row\Col 1 2 3 4 5 6
      1 ▼ ▲ ▼ ▲ ▼ ▲
      2 ▲ ▼ ▲ ▼ ▲ ▼
      3 ▼ ▲ ▼ ▲ ▼ ▲
      4 ▲ ▼ ▲ ▼ ▲ ▼
      5 ▼ ▲ ▼ ▲ ▼ ▲
      6 ▲ ▼ ▲ ▼ ▲ ▼
```

... where vertically as well as horizontally, the cells would alternate pointing directions (downwards vs. upwards pointing). Similar to in the hex grid, horizontally, the spacing between elements need to be squished, hence the slightly high Y:X (aspect ratio)[#aspect-ratios] (though not as high as for the hex grid)

##### Usage of Matrix Operations
<sup>[Back to list of contents](#contents)</sup>

Snippet from the step function for Game of Life

```MATLAB
% N's elements are the number of alive neighbours the cell in the same position in A0 has
N += conv2(A0, [1 1 1;
                1 0 1;
                1 1 1], 'same');

% Apply the birth rule
A1 += (~A0.*N == 3);

% Apply the survival rule
A1 += (A0.*N == 2) + (A0.*N == 3);
```

###### Binary & Boolean Operations
<sup>[Back to list of contents](#contents)</sup>

Let us assume we have the following matrices

```
 Current state     Number of alive neighbours of each cell in A
A0 = 0 0 0 0 0 0   N = 0 1 1 1 0 0
     0 0 1 0 0 0       0 1 1 2 1 0
     0 0 0 1 0 0       0 2 3 2 1 0
     0 0 1 0 0 0       0 1 1 2 1 0
     0 0 0 0 0 0       0 1 1 1 0 0
     0 0 0 0 0 0       0 0 0 0 0 0
```

When the statement `A1 += (~A0.*N == 3);` is run, these occur:
1. A0 is negated i.e. `~A0`
2. The negation of A0 is multiplied by N i.e. `~A0*N`
3. The resulting product is operated with the boolean operator == with 3 i.e. `~A0*N == 3`
4. The result of the boolean operation is added to A1 i.e. `A1 += (~A0*N == 3)`

How it looks like. (Not really as the matrices should be sparse and hence 0s do not really exist in memory)

```
                      Negation of A0
A0 = 0 0 0 0 0 0      ~A0 = 1 1 1 1 1 1
     0 0 1 0 0 0            1 1 0 1 1 1
     0 0 0 1 0 0            1 1 1 0 1 1
     0 0 1 0 0 0            1 1 0 1 1 1
     0 0 0 0 0 0            1 1 1 1 1 1
     0 0 0 0 0 0            1 1 1 1 1 1

                   Elem-multiplication    1 where "~A0.*N==3" are true
 N = 0 1 1 1 0 0   ~A0.*N = 0 1 1 1 0 0   ~A0*N==3 = 0 0 0 0 0 0
     0 1 1 2 1 0            0 1 0 2 1 0              0 0 0 0 0 0
     0 2 3 2 1 0            0 2 3 0 1 0              0 0 1 0 0 0
     0 1 1 2 1 0            0 1 0 2 1 0              0 0 0 0 0 0
     0 1 1 1 0 0            0 1 1 1 0 0              0 0 0 0 0 0
     0 0 0 0 0 0            0 0 0 0 0 0              0 0 0 0 0 0

```

A1 += (~A0.*N == 3) then results in 1 being added to position (3,3) in the matrix A1, which is akin to running the following code

```MATLAB
for r in 1:6
  for c in 1:6
    if ~A0
      if N==3
        A1 = 1;
      end;
    end;
  end;
end;
```

which is not only a lot to read visually, but also computationally inefficient as the operation is done for rows*cols times, whereas in sparse matrix operations, some low level operations involving 0s are not even considered.

Thus the code 
  
```MATLAB
% Apply birth and survival rule
for r in 1:6
  for c in 1:6
    if ~A0(r,c)
      if N==3
        % Birth condition met
        A1(r,c) = 1; % Set A1 in this position to 1
      end;
    elseif N==2 || N==3
      % Survival condition met
      A1(r,c) = 1; % Set A1 in this position to 1
    end;
  end;
end;
```

can be better written (and more efficiently executed) as

```MATLAB
% Add one to A1 where currently dead cells have 3 neighbours (birth condition met)
A1 += (~A0.*N == 3);

% Add one to A1 where currently alive cells have 2 or 3 neighbours (survival condition met)
A1 += (A0.*N == 2) + (A0.*N == 3);
```

###### Usage of `conv2`
<sup>[Back to list of contents](#contents)</sup>

Snippet from `stepLife.m`/`stepSquare.m`

```MATLAB
N += conv2(A0, [1 1 1;
                1 0 1;
                1 1 1], 'same');
```

> A convolution is a type of matrix operation, consisting of a kernel (which is a small matrix of weights), that slides over input data performing element-wise multiplication with the part of the input it is on, then summing the results into an output. (Source: [Papers with Code](https://paperswithcode.com/method/convolution)

> `conv2(A,B)` returns the two-dimensional convolution of matrices A and B. (Source: [MATLAB docs on conv2](https://www.mathworks.com/help/matlab/ref/conv2.html#bvgtfv6))

So with the example state:

```
A0 = 0 0 0 1 1
     0 0 0 0 1
     0 0 0 0 1
     0 1 0 0 0
     0 0 0 0 0
```

,

```MATLAB
conv2(A0, [1 1 1;
           1 0 1;
           1 1 1]);
```

would be evaluated as summation of all these

```
0 0 0 1 1 0 0   0 0 0 0 1 1 0   0 0 0 0 0 1 1
0 0 0 0 1 0 0   0 0 0 0 0 1 0   0 0 0 0 0 0 1
0 0 0 0 1 0 0   0 0 0 0 0 1 0   0 0 0 0 0 0 1
0 1 0 0 0 0 0   0 0 1 0 0 0 0   0 0 0 1 0 0 0
0 0 0 0 0 0 0   0 0 0 0 0 0 0   0 0 0 0 0 0 0
0 0 0 0 0 0 0   0 0 0 0 0 0 0   0 0 0 0 0 0 0
0 0 0 0 0 0 0   0 0 0 0 0 0 0   0 0 0 0 0 0 0

0 0 0 0 0 0 0   0 0 0 0 0 0 0   0 0 0 0 0 0 0
0 0 0 1 1 0 0   0 0 0 0 0 0 0   0 0 0 0 0 1 1
0 0 0 0 1 0 0   0 0 0 0 0 0 0   0 0 0 0 0 0 1
0 0 0 0 1 0 0   0 0 0 0 0 0 0   0 0 0 0 0 0 1
0 1 0 0 0 0 0   0 0 0 0 0 0 0   0 0 0 1 0 0 0
0 0 0 0 0 0 0   0 0 0 0 0 0 0   0 0 0 0 0 0 0
0 0 0 0 0 0 0   0 0 0 0 0 0 0   0 0 0 0 0 0 0

0 0 0 0 0 0 0   0 0 0 0 0 0 0   0 0 0 0 0 0 0
0 0 0 0 0 0 0   0 0 0 0 0 0 0   0 0 0 0 0 0 0
0 0 0 1 1 0 0   0 0 0 0 1 1 0   0 0 0 0 0 1 1
0 0 0 0 1 0 0   0 0 0 0 0 1 0   0 0 0 0 0 0 1
0 0 0 0 1 0 0   0 0 0 0 0 1 0   0 0 0 0 0 0 1
0 1 0 0 0 0 0   0 0 1 0 0 0 0   0 0 0 1 0 0 0
0 0 0 0 0 0 0   0 0 0 0 0 0 0   0 0 0 0 0 0 0
```

resulting in

```
0 0 0 1 2 2 1
0 0 0 1 2 2 2
0 0 0 1 4 3 3
0 1 1 1 2 1 2
0 1 0 1 1 1 1
0 1 1 1 0 0 0
0 0 0 0 0 0 0
```

> conv2(___,shape) returns a subsection of the convolution according to shape. For example, C = conv2(A,B,'same') returns the central part of the convolution, which is the same size as A (Source: [MATLAB docs on conv2](https://www.mathworks.com/help/matlab/ref/conv2.html#bvgtfv6))

Hence

```MATLAB
conv2(A0, [1 1 1;
           1 0 1;
           1 1 1], 'same');
```

returns

```
0 0 1 2 2
0 0 1 4 3
1 1 1 2 1
1 0 1 1 1
1 1 1 0 0
```

which is the actually N, the numbers of alive neighbours of the corresponding cell in

```
A0 = 0 0 0 1 1
     0 0 0 0 1
     0 0 0 0 1
     0 1 0 0 0
     0 0 0 0 0
```

###### Usage of `getLattice`
<sup>[Back to list of contents](#contents)</sup>

`getLattice` is just a function that generates a matrix of alternating `1`s and `0`s in the manner below:

```
Type A        Type B
1 0 1 0 1 0   0 1 0 1 0 1
0 1 0 1 0 1   1 0 1 0 1 0
1 0 1 0 1 0   0 1 0 1 0 1
0 1 0 1 0 1   1 0 1 0 1 0
1 0 1 0 1 0   0 1 0 1 0 1
0 1 0 1 0 1   1 0 1 0 1 0
```

with variable width and height.

It is used in filtering matrices in the case of hexagonal grid and triangle grid where a an ["alternating" system of coordinates](#hexagonal-grid) is used. For example, when an starting state is initialized via. `A = sprand(5, 7, 0.4) > 0`, the matrix below may be produced

```
1 0 0 1 0 0 0
0 1 0 1 0 0 0
0 0 1 1 0 0 0
0 0 0 1 1 0 0
0 0 0 1 0 1 0
```

However if it were a hexagonal grid, some of the 1s would be in positions that do not actually exist due to the [coordinates system](#hexagonal-grid).

```
Row\Col 1 2 3 4 5 6
      1 ⬡   ⬡   ⬡
      2   ⬡   ⬡   ⬡
      3 ⬡   ⬡   ⬡
      4   ⬡   ⬡   ⬡
      5 ⬡   ⬡   ⬡
      6   ⬡   ⬡   ⬡
```

The invalid cells would have to be eliminated, and this can be done by element-wise multiplying the state matrix A with a checkerboard pattern from `getLattice` of the same dimensions

```
       A         L=getLattice('A',h,w)       A.*L
 1 0 0 1 0 0 0       1 0 1 0 1 0 1       1 0 0 0 0 0 0
 0 1 0 1 0 0 0       0 1 0 1 0 1 0       0 1 0 1 0 0 0
 0 0 1 1 0 0 0       1 0 1 0 1 0 1       0 0 1 0 0 0 0
 0 0 0 1 1 0 0       0 1 0 1 0 1 0       0 0 0 1 0 0 0
 0 0 0 1 0 1 0       1 0 1 0 1 0 1       0 0 0 0 0 0 0

Valid cells in A = A.*L
 1   0   0   0
   1   1   0
 0   1   0   0
   0   1   0
 0   0   0   0
```

Similarly, in the triangular grid, both types of lattice 'A' and 'B' are used each to filter one of the two types of triangles ▼ and ▲


Snippet from `plotGrid.m`

```MATLAB
spy(A.*getLattice('A', h, w), 'vk', markerSize);
hold on;
spy(A.*getLattice('B', h, w), '^k', markerSize);
hold off;
```

would result in a state A e.g.

```
|0 0 1|
|0 0 1|
|0 1 0|
```

to be plotted by the first spy call as

```
|    ▼|
|     |
|     |
(not yet in [1.3 1] aspect ratio)
```

then on the second spy call be plotted as

```
|    ▼|
|    ▲|
|  ▲  |
(not yet in [1.3 1] aspect ratio)
```

##### Neighbourhood Computation
<sup>[Back to list of contents](#contents)</sup>

Neighbourhoods are computed with the [use of the `conv2` function](#usage-of-conv2).

In fact, the one location where it is used is the only difference in computation from one grid to another

___

Snippet from `stepLife.m`/`stepSquare.m`

```MATLAB
  N += conv2(A0, [1 1 1;
                  1 0 1;
                  1 1 1], 'same');
```

... which is straightforward A0 is directly used as argument to the conv2 along with the the 3x3 kernel that represents the eight positions adjacent to a cell in a square grid

___

In `stepTriangle.m`

```MATLAB
                                                    % ▲▼▲▼▲
  N += conv2(A0.*getLattice('A', h, w), [1 1 1 1 1; % ▼▲v▲▼
                                         1 1 0 1 1; %  ▼▲▼
                                         0 1 1 1 0], 'same');
                                                    %  ▲▼▲
  N += conv2(A0.*getLattice('B', h, w), [0 1 1 1 0; % ▲▼^▼▲
                                         1 1 0 1 1; % ▼▲▼▲▼
                                         1 1 1 1 1], 'same');
```

... two kernels are used, one for each type of triangle ▼ and ▲, whose neighbourhoods are computed in separate calls to conv2. Cell A0 is filtered by either types of checkered pattern generated by [`getLattice`](#usage-of-getlattice) so that only cells in downward pointing triangles are passed to the first conv2 call, while cells in upward pointing triangles are passed in the second call.

In the triangular grid, cells considered neighbours are the ones touching not only on their edges, but also on their vertices, resulting in a total of 12 neighbours per cell
___

`stepHex.m`

```MATLAB
  N += conv2(A0, [0 1 0 1 0;
                  1 0 0 0 1;
                  0 1 0 1 0], 'same');
```

... is similar to `stepLife.m`/`stepSquare.m` in that only one kernel is used. The staggered arrangement and horizontal distance is due to how the cells are arranged in the [coordinates system](#hexagonal-grid) used and which to be considered neighbours in a the grid
___

Snippet from `stepHex3.m`

```MATLAB
  N += conv2((A0==1), [0 1 0 1 0;
                       1 0 0 0 1; % Blue cell, state 1
                       0 1 0 1 0], 'same');

  N += conv2((A0==2), [0 2 0 2 0;
                       2 0 0 0 2; % Red cell, state 2
                       0 2 0 2 0], 'same');
```

.. is similar to `stepHex.m` with the exception that red cells increment 2 to their neighbouring cells' N value.

##### Next Cell State Computation
<sup>[Back to list of contents](#contents)</sup>

From the original question:
> At each step the cells are updated according to the following set of rules:
> 1. Any live cell with fewer than two live neighbours dies (underpopulation).
> 2. Any live cell with two or three live neighbours lives on to the next generation.
> 3. Any live cell with more than three live neighbours dies (overpopulation).
> 4. Any dead cell with exactly three live neighbours becomes a live cell (reproduction).

As the other Cellular Automata we have explored have the same format of rules but varying numbers (with the exception of `Hexagon3` in which cells have three possible states instead of two), these can be generalized into:
1. Any live cell that has $s \in sr$ amount of neighbours lives on to the next generation (survival)
2. Any dead cell that has $b \in br$ amount of neighbours becomes a live cell (reproduction)
3. Cells that do not meet any of the first two rules are assumed to be/stay dead.

where
- $sr$ is an array of numbers, which if a live cell's amount of live neighbours matches any of its elements, the cell would continue to live
- $br$ is an array of numbers, which if a dead cell's amount of live neighbours matches any of its elements, the cell would become a live cell on the next generation

`stepSquare.m`, which accepts the birth $br$ and survival $sr$ rules as argument

```MATLAB
  % Apply birth rule
  for n = br
    if n == 0
      A1 += (~A0.*~N);
      continue;
    endif
    A1 += (~A0.*N == n);
  endfor

  % Apply survival rule
  for n = sr
    if n == 0
      A1 += (A0.*~N);
      continue;
    endif
    A1 += (A0.*N == n);
  endfor
```

How these [binary & boolean operations](#binary--boolean-operations) work in emulating conditional logic and iterating through individual elements, but more efficiently, as explained in a [previous section](#binary--boolean-operations).

For loop are still required, however, to loop through the arrays $sr$ and $br$.

The reason for singling out the conditions where n == 0 is that `A1 += (A0.*N == n)` or `A1 += (~A0.*N == n)` would not work as intended when 0 is in $sr$ or $br$ because `(A0.*N == n)` would have a value 1 wherever there is a dead cell and `(~A0.*N == n) would return 1 wherever there is a live cell, regardless of the value of N.

The code below 

```MATLAB
  % Apply birth rule
  for n = br
    A1 += (~A0.*N == n);
  endfor

  % Apply survival rule
  for n = sr
    A1 += (A0.*N == n);
  endfor
```

would work for most of the Cellular Automata variants but not for those with 0 in either their $sr$ or $br$ arrays (such as in [Life without Death](#animations-solution-output) due to the reasons mentioned in the previous paragraph.

### Maintaining Data for Re-Displaying All Final States
<sup>[Back to list of contents](#contents)</sup>

```MATLAB
data(1,1:3) = {A, grid, label};
```

is written at every CA run after the for loops. This is to store in the data cell their:
1. Final state `A`
2. Grid shape `grid`
3. Figure title `label`

They are then referenced at the final code segment at the end of the `solutions.m` script

```MATLAB
% COMBINED SUBPLOTS OF FIRST 8 CA RUNS' FINAL STATES

% Display all in a single figure
fig2 = figure(2);

markerScale = 0.3; titleScale = 0.5;

for j = 1:8 % Limit to only 8 because on screen a 2by4 grid is somewhat optimal
  subplot(2,4,j);
  plotGrid(data{j,1}, data{j,2}, data{j,3}, markerScale, titleScale);
endfor
```

which results in a figure of subplots as shown below

<div align=center>
  <img src=FinalStates.png />
</div>