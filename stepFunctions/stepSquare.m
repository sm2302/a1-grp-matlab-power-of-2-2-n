function A1 = stepSquare(A0, br, sr)

  % Number of alive cells to roughly estimate room to allocate for A1 and N elems
  ncAlive = nnz(A0);

  % Initialize empty matrices N & A1
  [h, w] = size(A0);
  N = spalloc(h, w, ncAlive*4); % each cell's number of neighbours
  A1 = spalloc(h, w, ncAlive); % each cell's state in the next gen

  % Each alive cell ("1"s in A0) will add 1 to its neighbouring cell's N value
  N += conv2(A0, [1 1 1;
                  1 0 1;
                  1 1 1], 'same');

  % Apply birth rule
  for n = br
    if n == 0
      % (~A0.*~N) is "1" where dead cells have no neighbours
      A1 += (~A0.*~N); % Append the 1's onto the matrix A1
      continue;
    endif
    % (~A0.*N == n) is "1" where dead cells have n amount of neighbours
    A1 += (~A0.*N == n); % Append the 1's onto the matrix A1
  endfor

  % Apply survival rule
  for n = sr
    if n == 0
      % (A0.*~N) is 1 where alive cells have no neighbours
      A1 += (A0.*~N);
      continue;
    endif
    % (A0.*N == n) is "1" where alive cells have n amount of neighbours
    A1 += (A0.*N == n);
  endfor

endfunction
