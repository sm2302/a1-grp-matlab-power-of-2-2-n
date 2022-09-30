function plotGrid (A, shape, label, markerScale = 1, titleScale = 1)

  baseMarkerSize = 500;

  switch shape

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

  title(['\fontsize{', sprintf("%d",44*titleScale), '}', label]);
  drawnow;

endfunction
