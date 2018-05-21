
function [im_SR] = TLcR_RL(im_l,YH,YL,upscale,patch_size,overlap,window,tau,K)

[imrow, imcol, nTraining] = size(YH);
Img_SUM      = zeros(imrow,imcol);
overlap_FLAG = zeros(imrow,imcol);

U = ceil((imrow-overlap)/(patch_size-overlap));  
V = ceil((imcol-overlap)/(patch_size-overlap)); 

for i = 1:U
    fprintf('.');
     for j = 1:V  

        % obtain the current patch position
        BlockSize  =  GetCurrentBlockSize(imrow,imcol,patch_size,overlap,i,j);    
        if size(YL,1) == size(YH,1)
            BlockSizeS =  GetCurrentBlockSize(imrow,imcol,patch_size,overlap,i,j);  
        else
            BlockSizeS =  GetCurrentBlockSize(size(YL,1),size(YL,2),patch_size/upscale,overlap/upscale,i,j);  
        end
        
        % obtain the current patch feature
        im_l_patch =  im_l(BlockSizeS(1):BlockSizeS(2),BlockSizeS(3):BlockSizeS(4));           % extract the patch at position£¨i,j£©of the input LR face     
        im_l_patch =  im_l_patch(:);   
        im_l_patch = im_l_patch-mean(im_l_patch);
        
        % obtain the LR and HR training patches
        padpixel = (window-patch_size)/2; % 2 is the step size
        XF = Reshape3D_20Connection(YH,BlockSize,padpixel);
        X  = Reshape3D_20Connection(YL,BlockSizeS,padpixel);
        
        % obtain the LR training patch feature
        X = X-repmat(mean(X),size(X,1),1);
      
        % calculate the distances between current patch and the LR training patches
        nframe =  size(im_l_patch',1);
        nbase  =  size(X',1);
        XX     =  sum(im_l_patch'.*im_l_patch', 2);        
        SX     =  sum(X'.*X', 2);
        D      =  repmat(XX, 1, nbase)-2*im_l_patch'*X+repmat(SX', nframe, 1);
        
        % thresholding      
        [val,index]=sort(D);        
        Xk  = X(:,index(1:K));        
        XFk = XF(:,index(1:K));      
        Dk = D(index(1:K));
        
        % Compute the optimal weight vector  for the input LR image patch  with the LR training image patches at position£¨i,j£©
        z   =  Xk' - repmat(im_l_patch', K, 1);         
        C   =  z*z';                                                
        C   =  C + tau*diag(Dk)+eye(K,K)*(1e-6)*trace(C);   
        w   =  C\ones(K,1);  
        w   =  w/sum(w);         
       
        % obtain the HR patch with the same weight vector w
        Img  =  XFk*w; 
        
        % integrate all the LR patch        
        Img  =  reshape(Img,patch_size,patch_size);
        Img_SUM(BlockSize(1):BlockSize(2),BlockSize(3):BlockSize(4))      = Img_SUM(BlockSize(1):BlockSize(2),BlockSize(3):BlockSize(4))+Img;
        overlap_FLAG(BlockSize(1):BlockSize(2),BlockSize(3):BlockSize(4)) = overlap_FLAG(BlockSize(1):BlockSize(2),BlockSize(3):BlockSize(4))+1;
    end
end
%  averaging pixel values in the overlapping regions
im_SR = Img_SUM./overlap_FLAG;
fprintf('\n');

