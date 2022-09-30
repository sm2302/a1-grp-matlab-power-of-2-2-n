% DESCRIPTION
%   This script contains several runs of different Cell Automata (CA) variants
%
%   Procedure in each CA run with its current state A:
%   - State A is initialized with random values, with set dimensions and density
%       e.g. A = sprand(height, width, live cells density) > 0
%       Alternatively, any saved state can be used too as the initial state
%   - A loop occurs, where in each iteration:
%     ~ The current state A is plotted via. a call to plotGrid function
%     ~ A "step" function is called which computes the updated values of state A
%   - The final state is saved to be reused in the final combined last CA states
%
%   Optional procedure (saving an animation):
%   - To save progression of any CA state to a .gif file,
%     add calls to frame2im and im2gif functions to its section as such:
%
%       for i = 1:N
%         plotGrid(A, grid, label, markerScale);
%         A = stepFn(A);
%         im{i} = frame2im(getframe(fig1));     % <-- Add this line before end of loop
%       endfor
%       im2gif(im, label); im = {};             % <-- Add this line outside the loop
%
%   Also see:
%   - README.md, which explains in greater detail some approaches we took
%   - Step function files (in stepFunctions folder):
%     - stepLife.m,     -- Most basic and concise step function file
%     - stepTriangle.m, -- Similar to stepLife, but has 2 types of neighbourhood computation
%     - stepHex.m,      -- Similar to stepLife, has a slightly different neighbourhood computation
%     - stepHex3.m,     -- Similar to stepHex, but each cell has 3 possible states instead of 2
%     - stepSquare.m    -- Similar to stepLife, but accepts variable birth and survival conditions
%   - plotGrid.m   -- Handles plotting/figure-related procedures
%   - getLattice.m -- Generates a checkerboard pattern used in computations in hex/triangular CA.
%   - Images generation related function files
%     - fig2png -- extracts a figure's frame and save it as a .png image
%     - im2gif  -- saves a series of images stored in a cell aray to a .gif image
%
%   We initially had one unified function to handle both plotting and state computation (i.e. step)
%     for all grid shapes, but it grew too big (almost 400 lines of code in one file),
%     hence the separation into file chunks that are 10x> smaller and easier to read
%   Look at the other branch of this repo

addpath("stepFunctions"); % Path to step functions; Run this once per session at least

clear;

fig1 = figure(1); % Assign figure(1) to a handle in case need to save animation to .gif

data = {}; % Cell array to store final states, grid types, and labels of each run

% Adjust scale for plot marker as required (if either too big or too small)
% 1 is appropriate for when the figure window (at least its height) is maximized
markerScale = 1;

% DIFFERENT GRID SHAPES
%
%   The first four Cellular Automata (CA) demonstrates the different grid shapes
%     we have coded and experimented with, and saw that these rules produce
%     the nicest (or most LIFE-like) results for each shape
%     - SQUARE GRID:      Birth=3; Survival=2,3 (Default LIFE rules)
%     - TRIANGULAR GRID:  Birth=4,8; Survival=4,5,6
%     - HEXAGONAL GRID:   Birth=3,4; Survival=2,3,4
%     - HEXAGONAL-3 GRID: Birth=4; Sb2r=1,2,3,4,6; Sr2r=1,2; Sr2b=4
%       - HEX-3 has 3 states (dead, blue, red) instead of 2 (dead, alive)
%
%   References:
%     https://www.quora.com/Are-there-variations-of-Conways-Game-of-Life-based-upon-a-triangular-or-hexagonal-grid
%     - Joe Wezorek's post on the three-state (instead of two) CA variant which
%     can result in a hexagonal world which he described as more similar to LIFE
%     https://www.redblobgames.com/grids/hexagons/#coordinates
%     - Hexagonal grid coordinates system, that is, offsetting every other
%     column or row


% For all cellular automata, run its loop for N iterations
N = 100;


% CELLULAR AUTOMATON 1
label = "Game of LIFE";
grid = "square";
stepFn = @stepLife;
A = sprand(200, 200,0.075) > 0;

for i = 1:N
  plotGrid(A, grid, label, markerScale);
  A = stepFn(A);
endfor

data(1,1:3) = {A, grid, label};


% CELLULAR AUTOMATON 2
label = "Tri-Grid";
grid = "triangle";
stepFn = @stepTriangle;
load savedStates2 triSeed; A = triSeed; % Load a saved state (which guarantees occurance of gliders)
% A = sprand(75, 100, 0.15) > 0; % Alternatively, a random seed can be used as with other CA

