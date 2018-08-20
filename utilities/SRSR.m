
function [im_SR] = SRSR(im_l,XH,XL,upscale,patch_size,overlap,tau)

im_l = double(im_l);
[imrow imcol nTraining] = size(XH);

Img_SUM      = zeros(imrow,imcol);
overlap_FLAG = zeros(imrow,imcol);

Lx = ceil((imrow-overlap)/(patch_size-overlap));  %%% the patch 
Ly = ceil((imcol-overlap)/(patch_size-overlap));  %%% ¿é×ø±ê·¶Î§

numm = 0;
% hallucinate the HR patch by patch
for li = 1:Lx
   for lj = 1:Ly     

        BlockSize = GetCurrentBlockSize(imrow,imcol,patch_size,overlap,li,lj);    
        BlockSizeS = GetCurrentBlockSize(imrow/upscale,imcol/upscale,patch_size/upscale,overlap/upscale,li,lj);  
        
        im_l_patch = im_l(BlockSizeS(1):BlockSizeS(2),BlockSizeS(3):BlockSizeS(4));           % extract the patch at position£¨li,lj£©of the input LR face     
        im_l_patch = double(reshape(im_l_patch,patch_size*patch_size/(upscale*upscale),1));   % Reshape 2D image patch into 1D column vectors   
        
        XF = Reshape3D(XH,BlockSize);    % reshape each patch of HR face image to one column
        X  = Reshape3D(XL,BlockSizeS);   % reshape each patch of LR face image to one column

        % represent the LR patch at  position£¨li,lj£©using SR 
        x0 = zeros(nTraining,1);
        w = l1eq_pd(x0, X, [], im_l_patch, 1);
        % obtain the HR patch with the same weight vector w
        Img = XF*w;      
        
        % integrate all the LR patch        
        Img = reshape(Img,patch_size,patch_size);
        Img_SUM(BlockSize(1):BlockSize(2),BlockSize(3):BlockSize(4))      = Img_SUM(BlockSize(1):BlockSize(2),BlockSize(3):BlockSize(4))+Img;
        overlap_FLAG(BlockSize(1):BlockSize(2),BlockSize(3):BlockSize(4)) = overlap_FLAG(BlockSize(1):BlockSize(2),BlockSize(3):BlockSize(4))+1;
    end
end
%  averaging pixel values in the overlapping regions
im_SR = Img_SUM./overlap_FLAG;

