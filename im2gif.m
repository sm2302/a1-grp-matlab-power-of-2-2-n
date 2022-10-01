function im2gif (im, filename)

  % This function creates a .gif animated image file from the game states
  %
  % Input arguments:
  %   -             im -- 1-dimensional cell array containing im data of frames
  %                         extracted from the figure the game is drawn on
  %   -       filename -- String which will be the filename e.g. "Game.gif"

  fullname = sprintf("%s.gif",filename);

  endIdx = length(im);
  for idx = 1:endIdx

    fprintf("Writing frames to GIF file. Progress: %.1f%% (%d/%d)\n",
              idx/endIdx*100, idx, endIdx);

    % Convert the frame from rgb->indexed image
    [A,map] = rgb2ind(im{idx});

    % Use distinct DelayTimes for first and last frames
    if idx == 1 % first frame
      imwrite(A,map,fullname,"gif","LoopCount",Inf,"DelayTime",0.1);
    else
      imwrite(A,map,fullname,"gif","WriteMode","append","DelayTime",0.1);
    end

  endfor

  % Inform progress thru command window
  fprintf("Writing frames to %s complete.\n", fullname);

endfunction
