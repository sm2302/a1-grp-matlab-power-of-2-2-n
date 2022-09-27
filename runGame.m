function runGame (grid='default', birth=-1, life=-1, startState=-1, numGens=-1, worldName='default', markerScale = 2, recordInterval = [-1 -1])

  % This function runs, and illustrates, a cell automaton similar to the
  % Game of Lifewith user-specified (or default) properties.
  % It makes use of a WHILE-LOOP to:
  %   - draw each generation of the game world via. the spy() function
  %   - compute the state of the generation after the one that has been drawn
  % Game state data is stored in TWO "WORLDSTATE" SPARSE MATRICES:
  %   - one, which stores the latest complete data, is used for reference
  %     in drawing and as the basis for computation of a new state
  %   - the other, which stores outdated data, is in the current loop being
  %     overwritten with the new state's data based on said computation
  % These two matrices are switched at one point in each game loop.
  %
  %
  % Input arguments:
  %
  %         grid -- string; Possible values: {'sqr'/'hex'/'tri'}
  %                 - The type of grid the game cells would live on
  %
  %        birth -- integer, or, vector of integers
  %                 - The amount of neighbours of a dead cell required for birth
  %                   i.e. it be given life
  %
  %         life -- integer, or, vector of integers
  %                 - Amount of neighbours required to maintain life
  %                   of an already living cell
  %
  %   startState -- matrix of zeros and non-zeros
  %                 - Represents the life-or-death states of all cells
  %                   at the start of the game; 0 being dead, non-0 being alive
  %
  %      numGens -- integer
  %                 - The number of total generations the game will run
  %
  %  markerScale -- integer
  %                 - How big or small the plot marker is. Larger worlds
  %                   which lead to the plot being zoomed out would require
  %                   this number to be small, and vice versa.
  %
  %recordInterval-- 2-element vector
  %                 - Determines lower and upper bounds of
  %                   generation numbers to be saved to .gif file.
  %                   Pass [-1 -1] to opt out of creating a .gif.
  %
  %
  % If any parameter left out or set as negative, use these default values:
  %
  %   arg \ grid | sqr          hex         tri       |
  %   -----------|------------------------------------|
  %   birth      | 3            [3 4]       2         |
  %   life       | [2 3]        [2 3 4]     [1 2]     |
  %   startState | 100,100,0.1  80,140,0.2  50,97,0.2 | (via. sprand)
  %   numGens    | Inf          Inf         Inf       |


  % Validate input args and assign default values where appropriate
  %   Taking this portion of the code out of this function script keeps it neat
  [grid, birth, life, startState, numGens, worldName, markerScale, recordInterval] = validateAndSetDefaultArgs(grid, birth, life, startState, numGens, worldName, markerScale, recordInterval);

  % Filename in case we write figure frames to gif. Empty images cell array
  filename = sprintf('%s.gif', worldName);          im = {};

  % Save the seed in case we want to rerun the world
  %   e.g. with a previously initialized random state
  lastSeed = startState;
  save('lastSeed','lastSeed');

  % Extract the size of the provided starting matrix
  [numRows, numCols] = size(startState);

  % Total number of possible cells - computed differently in a hex grid
  nCellsTotal = numRows*numCols;

  % About numPadding
  %   The world is padded by one unit of space on all 4 boundaries
  %     which are not game cells, hence do not react according to the game rules,
  %     and exists only to prevent out-of-bounds access when counting neighbours
  %   Only the horizontal padding is variable which is the variable numPadding
  %     as the square grid needs only one padding,
  %     but the triangular and hexagonal grids require two
  numPadding = 2;

  % Grid-type dependent variables
  switch grid

    % About aspectRatio
    %   Adjusting the aspect ratio corrects any possible disproportion in
    %     spacing from auto-stretching or due to the shape of the plot markers
    %     and the arrangement of cells in the hexagonal and triangular grids

    case 'sqr'
      aspectRatio = [1 1];
      neighbourIncrement = sparse([
        1 1 1;
        1 0 1; % - neighbourhood of a square cell
        1 1 1;
      ]);

      % Because the maximum distance (in unit grid) from a cell to its neighbourCounts
      %   is only 1 for square (as opposed to 2 for hexagonal and triangular)
      %   Set the numPadding to 1
      numPadding = 1;

    case 'hex'
      aspectRatio = [1.75 1];

      % Because not all matrix positions are used in a hexagonal grid,
      %   nCellsTotal computation is different.

      % In addition, there is extra horizontal padding in hex grid
      % as neighbours are necessarily distanced 2-units horizontally, as such:
      %   00⬢⬡⬢⬡⬢⬡⬢⬡⬢00
      %   00⬡⬢⬡⬢⬡⬢⬡⬢⬡00 - where ⬢ represents every game cell (dead or alive)
      %   00⬢⬡⬢⬡⬢⬡⬢⬡⬢00 - and ⬡ every unused position in the matrix
      %   00⬡⬢⬡⬢⬡⬢⬡⬢⬡00

      neighbourIncrement = sparse([
        0 1 0 1 0; % ⬡⬢⬡⬢⬡
        1 0 0 0 1; % ⬢⬡✡⬡⬢ - neighbourhood of the hexagonal cell ✡
        0 1 0 1 0; % ⬡⬢⬡⬢⬡
      ]);

      % nCellsTotal computation:
      if mod(numRows,2)==0 % If numRows is even, averaging num of elements works
        % E.g., for numRows=2, numCols=5:
        %   ⬢-⬢-⬢
        %   -⬢-⬢-          2 * 5 / 2 = 5 elements
        nCellsTotal = numRows*numCols/2;

      else % Otherwise, need to consider differences in elements per row
        % E.g., for numRows=3, numCols=5:
        %   ⬢ ⬢ ⬢
        %    ⬢ ⬢
        %   ⬢ ⬢ ⬢          (3-1)*5/2 + ceil(5/2) = 8
        nCellsTotal = (numRows-1)*numCols/2 + ceil(numCols/2);
      endif

      % Eliminate any possible non-dead cell in these unused positions
      %   as otherwise they would be visible in the plot
      startState(1:2:numRows, 2:2:numCols) = 0;
      startState(2:2:numRows, 1:2:numCols) = 0;

    case 'tri'
      aspectRatio = [1.3 1];

      % As with the hex grid, this too requires extra horizontal padding.
      %   Reason being, cells touching the triangle vertices count as neighbours,
      %   some of which are two units away, horizontally, as shown below

      % Row & column numbers would be used later to identify the triangle type
      %  ▲▼▲▼▲                          ▲▼▲
      %  ▼▲v▲▼  -  Downward pointing;  ▲▼^▼▲  - Upward pointing
      %   ▼▲▼                          ▼▲▼▲▼
      % which differentiates their neighbour positions (▲s and ▼'s shown above).
      neighbourIncrement{1} = sparse([
        1 1 1 1 1;
        1 1 0 1 1; % Neighbourhood of a ▼ cell
        0 1 1 1 0;
      ]);
      neighbourIncrement{2} = sparse([
        0 1 1 1 0;
        1 1 0 1 1; % Neighbourhood of a ▲ cell
        1 1 1 1 1;
      ]);

      % Prepare filter for identifying triangle type based on position
      % Types being either downward-facing or upward-facing
      for r=2:numRows+1          % dTF      uTF      example in 3x3 world
        for c=3:numCols+1        % 0000000  0000000  0000000
          offset = mod(r+c, 2);  % 0010100  0001000  00▼▲▼00
          dTF(r,c) = 1 - offset; % 0001000  0010100  00▲▼▲00
          uTF(r,c) = offset;     % 0010100  0001000  00▼▲▼00
        endfor                   % 0000000  0000000  0000000
      endfor
      % Force the last row's & column's existance in these matrices
      dTF(numRows+2,numCols+4) = 0;
      uTF(numRows+2,numCols+4) = 0;

  endswitch

  % Other variables from common computations:

  % Values for start and end of actual world cells, will be used in the loop
  rowStart = 2;
  rowEnd = numRows + 1;
  colStart = 1 + numPadding;
  colEnd = numCols + numPadding;

  % Dimensions of the world (including padding) used later in the loop
  totalHeight = numRows+2;
  totalWidth = numCols+2*numPadding;

  % Assign limits such that paddings are disregarded in the displayed plot
  axesLimits = [colStart, colEnd, rowStart, rowEnd];

  % Initialize horizontal & vertical paddings as empty row and column vectors
  padUD = sparse(1, numCols+2*numPadding); % Two units wider than the startState
  padLR = sparse(numRows, numPadding);     % As tall as the startState

  % Store "padded" starting state info as sparse mat in a MATLAB cell array
  worldState{1} = sparse([
            padUD         ;
  padLR, startState, padLR;
            padUD         ;
  ]);

  % Using the a common (i.e. worldState) cell array,
  %   two matrices can be used interchangeably such that
  %     1st iteration: worldState{1} is displayed, worldState{2} is written
  %     2nd iteration: worldState{2} is displayed, worldState{1} is rewritten
  %     3rd iteration: worldState{1} is redisplayed, worldState{2} is rewritten
  %     and so on...
  % Doing so, as opposed to initializing an additional matrix per generation,
  %   preserves memory.
  % The other matrix "worldState{2}" will be initialized inside the game loop

  fig = figure(1);

  now = 1; % Variable to track the matrix currently holding the active state

  gen = 0; % Variable to track the number of elapsed generations

  fprintf("Running %s for %d generations\n", worldName, numGens);

  while gen < numGens

    gen = gen + 1;

    % Get the number representing the next state matrix to be written onto
    %   i.e. worldState{next}; now & next should be either 1 or 2, now =/= next
    next = mod(now, 2) + 1;

    % According to grid type:
    switch grid
      % Draw the latest state of the game world as recorded in worldState{now}
      case 'sqr'
        spy(worldState{now}, 'sk', 1*markerScale);
      case 'hex'
        spy(worldState{now}, 'hexagramk', 2*markerScale);
      case 'tri'
        % Filter the state matrix to draw only downward-facing triangles with ▼
        spy(worldState{now}.*dTF, 'vk', 2*markerScale);
        hold on;
        % Now, filter to draw only upward-facing triangles with ▲
        spy(worldState{now}.*uTF, '^k', 2*markerScale);
        hold off;
    endswitch

    % Set the axis limits
    axis(axesLimits);

    % Adjust the aspect ratio to offset the gap due to marker shapes and
    %   the arrangement of cells in the hexagonal and triangular grids
    daspect(aspectRatio);

    % Compute the number of living cells
    %   i.e. positions with nonzero value in the state matrix
    nCellsAlive = nnz(worldState{now});

    % Set title shown in plot
    title(strcat(worldName, sprintf(
      ' - %dth generation - living: %d/%d',
      gen, nCellsAlive, nCellsTotal)));

    % Axis numbers not required in this project
    axis off;

    % Ensure that each generation is displayed and not skipped
    drawnow;

    % Save the range of frames to be written to the gif;
    %   To opt out, just make the recordInterval values impossible to be met
    if gen >= recordInterval(1) && gen <= recordInterval(2)
      % Extract frame from figure to be written to the gif file later
      frame = getframe(fig);
      im{1 + gen - recordInterval(1)} = frame2im(frame);
    endif

    % Compute the next world state, and write the values in worldState{next}:

    % Initialize an empty sparse matrix the size of the world
    %   with an arbitrary (nCellsAlive) number of rooms to provide for values
    neighbourCounts = spalloc(totalHeight, totalWidth, nCellsAlive*2);

    % Extract 2 column vectors containing x and y positions of living cells
    [livingCellsY, livingCellsX] = find(worldState{now});
    for ind = 1:nCellsAlive
      y = livingCellsY(ind); x = livingCellsX(ind);

      % Add 1 to neighbouring cells' "neighbourCount"s
      switch grid
        case 'sqr'
          neighbourCounts(y-1:y+1, x-1:x+1) += neighbourIncrement;
        case 'hex'
          neighbourCounts(y-1:y+1, x-2:x+2) += neighbourIncrement;
        case 'tri'
          % Use x and y positions to decide which matrix to use (i.e. for ▼ or ▲)
          neighbourCounts(y-1:y+1, x-2:x+2) += neighbourIncrement{mod(x+y+1, 2)+1};
      endswitch
    endfor

    % Set all elements on the 4 edges i.e. paddings to 0 as these should not be
    %   accessed
    neighbourCounts([1, rowEnd+1],:) = neighbourCounts(:, [1:numPadding, colEnd+1:colEnd+numPadding]) = 0;

    numCellsOfInterest = nnz(neighbourCounts);

    % Extract x and y positions of all cells that have live neighbours.
    [cellY, cellX, numNeighbours] = find(neighbourCounts);

    % Initialize empty column vector of size numCellsOfInterest
    cellStates = zeros(numCellsOfInterest,1);

    % Decide whether the cells are alive
    % By default, they will die (i.e. if none of the conditions below are met)

    % Note that this method of computation alone does not work if 0 is in either
    %   the birth rule or life rule

    for ind = 1:numCellsOfInterest
      if worldState{now}(cellY(ind),cellX(ind)) == 0 % If currently dead
        % Check if numNeighbours satisfy birth rule
        if any(birth == numNeighbours(ind))
          cellStates(ind) = 1;
        endif
      else % If currently alive
        % Check if numNeighbours satisfy life/survival rule
        if any(life == numNeighbours(ind))
          cellStates(ind) = 1;
        endif
      endif
    endfor

    % Required extra computation when 0 is in either birth or life (B0.. or S0..)
    if any([birth,life] == 0)
      if any(birth == 0)
        if any(life == 0) % extract all (dead or alive) cells with no neighbours
          neighbourlessCells = ~neighbourCounts;
        else % extract all dead cells with no neighbours
          neighbourlessCells = ~neighbourCounts.*~worldState{now};
        endif
      else  % extract all living cells with no neighbours
        neighbourlessCells = ~neighbourCounts.*worldState{now};
      endif

      % Nullify the matrix's edges (i.e. world paddings)
      neighbourlessCells([1, rowEnd+1],:) = neighbourlessCells(:, [1:numPadding, colEnd+1:colEnd+numPadding]) = 0;

      % Extract position of "loner" cells and the corresponding ones vector
      [lonersY, lonersX, lonerStates] = find(neighbourlessCells);

      % Concatenate the loner data onto the existing vectors for next state
      cellY = [cellY; lonersY];
      cellX = [cellX; lonersX];
      cellStates = [cellStates; lonerStates];
    endif

    % Build the sparse matrix from the triple of
    %   y-positions, x-positions and cell states
    %   and set its dimensions to "totalHeight" and "totalWidth"
    worldState{next} = sparse(
                              cellY, cellX, cellStates,
                              totalHeight, totalWidth);


    % Change focus to track the latest up-to-date state matrix
    %   i.e. in worldState{now}
    now = next;

    if gen == 1 || gen == numGens
      % Before moving on to the 2nd generation, or after drawing the last gen
      pause(1); %   pause for a bit to allow initial or end state to be seen
    endif

  endwhile % End of game-loop

  % Save stored frames to .gif file.
  %   This is done outside the game-loop to prevent huge delay in plotting
  %   as the increase in time requirement compounds the higher the no of frames
  writeFramesToGif(recordInterval, im, filename);

  fprintf("Game run for %s complete\n\n", worldName);

endfunction
