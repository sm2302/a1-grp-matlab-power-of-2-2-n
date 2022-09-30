addpath("stepFunctions"); % Path to step functions

clear;

fig1 = figure(1); % Assign to a handle in case need to save animation to .gif

data = {}; % to store final states, grid types, and labels

% Plot marker (adjustable)
markerScale = 1;

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
load savedStates2 triSeed; A = triSeed; % Load a saved state


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
survival = nan;

A = sprand(70, 70, 0.0175) > 0;

for i = 1:N
  plotGrid(A, grid, label, markerScale);
  A = stepFn(A, birth, survival);
endfor

data(6,1:3) = {A, grid, label};


% CELLULAR AUTOMATON 7
label = "LIFE WITHOUT DEATH";

birth    = [3];
survival = [0 1 2 3 4 5 6 7 8];

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

% COMBINED SUBPLOTS OF FIRST 8

% Display all in a single figure
fig2 = figure(2);

for j = 1:8 % Limit to only 8 because on screen a 2by4 grid is somewhat optimal
  subplot(2,4,j);
  plotGrid(data{j,1}, data{j,2}, data{j,3}, 0.3*markerScale);
endfor

