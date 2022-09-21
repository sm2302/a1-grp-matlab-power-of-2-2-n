function [grid, birth, life, startState, numGens, worldName, recordInterval] = validateAndSetDefaultArgs (grid, birth, life, startState, numGens, worldName, recordInterval)

  % This function is not meant to be used directly. It is for validating
  %   arguments and setting default values in the function runGame()
  %
  % Input values: Same input values for the runGame() function
  %
  % Output values: Same values passed in, except generally those set as -1
  %                  in which case there would be a warning and the argument(s)
  %                  would be replaced with a default value(s)

  % Record which args use default values; State in just one warning message
  warnDG = false; warnDBL = false; warnDSS = false; warnDNG = false; warnDWN = false;

  % Set grid to 'sqr' if none specified
  if strcmp(grid,'default')
    grid = 'sqr';
    warnDG = true;
  endif

  switch grid
    % Depending on the grid argument, initialize:
    %   - range of acceptible birth & life values (possible neighbours count)
    %   - default values for - birth,
    %                        - life, and
    %                        - startState's height, width & density
    % Also, validate the grid argument

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

  % Check if default argument for birth and life;
  %   Only assume default if both birth and life args are -1 simultaneously
  if all([birth, life] == -1)
    birth = dBirth; life = dLife;
    warnDBL = true;
  % If not default values, validate birth and date argument
  elseif any([birth, life] < nbrRange(1)) || any([birth, life] > nbrRange(2))
    error(sprintf(
      'Invalid birth or life argument. Valid: %d <= arg <= %d',
      nbrRange(1), nbrRange(2)));
  endif


  % Check if default argument for startState
  %   Only assume default if it's not a matrix of size greater than [1, 1]
  if all(size(startState) == [1 1])
    startState = sprand(dStartState(1), dStartState(2), dStartState(3));
    warnDSS = true;
  endif
  % Assume any other matrix to be valid


  % Check if default argument for numGens
  if numGens == -1
    numGens = Inf;
    warnDNG = true;
  % If not default, check that it is at least 1
  elseif numGens < 1
    error('Invalid numGens passed. Valid: numGens > 0');
  endif

  if strcmp(worldName, 'default')
    worldName = dWorldName;
  endif


  % Show warning message for default values
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

##endfunction
