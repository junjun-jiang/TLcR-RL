
function [neighborhood W] = NN(x,X,K)



% STEP1: COMPUTE PAIRWISE DISTANCES & FIND NEIGHBORS
x = double(x);
n2 = dist2(x', X');
[value index] = sort(n2);
neighborhood = index(1:K);

% STEP2: SOLVE FOR RECONSTRUCTION WEIGHTS
tol=1e-3;
z = X(:,neighborhood)-repmat(x,1,K); % shift ith pt to origin
C = z'*z;                                        % local covariance
C = C + eye(K,K)*tol*trace(C);                   % regularlization (K>D)
W = C\ones(K,1);                           % solve Cw=1
W = W/sum(W);                  % enforce sum(w)=1



function n2 = dist2(x, c)
%DIST2	Calculates squared distance between two sets of points.
%
%	Description
%	D = DIST2(X, C) takes two matrices of vectors and calculates the
%	squared Euclidean distance between them.  Both matrices must be of
%	the same column dimension.  If X has M rows and N columns, and C has
%	L rows and N columns, then the result has M rows and L columns.  The
%	I, Jth entry is the  squared distance from the Ith row of X to the
%	Jth row of C.
%
%	See also
%	GMMACTIV, KMEANS, RBFFWD
%

%	Copyright (c) Ian T Nabney (1996-2001)

[ndata, dimx] = size(x);
[ncentres, dimc] = size(c);
if dimx ~= dimc
	error('Data dimension does not match dimension of centres')
end

n2 = (ones(ncentres, 1) * sum((x.^2)', 1))' + ...
  ones(ndata, 1) * sum((c.^2)',1) - ...
  2.*(x*(c'));

% Rounding errors occasionally cause negative entries in n2
if any(any(n2<0))
  n2(n2<0) = 0;
end