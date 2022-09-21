function runGame (birth=3, life=[2, 3], startState=sprand(100,100, 0.1), numGens=Inf)

  % NOTE:
  %   Marker scale is just 1 for default figure size,
  %   However, when the figure window is maximized, 2 is more suitable.
  markerScale = 1;

  [numRows, numCols] = size(startState);

  nCellsTotal = numRows*numCols;

  % Adjusting the aspect ratio corrects any possible disproportion in
    %   spacing from auto-stretching
  aspectRatio = [1 1];

  % Assign limits such that paddings are disregarded in the displayed plot
  axesLimits = [2, numCols+1, 2, numRows+1];

  % Initialize horizontal & vertical paddings as empty row and column vectors
  padUD = zeros(1, numCols+2);
  padLR = zeros(numRows, 1);

  % Store "padded" starting state info as sparse mat in a MATLAB cell array
  worldState{1} = sparse([
          padUD        ;
  padLR, startState, padLR;
          padUD
  ]);

  % Initialize another sparse matrix for storing next generation state values
  worldState{2} = sparse(numRows+2, numCols+2);

  % Using the a common (i.e. worldState) cell array,
  %   both matrices can easily be used interchangeably such that
  %     1st iteration: worldState{1} is displayed, worldState{2} is written
  %     2nd iteration: worldState{2} is displayed, worldState{1} is rewritten
  %     3rd iteration: worldState{1} is redisplayed, worldState{2} is rewritten
  %     and so on...

  figure(1);

  now = 1; % Variable to track the matrix currently holding the active state

  gen = 0;

  while gen < numGens

    gen = gen + 1;

    next = mod(now, 2) + 1;

    pause(0.05);

    % Draw the latest state of the game world
    spy(worldState{now}, 'sk', 1*markerScale);

    nCellsAlive = nnz(worldState{now});

    axis(axesLimits);

    daspect(aspectRatio);

    title(sprintf(
      '%dth generation - living: %d/%d',
      gen, nCellsAlive, nCellsTotal));

    axis off;

    rowRange = 2:numRows+1;
    colRange = 2:numCols+1;

    for r = rowRange
      for c = colRange
        neighbourhood = worldState{now}(r-1:r+1, c-1:c+1);
        neighbourhood(2,2) = 0;

        numLiveNeighbours = nnz(neighbourhood);

        if any(birth==numLiveNeighbours)
          worldState{next}(r, c) = 1;
        elseif any(life==numLiveNeighbours)
          worldState{next}(r, c) = worldState{now}(r, c);
        else
          worldState{next}(r, c) = 0;
        endif
      endfor
    endfor

    now = next;

  endwhile
endfunction
