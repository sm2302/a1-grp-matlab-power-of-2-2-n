function writeFramesToGif (recordInterval, im, filename)

  % This function creates a .gif animated image file from the game states
  %
  % Input arguments:
  %   - recordInterval -- Vector of size 2 containing lower and upper bounds
  %                         of generation numbers to be saved to the gif file
  %   -             im -- 1-dimensional cell array containing im data of frames
  %                         extracted from the figure the game is drawn on
  %   -       filename -- String which will be the filename e.g. "Game.gif"

  % Make sure the recordInterval is not [-1 -1] i.e. not opted out from recording
  if all(recordInterval > 0)
    % Inform thru command window
    fprintf("Creating %s", filename);
  else
    return;
  endif

  endIdx = 1 + recordInterval(2) - recordInterval(1);
  for idx = 1:endIdx

    fprintf("Writing frames to GIF file. Progress: %.1f%% (%d/%d)\n",
              idx/endIdx*100, idx, endIdx);

    % Convert the frame from rgb->indexed image
    [A,map] = rgb2ind(im{idx});

    % Use distinct DelayTimes for first and last frames
    if idx == 1 % first frame
      imwrite(A,map,filename,"gif","LoopCount",Inf,"DelayTime",0.5);
    elseif idx == endIdx % last frame
      imwrite(A,map,filename,"gif","WriteMode","append","DelayTime",0.5);
    else
      imwrite(A,map,filename,"gif","WriteMode","append","DelayTime",0.1);
    end

  endfor

  if all(recordInterval > 0)
    % Inform progress thru command window
    fprintf("Writing frames to %s complete.\n", filename);
  endif

endfunction
