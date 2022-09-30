function plotGrid (A, shape, label, markerScale = 1)

  baseMarkerSize = 500;

  switch shape

    case "square"

      spy(A, '*k', baseMarkerSize/size(A,1)*markerScale);

      daspect([1 1]);

    case "triangle"

      [h, w] = size(A);
      markerSize = 0.6*baseMarkerSize/h*markerScale;

      spy(A.*getLattice('A', h, w), 'vk', markerSize);
      hold on;
      spy(A.*getLattice('B', h, w), '^k', markerSize);
      hold off;

      daspect([1.3 1]);

  endswitch

  title(['\fontsize{', sprintf("%d",44*markerScale), '}', label]);
  drawnow;

endfunction
