function fig2png (fig, filename)

  % This function creates a .png image file from the figure whos handle is passed
  %
  % Input arguments:
  %   -            fig -- The handle of the figure to save as theimage
  %   -       filename -- String which will be the filename e.g. "Game.gif"

  % Extract the frame from the figure
  frame = getframe(fig);
  % Convert the frame to an im
  im = frame2im(frame);
  % Extract an indexed image from the im
  [A,map] = rgb2ind(im);
  % Write the image to a .png file
  imwrite(A, map, sprintf("%s.png", filename));

  % Inform progress thru command window
  fprintf("Writing frame to %s.png complete.\n", fullname);

endfunction
