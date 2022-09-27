clear;

% NOTE
%   It is better to run this script section by section
%   (by highlighting the section of code to run, and pressing F9)
%   as each section is explained and given context by accompanying comments

% DESCRIPTION                                           (& runHexGol, once)
%   This script file contains a collection of calls to the runGame function,
%   which accepts the following input arguments:
%   - grid:    {'sqr', 'hex', 'tri'} - the type/shape of grid which determines
%                how cells' neighbours are computed
%   - birth:   Integer or array of integers - Bring a cell to life in its next
%                state if it has this amount of live neighbours
%   - life:    Integer or array of integers - Maintain life of a living cell
%                if it has this amount of neighbours
%   - startState:
%              Square matrix - Representation of the initial state of the world
%                Zeros representing dead cells, non-zeros representing living cells
%   - numGens: Integer - number of generations to be run before the program_invocation_name
%                terminates
%   - worldName:
%              String - What the game run will be called and what the resulting
%                .gif file would be called
%   - markerScale (optional):
%              How big the plot marker is scaled. Bigger scales should be used
%                for smaller worlds.
%   - recordInterval (optional, disabled by default):
%              Integer array of size 2 - The range of generations to be saved
%                in a .gif image file.
%
% Each runGame function call will have some accompanying comments explaining
%   its context, so it is advisable to run the script section-by-section
%   instead of running it as a whole.
%
% This can be done by selecting the region of code to be run, and pressing F9
%   (on Octave)

