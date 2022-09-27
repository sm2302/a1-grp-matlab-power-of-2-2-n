function writeFramesToGif (recordInterval, im, filename)

  if all(recordInterval > 0)
    fprintf("Creating %s", filename);
  else
    return;
  endif

  endIdx = 1 + recordInterval(2) - recordInterval(1);
  for idx = 1:endIdx

    fprintf("Writing frames to GIF file. Progress: %.1f%% (%d/%d)\n",
              idx/endIdx*100, idx, endIdx);

    [A,map] = rgb2ind(im{idx});

    if idx == 1 % first frame
      imwrite(A,map,filename,"gif","LoopCount",Inf,"DelayTime",0.5);
    elseif idx == endIdx % last frame
      imwrite(A,map,filename,"gif","WriteMode","append","DelayTime",0.5);
    else
      imwrite(A,map,filename,"gif","WriteMode","append","DelayTime",0.1);
    end

  endfor

  if all(recordInterval > 0)
    fprintf("Writing frames to %s complete.\n", filename);
  endif

endfunction
