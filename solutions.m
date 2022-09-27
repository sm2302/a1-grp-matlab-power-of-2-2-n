clear;

% NOTE
%   It is better to run this script section by section
%   (by highlighting the section of code to run, and pressing F9)
%   as each section is explained and given context by accompanying comments

% SECTION 0A - Conway's Game of Life
title = "Life rules";
birth = 3;
life = [2 3];
soup = sprand(200, 200, 0.075);
numGens = 100;
markerScale = 0.4;
recordInterval = [-1 -1]; % set to [1 numGens] to write to .gif
runGame('sqr', birth, life, soup, numGens, title, markerScale, recordInterval);
% END OF SECTION 0A
%
% SECTION 0B - REPLICATOR
title = "Replicator rules";
birth = [1 3 5 7];
life = [1 3 5 7];
soup = sprand(100, 100, 0.0001);
numGens = 100;
markerScale = 0.4;
recordInterval = [-1 -1]; % set to [1 numGens] to write to .gif
runGame('sqr', birth, life, soup, numGens, title, markerScale, recordInterval);
% END OF SECTION 0B
%
% SECTION 0C - SEEDS
title = "Seeds rules";
birth = 2;
life = 9; % Never, meaning all living cells die instantly
soup = sprand(70, 70, 0.015);
numGens = 100;
markerScale = 1;
recordInterval = [-1 -1]; % set to [1 numGens] to write to .gif
runGame('sqr', birth, life, soup, numGens, title, markerScale, recordInterval);
% END OF SECTION 0C
%
% SECTION 0D - LIFE WITHOUT DEATH
title = "Life without Death rules";
birth = 3;
life = [0 1 2 3 4 5 6 7 8];
soup = sprand(50, 50, 0.035);
numGens = 100;
markerScale = 2;
recordInterval = [-1 -1]; % set to [1 numGens] to write to .gif
runGame('sqr', birth, life, soup, numGens, title, markerScale, recordInterval);
% END OF SECTION 0D
%
% SECTION 0E - DIAMOEBA
title = "Diamoeba rules";
birth = [3 5 6 7 8];
life = [5 6 7 8];
soup = sprand(70, 70, 0.48);
numGens = 100;
markerScale = 1;
recordInterval = [-1 -1]; % set to [1 numGens] to write to .gif
runGame('sqr', birth, life, soup, numGens, title, markerScale, recordInterval);
% END OF SECTION 0E


% Warning just in case the code is NOT run by section
load messages inCaseNotRunBySection;
warning(inCaseNotRunBySection);


% SECTION A1: COMMON STILL-LIFE PATTERNS & MAXIMUM DENSITY STILL-LIFE @ 13X13
title = 'Life rules - Still-lives';
load savedStates stillLife;
markerScale = 4; % Big scale as the world is relatively small
numGens = 36;
recordInterval = [-1 -1]; % set to [1 numGens] to write to .gif
runGame('sqr', 3, [2 3], stillLife, numGens, title, markerScale, recordInterval);
% END OF SECTION A1
%
%
% SECTION 1A2a - COMMON OSCILLATORS: TRAFFIC LIGHT & PULSAR
title = 'Life rules - Oscillators';
load savedStates oscillators;
markerScale = 4;
numGens = 60;
recordInterval = [-1 -1]; % set to [1 numGens] to write to .gif
runGame('sqr', 3, [2 3], oscillators, numGens, title, markerScale,  recordInterval);
% END OF SECTION 1A2a
%
%
% SECTION 1A2b - SMALLEST OSCILLATORS IN DIAMOEBA RULES
title = 'Diamoeba rules - Oscillators';
load savedStates da_oscillators;
birth = [3 5 6 7 8];
life = [5 6 7 8];
numGens = 30;
markerScale = 5;
recordInterval = [-1 -1]; % set to [1 numGens] to write to .gif
runGame('sqr', birth, life, da_oscillators, numGens, title, markerScale,  recordInterval);
% END OF SECTION 1A2b
%
%
% SECTION 1A3a - COMMON SPACESHIPS
title = 'Life rules - Spaceships';
load savedStates spaceships;
markerScale = 3;
numGens = 59;
recordInterval = [-1 -1]; % set to [1 numGens] to write to .gif
runGame('sqr', 3, [2 3], spaceships, numGens, title, markerScale,  recordInterval);
% END OF SECTION 1A3a
%
%
% SECTION 1A3b - SMALLEST (ALSO THE FASTEST (1C/7)) SPACESHIP IN DIAMOEBA RULES
title = 'Diamoeba rules - Spaceship';
load savedStates da_spaceship;
birth = [3 5 6 7 8];
life = [5 6 7 8];
numGens = 71;
markerScale = 3;
recordInterval = [-1 -1]; % set to [1 numGens] to write to .gif
runGame('sqr', birth, life, da_spaceship, numGens, title, markerScale, recordInterval);
% END OF SECTION 1A3b
%
%
% SECTION 1A3c - COMMON GUNS
title = 'Life rules - Glider guns'
load savedStates guns;
markerScale = 3;
numGens = 241;
recordInterval = [-1 -1]; % Can use [1 121]; Caution: the wider the interval the longer the delay.
runGame('sqr', 3, [2 3], guns, numGens, title, markerScale, recordInterval);
% END OF SECTION 1A3c


% SECTION 2A1 - HEX GRID
title = "Hex-Grid";
hex_soup = sprand(80, 140, 0.2);
hex_birth = [3 4];
hex_life = [2 3 4];
numGens = Inf;
markerScale = 1;
recordInterval = [-1 -1]; % set to [1 numGens] to write to .gif
runGame('hex', hex_birth, hex_life, hex_soup, numGens, title, markerScale, recordInterval);
% END OF SECTION 2A1
%
%% SECTION 2A3 - GOL-LIKE HEX WORLD (CELL AUTOMATA WITH THREE STATES)
title = 'Hex-Grid with three states - Life-like traits';
load savedStates hexGolSeed; % A saved soup that demonstrates life-like traits well
hexGol_soup = sprand(120, 210, 0.06);
birth = 4;
b_to_r = [1 2 3 4 6];
r_to_r = [1 2];
r_to_b = 4;
hex_life = [3 5];
numGens = 100;
recordInterval = [-1 -1]; % Setting to write to gif file only up to frame 80 to as the process may otherwise take too long
markerScale = 1;
runHexGol (birth, b_to_r, r_to_r, r_to_b, hexGol_soup, numGens, title, markerScale, recordInterval);
% END OF SECTION 2A3


% TRIANGULAR GRID
%
% SECTION 3
title = "Triangular-Grid";
t_soup = sprand(150, 200, 0.15);
t_birth = [4 8];
t_life = [4 5 6];
markerScale = 0.3;
numGens = 100;
recordInterval = [-1 -1]; % set to [1 numGens] to write to .gif
runGame('tri', t_birth, t_life, t_soup, numGens, title, markerScale, recordInterval);
% END OF SECTION 3
