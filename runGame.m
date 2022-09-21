function runGame (grid='default', birth=-1, life=-1, startState=-1, numGens=-1, worldName='default', recordInterval = [-1 -1])

  % This program runs, and illustrates, a Game of Life world with user-specified
  % (or default) properties. It makes use of a WHILE-LOOP to:
  %   - draw each generation of the game world via. the spy() function
  %   - compute the state of the generation after the one that has been drawn
  % Game state data is stored in TWO SPARSE MATRICES:
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
  %
  % Default values (if left empty or set as negative):
  %
  %   arg \ grid | sqr          hex         tri       |
  %   -----------|------------------------------------|
  %   birth      | 3            [3 4]       2         |
  %   life       | [2 3]        [2 3 4]     [1 2]     |
  %   startState | 100,100,0.1  80,140,0.2  50,97,0.2 | (via. sprand)
  %   numGens    | Inf          Inf         Inf       |


  % Validate input args and assign default values where appropriate
  %   Taking this portion of the code out of this function script keeps it neat
  [grid, birth, life, startState, numGens, worldName recordInterval] = validateAndSetDefaultArgs(grid, birth, life, startState, numGens, worldName,  recordInterval);

  % Filename in case we save file to gif
  filename = sprintf('%s.gif', worldName);

  % Save the seed in case we want to rerun the world.
  lastSeed = startState;
  save('lastSeed','lastSeed');

  % NOTE:
  %   Marker scale is just 1 for default figure size,
  %   However, when the figure window is maximized, 2.5 is more suitable.
  markerScale = 1;


  % Extract the size of the provided starting matrix
  [numRows, numCols] = size(startState);


  % The world is padded by one unit of space on all 4 boundaries
  %   which are not game cells, hence do not react according to the game rules,
  %   and exists only to prevent out-of-bounds access when counting neighbours
  % Only the horizontal padding is variable (as it is not 1 in the hex grid)
  numPadding = 1;


  % Total number of possible cells - computed differently in a hex grid
  nCellsTotal = numRows*numCols;


  % Grid-type dependent variables
  switch grid

    % Adjusting the aspect ratio corrects any possible disproportion in
    %   spacing from auto-stretching or due to the shape of the plot markers
    %   and the arrangement of cells in the hexagonal and triangular grids

    case 'sqr'
      aspectRatio = [1 1];

    case 'hex'
      aspectRatio = [1.75 1];

      % Because not all matrix positions are used in a hexagonal grid
      %   nCellsTotal computation and numPadding is different.

      % There is extra horizontal padding in hex grid
      % as neighbours are necessarily distanced 2-units horizontally, as such:
      %   00⬢⬡⬢⬡⬢⬡⬢⬡⬢00
      %   00⬡⬢⬡⬢⬡⬢⬡⬢⬡00 - where ⬢ represents every game cell (dead or alive)
      %   00⬢⬡⬢⬡⬢⬡⬢⬡⬢00 - and ⬡ every unused position in the matrix
      %   00⬡⬢⬡⬢⬡⬢⬡⬢⬡00

      numPadding = 2;

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
      aspectRatio = [1.85 1];

      % Prepare filter for identifying triangle type based on position
      % Types being either downward-facing or upward-facing
      for r=2:numRows+1          %  dTF   uTF  - example as used in 3x3 world
        for c=2:numCols+1        % 00000 00000    00000
          offset = mod(r+c, 2);  % 01010 00100    0▼▲▼0
          dTF(r,c) = 1 - offset; % 00100 01010    0▲▼▲0
          uTF(r,c) = offset;     % 01010 00100    0▼▲▼0
        endfor                   % 00000 00000    00000
      endfor
      % Force the last row's & column's existance in these matrices
      dTF(numRows+2,numCols+2) = 0;
      uTF(numRows+2,numCols+2) = 0;

  endswitch

  % Other variables from common computations:

  % Assign limits such that paddings are disregarded in the displayed plot
  axesLimits = [numPadding+1, numPadding+numCols, 2, numRows+1];

  % Initialize horizontal & vertical paddings as empty row and column vectors
  padUD = zeros(1, numCols+2*numPadding);
  padLR = zeros(numRows, numPadding);

  % Store "padded" starting state info as sparse mat in a MATLAB cell array
  worldState{1} = sparse([
          padUD        ;
  padLR, startState, padLR;
          padUD
  ]);

  % Initialize another sparse matrix for storing next generation state values
  worldState{2} = sparse(numRows+2, numCols+2*numPadding);

  % Using the a common (i.e. worldState) cell array,
  %   both matrices can easily be used interchangeably such that
  %     1st iteration: worldState{1} is displayed, worldState{2} is written
  %     2nd iteration: worldState{2} is displayed, worldState{1} is rewritten
  %     3rd iteration: worldState{1} is redisplayed, worldState{2} is rewritten
  %     and so on...

  figure(1);

  now = 1; % Variable to track the matrix currently holding the active state

  gen = 0; % Variable to track the number of elapsed generations

  while gen < numGens

    gen = gen + 1;

    % Get the number representing the next state matrix to be written onto
    %   i.e. worldState{next} =/= worldState{now}
    next = mod(now, 2) + 1;

    %pause(0.05); % Pause for a set duration to allow the world to be plotted

    % According to grid type:
    switch grid
      % Draw the latest state of the game world as recorded in worldState{now}

      % About markerScale: see info @ top of script

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

    % Compute the number of living cells
    %   i.e. positions with nonzero value in the state matrix
    nCellsAlive = nnz(worldState{now});

    % Set the axis limits
    axis(axesLimits);

    % Adjust the aspect ratio to offset the gap due to marker shapes and
    %   the arrangement of cells in the hexagonal and triangular grids
    daspect(aspectRatio);

    title(strcat(worldName, sprintf(
      ' - %dth generation - living: %d/%d',
      gen, nCellsAlive, nCellsTotal)));

    % Axis numbers not required in this project
    axis off;


    % Save images if needed;
    drawnow;
    % Extract frame from figure,
    frame = getframe(figure(1));
    im = frame2im(frame);
    % and convert it from rgb>grayscale->indexed image
    [A,map] = gray2ind(rgb2gray(im));
    % Create the gif if valid recordInterval set
    % Use distinct DelayTimes for first and last frames
    if gen == recordInterval(1)
      imwrite(A,map,filename,"gif","LoopCount",Inf,"DelayTime",0.25);
    elseif gen > recordInterval(1) && gen < recordInterval(2)
      imwrite(A,map,filename,"gif","WriteMode","append","DelayTime",0.1);
    elseif gen == recordInterval(2)
      imwrite(A,map,filename,"gif","WriteMode","append","DelayTime",0.25);
    end


    % Compute the next world state, and write the values in worldState{next}:

    % Default vectors to be used for iterating through each cell
    rowRange = 2:numRows+1;
    colRange = 2:numCols+1;

    for r = rowRange
      if grid=='hex'
        % If it's a hex grid, override the default colRange vector
        %   as its cells are arranged staggered, as shown below,
        %   and should be accessed as such.
        %   --⬡-⬡-⬡-⬡ ...
        %   ---⬡-⬡-⬡- ... where ⬡ is every actual in-game position.
        %   --⬡-⬡-⬡-⬡ ...       - is every unused position in the matrix
        %   ---⬡-⬡-⬡- ...
        startIndex = 3 + mod(r, 2);
        colRange = startIndex:2:numCols+2;
      endif

      for c = colRange
        % Count the number of living neighbours of the cell.
        % Identification method of neighbours depend on the type of grid

        switch grid
          case 'sqr'
            % Extract the 3-by-3 matrix of the cell's neighbourhood
            neighbourhood = worldState{now}(r-1:r+1, c-1:c+1);
            % ... but also count itself out of the matrix
            % □ ■ ■ ■ □
            % □ ■ ⧄ ■ □      where ⧄ is the cell in question
            % □ ■ ■ ■ □            ■ is a neighbour cell
            % □ □ □ □ □
            neighbourhood(2,2) = 0;

          case 'hex'
            % Include surrounding cells i.e. cells adjacent to its 6 edges
            % ⬡ ⬡ ⬢ ⬢ ⬡ ⬡
            %  ⬡ ⬢ ✡ ⬢ ⬡    where ✡ is the cell in question,
            % ⬡ ⬡ ⬢ ⬢ ⬡ ⬡         ⬢ is a neighbour cell
            %  ⬡ ⬡ ⬡ ⬡ ⬡          horizontal space between are unused positions
            neighbourhood = [
              worldState{now}(r-1:2:r+1, c-1:2:c+1); % in adjacent row
              worldState{now}(r, c-2:4:c+2) % in same row
            ];

          case 'tri'
            % Use row & column numbers to determine the triangle type
            %    ^
            %   ^▼^   -  Downward pointing;  v▲v - Upward pointing
            %                                 v
            % Then, pick the corresponding neighbours (^s and v's shown above).

            if mod(r+c, 2)==0 % The triangle is downward pointing ▼
              neighbourhood = [
                worldState{now}(r, c-1:2:c+1) worldState{now}(r-1, c)
              ];
            else % The triangle is upward pointing ▲
              neighbourhood = [
                worldState{now}(r, c-1:2:c+1) worldState{now}(r+1, c)
              ];
            endif
        endswitch

        % From the array of neighbouring cells, count the living ones.
        numLiveNeighbours = nnz(neighbourhood);

        % Use the number to determine the cell's next state
        if any(birth==numLiveNeighbours)
          % Set cell state to living
          worldState{next}(r, c) = 1;
        elseif any(life==numLiveNeighbours)
          % Maintain life of an already living cell
          worldState{next}(r, c) = worldState{now}(r, c);
        else
          % Set cell state to dead
          worldState{next}(r, c) = 0;
        endif
      endfor
    endfor

    % Change focus to track the latest up-to-date state matrix
    %   i.e. in worldState{now}
    now = next;

  endwhile
endfunction
