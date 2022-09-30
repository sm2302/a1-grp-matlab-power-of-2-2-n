function L = getLattice(type, h, w)
  % This function file generates a checkerboard pattern of dimensions h*w
  %   in the form of a sparse matrix
  %
  % Input:
  %   - type -- Single character from {'A','B'}
  %             This will decide whether the lattice starts from 0 or 1
  %   - h    -- Integer - Height of the output lattice.
  %   - w    -- Integer - Width of the output lattice.
  %
  % Output:
  %   - L    -- Sparse matrix of size h by w with the pattern show below
  switch type
    case 'A'
      L = repmat(sparse([1 0; 0 1]), ceil(h/2), ceil(w/2))(1:h, 1:w);
      % 1 0 1 0 1 ...
      % 0 1 0 1 0 ...
      % 1 0 1 0 1 ... and so on
      % 0 1 0 1 0 ...
      % 1 0 1 0 1 ...
    case 'B'
      L = repmat(sparse([0 1; 1 0]), ceil(h/2), ceil(w/2))(1:h, 1:w);
      % 0 1 0 1 0 ...
      % 1 0 1 0 1 ...
      % 0 1 0 1 0 ... and so on
      % 1 0 1 0 1 ...
      % 0 1 0 1 0 ...
    otherwise
      error("Invalid firt argument type. Valid types are 'A' and 'B'");
  endswitch
endfunction
