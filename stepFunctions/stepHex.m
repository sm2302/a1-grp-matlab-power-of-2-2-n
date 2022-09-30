function A1 = stepHex (A0)

  % Number of alive cells to roughly estimate room to allocate for A1 and N elems
  ncAlive = nnz(A0);

  % Initialize empty matrices N & A1
  [h, w] = size(A0);
  N = spalloc(h, w, ncAlive*3); % each cell's number of neighbours
  A1 = spalloc(h, w, ncAlive); % each cell's state in the next gen

  % Each alive cell ("1"s in A0) will add 1 to its neighbouring cell's N value
  N += conv2(A0.*getLattice('A', h, w), [0 1 0 1 0;
                                         1 0 0 0 1;
                                         0 1 0 1 0], 'same');

  % Apply birth rule. (B34)
  A1 += (~A0.*N == 3) + (~A0.*N == 4);

  % Apply survival rule (S234)
  A1 += (A0.*N == 2) + (A0.*N == 3) + (A0.*N == 4);
endfunction