% BIRTH AND DEATH RULES
%
%   The Game of Life (GOL) is the most famous "cell automaton" which meets
%     all of certain criteria, namely:
%     - The array of cells of the automaton has two dimensions.
%     - Each cell of the automaton has two states (alive and dead)
%     - The neighbourhood of each cell consists of the cells adjacent to it
%     - The new state of a cell can be expressed as a function of:
%         current number of neighbours in alive state, and
%         the cell's own current state
%
%   The GoL has the following rules
%     Birth: 3 (number of neighbours needed to turn a cell on/alive)
%     Life : [2 3] (number of neighbours needed to maintain a living cell's life)
%            In other cases, the cell would die
%
%   The following game run demonstrates the set of rules in practice on
%     a randomized initial state (officially known as a "soup") of size 50 by 50
%     with a density of 0.1, meaning 1 out of 10 cells will start in alive state
%
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
%   Next we experiment with other rules for the same grid
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


% The next two lines are just to warn in case the code is NOT run by section
load messages inCaseNotRunBySection;
warning(inCaseNotRunBySection);


% PATTERNS IN GAME OF LIFE
%
% The square grid, combined with the default "Life" (Birth 3; Life [2 3]) rules,
%   seems to be the most popular and the most documented
%   among the "cell atomaton" variants
%
% In the Game of Life, many interesting patterns have been discovered
%   whether occuring naturally i.e. in random initial states
%   or deliberately drawn.
%
% Our group have drawn/prepared few saved states to demonstrate several of these
%   by basic categories:
%   - Still Life
%   - Oscillators
%   - Spaceships
%
% Basic structure 1: Still life
%   A still life pattern does not change from one generation to the next, e.g.:
%
%   Three most common still lifes:
%
%    Block    Beehive      Loaf
%     ■ ■       ■ ■          ■
%     ■ ■     ■     ■      ■   ■
%               ■ ■      ■     ■
%                          ■ ■
%
%   These structures also often are formed in 'Familiar fours' which is a label
%     for common constellation of four identical objects
%     E.g.:
%       - Four Skewed Blocks: 4 Blocks (synthesized from 2 colliding gliders)
%       - Honey farm:         4 Beehives (synthesized from predecessor 'bun')
%       - Bakery:             4 Loaves (synthesized from predecessor 'yeast')
%
%   Also in plot: Maximum density still-life that can be constructed in a
%                13 by 13 square region (88/169 living to total cell ratio)
%                Reference: https://www.semanticscholar.org/paper/Integer-Programming-and-Conway's-Game-of-Life-Bosch/f7ceb541fff2a2df690494e80b116c99ae26fd42
%
%   The following world (SECTION A1) will stabilize at generation 18
%     at which point everything will have become still life structures
%
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
% Basic structure 2: Oscillators
%   An oscillator is a pattern that repeats itself after a fixed
%   "number of generations" a.k.a. period
%
%   Blinker - the smallest and most common oscillator:
%
%                ■
%    ■ ■ ■       ■      - It is a period-2 oscillator, meaning that after the
%                ■          2 generations, it returns to its initial state
%   Gen 1/2   Gen 2/2
%
%   Another 'Familiar Four' called Traffic Light is formed from four blinkers.
%   Coincidentally, it is the most common member of the Familiar Fours
%
%   Pulsar - a large but common period-3 oscillator (shown in next game run)
%
%   Interestingly, both the Traffic Light and Pulsar can be synthesized from
%   the 'ring' (not an official label) structure below:
%
%     ■ ■ ■ - Left alone, this structure evolves into a Traffic Light
%     ■   ■
%     ■ ■ ■ - However when 2 of them are placed 3 cells apart, they
%               become a Pulsar. The initial structure is known as a Pre-Pulsar
%
%   The following game run will start with four of the 'ring' structures,
%     two of which will synthesize into two Traffic Lights
%     while the other two will turn into a Pulsar
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
%   Oscillators also exist in other Life-like Cell Automata, such as in
%     Diamoeba rules as shown in the next game run
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
% Basic structure 3: Spaceships
%   A spaceship (a.k.a. glider, or ship for short) is a finite pattern that
%   returns to its initial state after a "number of generations" (a.k.a. period)
%
%   Speed of a spaceship:
%     Speed is expressed in the form #c/# such as in the e.g.:
%       2c/5 - means a ship moves 2 cells during its period of 5
%     The max speed of a ship (not including negative-ships/agar-crawlers)
%       is c/2 orthogonal and c/4 diagonal
%
%   Common spaceships:
%
%   Glider - The smallest, most common and first-discovered spaceship in GoL
%            It has a speed of c/4
%     ■
%       ■  - A glider that moves in the southeast direction
%   ■ ■ ■
%
%   Lightweight Spaseship (LWSS) - The smallest orthogonal spaceship
%                                  Second most common spaceship after the Glider
%     ■     ■                      Speed of 2c/4,
%   ■                                which is equivalent to the max ortho speed
%   ■       ■
%   ■ ■ ■ ■   - A LWSS moving to the left
%
%   The following game run will have:
%     Four LWSS, one at each corner
%     Four gliders synthesized at the center from a 4-8-12 diamond pattern
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
%   Spaceships also exist in other Life-like Cell Automata, such as in
%     Diamoeba rules as shown in the next game run
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
% Spaceship related: Guns
%   A Gun is a stationary pattern that REPEATEDLY emits spaceships
%     unlike the 4-8-12 Diamond pattern which only generates Gliders once
%
%   Gosper Glider gun (left) is the first discovered and most well-known gun,
%     found by Bill Gosper in November 1970
%     which happens to also be the first finite pattern with unbounded growth.
%
%   Simkin Glider Gun (right) is a double-barelled Glider Gun
%     found by Michael Simkin on 28 Apr 2015
%     which shares the record with Gosper Glider Gun for the smallest known gun
%
% SECTION 1A3c - COMMON GUNS
title = 'Life rules - Glider guns'
load savedStates guns;
markerScale = 3;
numGens = 241;
recordInterval = [-1 -1]; % Can use [1 121]; Caution: the wider the interval the longer the delay.
runGame('sqr', 3, [2 3], guns, numGens, title, markerScale, recordInterval);
% END OF SECTION 1A3c



% HEXAGONAL GRID
%
%   Other than the square grid, we have also coded logic to run hex-grid worlds
%
%   We found the rules:
%     birth : [3 4]
%     life  : [2 3 4]
%   to have interesting results in the hex grid
%
%   We have found few interesting traits of this configuration
%     - Still-lives are common
%     - Hexagonal structures tend to form and consume other nearby live cells
%       - These hexagonal structures' contents are initially chaotic
%         ...but eventually stabilize to form a combination of
%         hivelike pattern (majority), and small patches of oscillators
%
%   The next game run will start with a soup (random initial state),
%     running on the aforementioned rules, and hopefully demonstrating the
%     traits mentioned (it is likely to happen, so re-running may do the job
%                       if it does not show within the first run)
%
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
% HEX WORLD - SIMILAR TO GAME OF LIFE?
%
%   Based on Joe Wezorek's (self-discoverer of this automata variant) Quora post,
%     https://www.quora.com/Are-there-variations-of-Conways-Game-of-Life-based-upon-a-triangular-or-hexagonal-grid
%     one close imitation of the GoL in a hexagonal grid world,
%     meaning there would be naturally occuring gliders,
%     and that bounded growth is frequently exhibited from random initial state,
%     would be where a rule (i.e. cells having only two states) is broken.
%
%   The new states would be:
%     - death
%     - blue (originally yellow, but blue looks better against white background)
%     - red                                    (as in more visible, than yellow)
%
%   And the decision criterion for a cell's next state would be
%     S = sum of values where
%         Each dead neighbour = +0
%         Each blue neighbour = +1
%         Each red neighbour = +2
%
%   New state transition rules:
%     - If the cell is currently dead it comes to life as blue if S == 4
%     - If the cell is blue it goes to red if S == [1 2 3 4 6]
%     - If the cell is red
%         - it stays red if S == [1 2]
%         - it goes to blue if S == 4.
%     - Otherwise it is dead in the next generation.
%
%  As the state rules have become too different, to keep the initial function
%    file tidy, the code for this is separated into own function file runHexGol
%    which accepts the input arguments:
%      - deadToBlue     -- number of neighbours for state change: dead -> blue
%      - blueToRed      -- number of neighbours for state change: blue -> red
%      - redToRed       -- number of neighbours to stay in state: red -> red
%      - redToBlue      -- number of neighbours for state change: red -> blue
%      - startState     -- state of the cells in the first generation
%      - numGens        -- the number of generations the game will run
%      - worldName      -- the name of the world
%      - markerScale    -- how big/small the marker on the plot is
%      - recordInterval -- lower & upper bound of generation number to record
%
%   The following game run uses this function, starting with a saved state
%   Alternatively, sprand(40, 70, 0.07) can be used instead
%
% SECTION 2A2 - GOL-LIKE HEX WORLD (CELL AUTOMATA WITH THREE STATES)
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
% END OF SECTION 2A2


% TRIANGULAR GRID
%
%   The last grid we included in the program is the triangular grid,
%     with the following rules
%       Birth: [4 8]
%       Life: [4 5 6]
%     which do result in patterns such as still-lives, gliders and oscillators
%
%   The next game runs on the above setting
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
