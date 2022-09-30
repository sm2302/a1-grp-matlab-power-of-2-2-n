function A1 = stepLife(A0)

  [h, w] = size(A0);

  % Number of alive cells to roughly estimate room to allocate for A1 and N elems
  ncAlive = nnz(A0);

  % Initialize empty matrices N & A1
  N = spalloc(h, w, ncAlive*4); % each cell's number of neighbours
  A1 = spalloc(h, w, ncAlive); % each cell's state in the next gen

  % Each alive cell ("1"s in A0) will add 1 to its neighbouring cell's N value
  N += conv2(A0, [1 1 1;
                  1 0 1;
                  1 1 1], 'same');

  % Apply birth rule (B3)
  A1 += (~A0.*N == 3);

  % Apply survival rule (S23)
  A1 += (A0.*N == 2) + (A0.*N == 3);

endfunction
