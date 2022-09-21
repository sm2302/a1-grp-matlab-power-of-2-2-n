function runGame (birth=3, life=[2, 3], startState=sprand(100,100, 0.1), numGens=Inf)

  markerScale = 1;

  [numRows, numCols] = size(startState);

  nCellsTotal = numRows*numCols;

  aspectRatio = [1 1];

  axesLimits = [2, numCols+1, 2, numRows+1];

  padUD = zeros(1, numCols+2);
  padLR = zeros(numRows, 1);

  worldState{1} = sparse([
          padUD        ;
  padLR, startState, padLR;
          padUD
  ]);

  worldState{2} = sparse(numRows+2, numCols+2);

  figure(1);

  now = 1;

  gen = 0;

  while gen < numGens

    gen = gen + 1;

    next = mod(now, 2) + 1;

    pause(0.05);

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
