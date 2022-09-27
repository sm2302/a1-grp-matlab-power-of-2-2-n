function runHexGol (deadToBlue=4, blueToRed=[1 2 3 4 6], redToRed=[1 2], redToBlue=4, startState=sprand(40,70,0.07), numGens=80, worldName='GoL-Like Hex World', markerScale = 2, recordInterval = [-1 -1])

  % Validate inputs
  if any([deadToBlue, blueToRed, redToRed, redToBlue]) < 0 || any([deadToBlue, blueToRed, redToRed, redToBlue] > 6+1)
    error('Invalid birth/life rules (arg 1 to 3). Valid: 0 <= arg <= 7 (7 for never)');
  endif
  if numGens < 1
    error('Invalid numGens argument. Valid: arg > 0');
  endif
  if size(recordInterval, 1) * size(recordInterval, 2) ~= 2
    error('Invalid recordInterval argument. Valid: Array of exactly two numbers');
  endif

  % Filename in case we write figure frames to gif. Empty images cell array
  filename = sprintf('%s.gif', worldName);          im = {};

  % Save the seed in case we want to rerun the world
  %   e.g. with a previously initialized random state
  lastSeed = startState;
  save('lastSeed','lastSeed');

  % Correct for state differences (dead = 0, blue = 1, red = 2)
  startState = ceil(startState.*2);

  % Extract the size of the provided starting matrix
  [numRows, numCols] = size(startState);

  % Set aspect ratio to ensure drawn grid in sensible proportion
  aspectRatio = [1.75 1];

  neighbourIncrement = sparse([
    0 1 0 1 0; % ⬡⬢⬡⬢⬡
    1 0 0 0 1; % ⬢⬡✡⬡⬢ - neighbourhood of the hexagonal cell ✡
    0 1 0 1 0; % ⬡⬢⬡⬢⬡
  ]);

  % Count the total number of actual game cells (dead & alive)
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

  % Values for start and end of actual world cells, will be used in the loop
  rowStart = 2;
  rowEnd = numRows + 1;
  colStart = 3;
  colEnd = numCols + 2;

  % Dimensions of the world (including padding) used later in the loop
  totalHeight = numRows+2;
  totalWidth = numCols+4;

  % Assign limits such that paddings are disregarded in the displayed plot
  axesLimits = [3, numCols+2, 2, numRows+1];

  % Initialize horizontal & vertical paddings as empty row and column vectors
  padUD = sparse(1, numCols+4);
  padLR = sparse(numRows, 2);

  % Store "padded" starting state info as sparse mat in a MATLAB cell array
  worldState{1} = sparse([
          padUD        ;
  padLR, startState, padLR;
          padUD
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

    % Draw the latest state of the game world as recorded in worldState{now}
    spy(worldState{now}==1, 'hexagramb', 2*markerScale); % Draw blue cells
    hold on;
    spy(worldState{now}==2, 'hexagramr', 2*markerScale); % Draw red cells
    hold off;

    % Compute the number of living cells
    %   i.e. positions with nonzero value in the state matrix
    nCellsAlive = nnz(worldState{now});

    % Set the axis limits
    axis(axesLimits);

    % Adjust the aspect ratio to offset the gap due to marker shapes and
    %   the arrangement of cells in the hexagonal and triangular grids
    daspect(aspectRatio);

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
    sumsOfNeighbourValues = spalloc(totalHeight, totalWidth, nCellsAlive*2);

    % Extract 2 column vectors containing x and y positions of living cells
    [livingCellsY, livingCellsX, livingCellsState] = find(worldState{now});

    % Iterate through each living cell's positions
    for ind = 1:nCellsAlive
      y = livingCellsY(ind); x = livingCellsX(ind);
      % Add state value to the cell neighbours' existing neighbour count
      %   where blue = 1, red = 2.
      sumsOfNeighbourValues(y-1:y+1, x-2:x+2) += neighbourIncrement.*livingCellsState(ind);
    endfor% Set all elements on the 4 edges i.e. paddings to 0 as these should not be
    %   accessed
    sumsOfNeighbourValues([1, rowEnd+1],:) = sumsOfNeighbourValues(:, [1:2, colEnd+1:colEnd+2]) = 0;

    numCellsOfInterest = nnz(sumsOfNeighbourValues);

    % Extract x and y positions of all cells that have live neighbours.
    [cellY, cellX, valNeighbours] = find(sumsOfNeighbourValues);

    % Initialize empty column vector of size numCellsOfInterest
    cellStates = zeros(numCellsOfInterest,1);

    % Decide whether the cells are alive
    % By default, they will die (i.e. if none of the conditions below are met)

    % Note that this method of computation does not work if 0 is in either
    %   the birth rule or life rule
    for ind = 1:numCellsOfInterest
      nowState = worldState{now}(cellY(ind),cellX(ind));
      if nowState == 0 % If currently dead
        % Check if numNeighbours satisfy birth rule
        if any(deadToBlue==valNeighbours(ind))
          cellStates(ind) = 1;
        endif
      elseif nowState == 1 % If currently blue
        % Check if numNeighbours satisfy blue-to-red rule
        if any(blueToRed==valNeighbours(ind))
          cellStates(ind) = 2;
        endif
      elseif nowState == 2 % If currently red

        % Check if numNeighbours satisfy red-to-red rule
        if any(redToRed==valNeighbours(ind))
          cellStates(ind) = 2;

        % Check if numNeighbours satisfy red-to-blue rule
        elseif any(redToRed==valNeighbours(ind))
          cellStates(ind) = 1;
        endif

      endif
    endfor

    % Build the sparse matrix from the triple of
    %   y-positions, x-positions and cell states
    %   and set its dimensions to "totalHeight" and "totalWidth"
    %   nCellsAlive as an estimate on how many nonzeros to allocate space for
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
