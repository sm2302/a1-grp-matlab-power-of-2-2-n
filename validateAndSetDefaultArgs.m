function [grid, birth, life, startState, numGens, worldName, recordInterval] = validateAndSetDefaultArgs (grid, birth, life, startState, numGens, worldName, recordInterval)

  warnDG = false; warnDBL = false; warnDSS = false; warnDNG = false; warnDWN = false;

  if strcmp(grid,'default')
    grid = 'sqr';
    warnDG = true;
  endif

  switch grid

    case 'sqr'
      nbrRange = [0, 8];
      dBirth = 3; dLife = [2, 3];
      dStartState = [100, 100, 0.1];
      dWorldName = "Square_Grid";
    case 'hex'
      nbrRange = [0, 6];
      dBirth = [3, 4]; dLife = [2, 3, 4];
      dStartState = [80, 140, 0.2];
      dWorldName = "Hexagonal_Grid";
    case 'tri'
      nbrRange = [0, 3];
      dBirth = 2; dLife = [1, 2];
      dStartState = [50, 97, 0.2];
      dWorldName = "Triangular_Grid";
    otherwise
      error(sprintf('Invalid grid shape "%s". Valid: sqr, tri, hex', grid));
  endswitch

  if all([birth, life] == -1)
    birth = dBirth; life = dLife;
    warnDBL = true;
  elseif any([birth, life] < nbrRange(1)) || any([birth, life] > nbrRange(2))
    error(sprintf(
      'Invalid birth or life argument. Valid: %d <= arg <= %d',
      nbrRange(1), nbrRange(2)));
  endif

  if all(size(startState) == [1 1])
    startState = sprand(dStartState(1), dStartState(2), dStartState(3));
    warnDSS = true;
  endif

  if numGens == -1
    numGens = Inf;
    warnDNG = true;
  elseif numGens < 1
    error('Invalid numGens passed. Valid: numGens > 0');
  endif

  if strcmp(worldName, 'default')
    worldName = dWorldName;
  endif

  if warnDG || warnDBL || warnDSS || warnDNG || warnDWN
    warnMessage = "One or more arguments unspecified or set as -1,\n";
    warnMessage = strcat(warnMessage,
    "         which will be set to default values.\n",
    "Args with default values:\n");
    if warnDG
      warnMessage = strcat(warnMessage, " - grid\n");
    endif
    if warnDBL
      warnMessage = strcat(warnMessage, " - birth\n - life\n");
    endif
    if warnDSS
      warnMessage = strcat(warnMessage, " - startingState\n");
    endif
    if warnDNG
      warnMessage = strcat(warnMessage, " - numGens\n");
    endif
    if warnDWN
      warnMessage = strcat(warnMessage, " - worldName\n");
    endif
    warning(warnMessage);
  endif

endfunction
