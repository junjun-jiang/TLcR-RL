function Y = Reshape3D_20Connection(X,B,stepsize,padpixel)

patch_size = B(2)+1-B(1);
% stepsize = 2;
Y = [];
for i = -padpixel:stepsize:padpixel
    for j = -padpixel:stepsize:padpixel
        if i==0&j==0
            temp = reshape(X(B(1):B(2),B(3):B(4),:),patch_size*patch_size,size(X,3));
        elseif B(1)+i>0 && B(1)+i+patch_size-1<=size(X,1)&&B(3)+j>0 && B(3)+j+patch_size-1<=size(X,2)
            tB = [B(1)+i B(1)+i+patch_size-1 B(3)+j B(3)+j+patch_size-1];
            tX = X(tB(1):tB(2),tB(3):tB(4),:);
            tX = reshape(tX,patch_size*patch_size,size(X,3));
            Y = [Y tX];
        end
    end
end

Y = [temp Y];
