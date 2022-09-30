function A1 = stepHex3 (A0)

  % Number of alive cells to roughly estimate room to allocate for A1 and N elems
  ncAlive = nnz(A0);

  % Initialize empty matrices N & A1
  [h, w] = size(A0);
  N = spalloc(h, w, ncAlive*3); % each cell's neighbouring state values N
  A1 = spalloc(h, w, ncAlive); % each cell's state in the next gen

  % Each alive cell will add its state value to its neighbouring cell's N value

  N += conv2((A0==1).*getLattice('A', h, w), [0 1 0 1 0;
                                              1 0 0 0 1; % Blue cell, state 1
                                              0 1 0 1 0], 'same');

  N += conv2((A0==2).*getLattice('A', h, w), [0 2 0 2 0;
                                              2 0 0 0 2; % Red cell, state 2
                                              0 2 0 2 0], 'same');

  % Apply birth rule. (B4)
  A1 += (~A0.*N == 4);

  % Apply blue-to-red rule (Sbr12346)
  A1 += 2*(((A0==1).*N >= 1) .* ((A0==1).*N <=4) + ((A0==1).*N == 6));

  % Apply red-to-red rule (Srr12)
  A1 += 2*(((A0==2).*N == 1) + ((A0==2).*N ==2));

  % Apply red-to-blue rule (Srb4)
  A1 += ((A0==2).*N ==4);
endfunction
