function [XH XL] = Training_LH(upscale,nTraining)
%%% construct the HR and LR training pairs from the FEI face database
disp('Constructing the HR-LR training set...');
psf         = fspecial('average', [4 4]); 
for i=1:nTraining
    %%% read the HR face images
    strh = strcat('.\trainingFaces\',num2str(i),'_h.jpg');    
    HI = double(imread(strh)); 
   
    %%% obtain the LR images
    LI    = imfilter(HI,psf);
    LI    = imresize(LI,1/upscale,'bicubic'); 
    LI = imresize(LI,size(HI));
    
    XL(:,:,i) = LI; 
    XH(:,:,i) = (HI-LI);

end

disp('done.');