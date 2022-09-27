clear;

% NOTE
%   It is better to run this script section by section
%   (by highlighting the section of code to run, and pressing F9)
%   as each section is explained and given context by accompanying comments

% SECTION 0A - Conway's Game of Life
title = "Life rules";
birth = 3;
life = [2 3];
soup = sprand(50, 50, 0.1);
numGens = 100;
recordInterval = [-1 -1]; % set to [1 numGens] to write to .gif
runGame('sqr', birth, life, soup, numGens, title, recordInterval);
% END OF SECTION 0A
%
% SECTION 0B - REPLICATOR
title = "Replicator rules";
birth = [1 3 5 7];
life = [1 3 5 7];
soup = sprand(75, 75, 0.0001);
numGens = 100;
recordInterval = [-1 -1]; % set to [1 numGens] to write to .gif
runGame('sqr', birth, life, soup, numGens, title, recordInterval);
% END OF SECTION 0B
%
% SECTION 0C - SEEDS
title = "Seeds rules";
birth = 2;
life = 9; % Never, meaning all living cells die instantly
soup = sprand(50, 50, 0.015);
numGens = 100;
recordInterval = [-1 -1]; % set to [1 numGens] to write to .gif
runGame('sqr', birth, life, soup, numGens, title, recordInterval);
% END OF SECTION 0C
%
% SECTION 0D - LIFE WITHOUT DEATH
title = "Life without Death rules";
birth = 3;
life = [0 1 2 3 4 5 6 7 8];
soup = sprand(35, 35, 0.035);
numGens = 100;
recordInterval = [-1 -1]; % set to [1 numGens] to write to .gif
runGame('sqr', birth, life, soup, numGens, title, recordInterval);
% END OF SECTION 0D
%
% SECTION 0E - DIAMOEBA
title = "Diamoeba rules";
birth = [3 5 6 7 8];
life = [5 6 7 8];
soup = sprand(70, 70, 0.48);
numGens = 100;
recordInterval = [-1 -1]; % set to [1 numGens] to write to .gif
runGame('sqr', birth, life, soup, numGens, title, recordInterval);
% END OF SECTION 0E


% Warning just in case the code is NOT run by section
load messages inCaseNotRunBySection;
warning(inCaseNotRunBySection);


% SECTION A1: COMMON STILL-LIFE PATTERNS & MAXIMUM DENSITY STILL-LIFE @ 13X13
title = 'Life rules - Still-lives';
load savedStates stillLife;
numGens = 36;
recordInterval = [-1 -1]; % set to [1 numGens] to write to .gif
runGame('sqr', 3, [2 3], stillLife, numGens, title, recordInterval);
% END OF SECTION A1
%
%
% SECTION 1A2a - COMMON OSCILLATORS: TRAFFIC LIGHT & PULSAR
title = 'Life rules - Oscillators';
load savedStates oscillators;
numGens = 60;
recordInterval = [-1 -1]; % set to [1 numGens] to write to .gif
runGame('sqr', 3, [2 3], oscillators, numGens, title, recordInterval);
% END OF SECTION 1A2a
%
%
% SECTION 1A2b - SMALLEST OSCILLATORS IN DIAMOEBA RULES
title = 'Diamoeba rules - Oscillators';
load savedStates da_oscillators;
birth = [3 5 6 7 8];
life = [5 6 7 8];
numGens = 30;
recordInterval = [-1 -1]; % set to [1 numGens] to write to .gif
runGame('sqr', birth, life, da_oscillators, numGens, title, recordInterval);
% END OF SECTION 1A2b
%
%
% SECTION 1A3a - COMMON SPACESHIPS
title = 'Life rules - Spaceships';
load savedStates spaceships;
numGens = 59;
recordInterval = [-1 -1]; % set to [1 numGens] to write to .gif
runGame('sqr', 3, [2 3], spaceships, numGens, title, recordInterval);
% END OF SECTION 1A3a
%
%
% SECTION 1A3b - SMALLEST (ALSO THE FASTEST (1C/7)) SPACESHIP IN DIAMOEBA RULES
title = 'Diamoeba rules - Spaceship';
load savedStates da_spaceship;
birth = [3 5 6 7 8];
life = [5 6 7 8];
numGens = 71;
recordInterval = [-1 -1]; % set to [1 numGens] to write to .gif
runGame('sqr', birth, life, da_spaceship, numGens, title, recordInterval);
% END OF SECTION 1A3b
%
%
% SECTION 1A3c - COMMON GUNS
title = 'Life rules - Glider guns'
load savedStates guns;
numGens = 241;
recordInterval = [-1 -1]; % Can use [1 121]; Caution: the wider the interval the longer the delay.
runGame('sqr', 3, [2 3], guns, numGens, title, recordInterval);
% END OF SECTION 1A3c


% SECTION 2A1 - HEX GRID
title = "Hex-Grid";
hex_soup = sprand(60, 120, 0.2);
hex_birth = [3 4];
hex_life = [2 3 4];
numGens = Inf;
recordInterval = [-1 -1]; % set to [1 numGens] to write to .gif
runGame('hex', hex_birth, hex_life, hex_soup, numGens, title, recordInterval);
% END OF SECTION 2A1
%
%
% TRIANGULAR GRID
%
% SECTION 3
title = "Triangular-Grid";
t_soup = sprand(50, 150, 0.15);
t_birth = [2];
t_life = [1 2];
numGens = 100;
recordInterval = [-1 -1]; % set to [1 numGens] to write to .gif
runGame('tri', t_birth, t_life, t_soup, numGens, title, recordInterval);
% END OF SECTION 3
