function Y = Reshape3D(X,BlockSize)

patch_size = BlockSize(2)+1-BlockSize(1);
tX = X(BlockSize(1):BlockSize(2),BlockSize(3):BlockSize(4),:);
Y = reshape(tX,patch_size*patch_size,size(X,3));