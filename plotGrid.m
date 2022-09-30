function plotGrid (A, shape, label, markerScale = 1, titleScale = 1)

  % This function handles procedures related to figure drawing
  %
  % Input arguments:
  %           A - A sparse matrix representing the current cell states to be plotted
  %       shape - The shape of a the grid
  %       lavel - Title to display on top of the plot
  % markerScale - Multiplier for the base marker size. Edit to resize in case too big/small
  %  titleScale - Multiplier for fontsize on the title text. Edit to resize.

  % A somewhat big number because it would be divided by the height in pixels of the figure
  baseMarkerSize = 500;

  switch shape

    % Aspect ratio, marker size, and plot marker used would depend on the grid used
    case "square"

      spy(A, '*k', baseMarkerSize/size(A,1)*markerScale);

      daspect([1 1]);

    case "hexagon"

      spy(A, '*k', baseMarkerSize/size(A,1)*markerScale);

      daspect([1.75 1]);

   case "hexagon3"

      markerSize = baseMarkerSize/size(A,1)*markerScale;

      spy(A==1, '*b', markerSize);
      hold on;
      spy(A==2, '*r', markerSize);
      hold off;

      daspect([1.75 1]);

    case "triangle"

      [h, w] = size(A);
      markerSize = 0.6*baseMarkerSize/h*markerScale;

      spy(A.*getLattice('A', h, w), 'vk', markerSize);
      hold on;
      spy(A.*getLattice('B', h, w), '^k', markerSize);
      hold off;

      daspect([1.3 1]);

  endswitch

  % Title with base size 44, modifiable via titleScale.
  title(['\fontsize{', sprintf("%d",44*titleScale), '}', label]);

  % Ensure that the figure is drawn before moving onto the next generation
  %   No frames skipped.
  drawnow;

endfunction