for i = 1:N
  plotGrid(A, grid, label, markerScale);
  A = stepFn(A);
endfor

data(2,1:3) = {A, grid, label};


% CELLULAR AUTOMATON 3
label = "Hex-Grid";
grid = "hexagon";
stepFn = @stepHex;
A = sprand(100, 175, 0.2) > 0;

for i = 1:N
  plotGrid(A, grid, label, markerScale);
  A = stepFn(A);
endfor

data(3,1:3) = {A, grid, label};


% CELLULAR AUTOMATON 4

label = "Hex-Grid with 3 states";
grid = "hexagon3";
stepFn = @stepHex3;
A = ceil(sprand(120, 210, 0.06).*2);

for i = 1:N
  plotGrid(A, grid, label, markerScale);
  A = stepFn(A);
endfor

data(4,1:3) = {A, grid, label};


% OTHER LIFE-LIKE CELLULAR AUTOMATA
%
%   For a cellular automaton (CA) to be considered similar to LIFE,
%   these criteria have to be met:
%   - The array of cells has two dimensions
%   - Each cell has two possible states (unlike in stepHex3)
%   - The neighbourhood of each cell has eight adjacent cells (unlike in other grid shapes)
%   - The new state of a cell computed in each time step can be expressed as
%       a function of adjacent alive cells and of the cell's own state
%
%   The next 4 runs are of CA which we liked and that meet the above criteria
%   - Replicator         -- Birth=1,3,5,7; Survival=1,3,5,7
%   - Seeds              -- Birth=2; Survival=NEVER (die instantly after birth)
%   - Life without Death -- Birth=3; Survival=0,1,2,3,4,5,6,7,8
%   - Diamoeba           -- Birth=3,5,6,7,8; Survival=5,6,7,8
%
%   Reference on LIFE-like CA:
%   https://en.wikipedia.org/wiki/Life-like_cellular_automaton
%
%   The stepSquare function further expects as arguments
%   birth and survival conditions


% Common variables (or constants) for the remaining CA runs
stepFn = @stepSquare; N = 100;
grid = "square";


% CELLULAR AUTOMATON 5
label = "REPLICATOR";

birth    = [1 3 5 7];
survival = [1 3 5 7];

A = sprand(100, 100, 0.0001) > 0;

for i = 1:N
  plotGrid(A, grid, label, markerScale);
  A = stepFn(A, birth, survival);
endfor

data(5,1:3) = {A, grid, label};


% CELLULAR AUTOMATON 6
label = "SEEDS";

birth    = 2;
survival = nan; % never survive past one generation

A = sprand(70, 70, 0.0175) > 0;

for i = 1:N
  plotGrid(A, grid, label, markerScale);
  A = stepFn(A, birth, survival);
endfor

data(6,1:3) = {A, grid, label};


% CELLULAR AUTOMATON 7
label = "LIFE WITHOUT DEATH";

birth    = [3];
survival = [0 1 2 3 4 5 6 7 8]; % never die

A = sprand(70,70,0.045) > 0;
for i = 1:N
  plotGrid(A, grid, label, markerScale);
  A = stepFn(A, birth, survival);
endfor

data(7,1:3) = {A, grid, label};


% CELLULAR AUTOMATON 8
label = "DIAMOEBA";

birth    = [3 5 6 7 8];
survival = [5 6 7 8];

A = sprand(70, 70, 0.48) > 0;

for i = 1:N
  plotGrid(A, grid, label, markerScale);
  A = stepFn(A, birth, survival);
endfor

data(8,1:3) = {A, grid, label};


% BONUS CELLULAR AUTOMATA - FROM SAVED STATES
label = "Gosper & Simkin Glider Guns in Game of LIFE";
grid = "square";
stepFn = @stepLife;

load savedStates guns;
A = guns; N = 240;

for i = 1:N
  plotGrid(A, grid, label, markerScale/1.3);
  A = stepFn(A);
endfor

% COMBINED SUBPLOTS OF FIRST 8 CA RUNS' FINAL STATES

% Display all in a single figure
fig2 = figure(2);

for j = 1:8 % Limit to only 8 because on screen a 2by4 grid is somewhat optimal
  subplot(2,4,j);
  plotGrid(data{j,1}, data{j,2}, data{j,3}, 0.3*markerScale);
endfor

% To save these subplots to an image, maximize Figure 2 which contains subplots
%   and run fig2png(fig2, "FinalStates")
