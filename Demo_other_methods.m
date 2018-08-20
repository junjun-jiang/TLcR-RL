
clc;close all;
clear all;
addpath('.\utilities');
addpath('.\utilities\Optimization');

% set parameters
nrow        = 120;        % rows of HR face image
ncol        = 100;        % cols of LR face image
nTraining   = 360;        % number of training sample
nTest       = 40;         % number of ptest sample
upscale     = 4;          % upscaling factor 
BlurWindow  = 4;          % size of an averaging filter 
patch_size  = 12;         % image patch size
overlap     = 4;          % the overlap between neighborhood patches
method      = 'LINE';     % NE: NE based method, Chang et al
                          % EigTran: EigTran based method, Wang et al
                          % SR: Sparse Representation method, Jung et al
                          % LSR: Leaest Squares Regression method, Ma et al  
                          % LcR: Locality-constrained Representation method, Jiang et al.                   
                          % LINE: Locality-constrained Iterative Neighbor Embedding method, Jiang et al.

% construct the HR and LR training pairs from the FEI face database
%[YH YL] = Training_LH(upscale,BlurWindow,nTraining);

load('FEI_YH_YL_Small2.mat','YH','YL')
YH = double(YH);
YL = double(YL);

%% face SR for each test image
for TestImgIndex = 1:nTest

    fprintf('\nProcessing  %d _test.jpg\n', TestImgIndex);

    % read ground truth of one test face image
    strh = strcat('.\testFaces\',num2str(TestImgIndex),'_test.jpg');
    im_h = imread(strh);

    % generate the input LR face image by smooth and down-sampleing
    w=fspecial('average',[BlurWindow BlurWindow]);
    im_s = imfilter(im_h,w);
    im_l = imresize(im_s,1/upscale,'bicubic');
    
    % add noise to the LR face image (Optional)
    v    =  0;seed   =  0;randn( 'state', seed );
    noise      =   randn(size( im_l ));
    noise      =   noise/sqrt(mean2(noise.^2));
    im_l       =   double(im_l) + v*noise;   
    im_l       =   double(im_l);    
%     figure,imshow(im_l);title('input LR face');

    % face hallucination via LcR
    switch method
        case 'NE'
            K = 75;
            [im_SR] = NESR(im_l,YH,YL,upscale,patch_size,overlap,K);
        case 'EigTran'
            ratio = 0.99;
            [im_SR] = EigSR(YH,YL,im_l,ratio);
        case 'SR'
            tau = 1;
            [im_SR] = SRSR(im_l,YH,YL,upscale,patch_size,overlap,tau);
        case 'LSR'
            [im_SR] = LSRSR(im_l,YH,YL,upscale,patch_size,overlap);
        case 'LcR'
            tau = 0.04;
            [im_SR] = LcRSR(im_l,YH,YL,upscale,patch_size,overlap,tau);
        case 'LINE'
            im_b = imresize(im_l, [nrow, ncol], 'bicubic');
            tau = 5e-4;
            K = 75;
            maxiter = 5;
            [im_SR] = LINESR(im_l,im_b,YH,YL,upscale,patch_size,overlap,tau,K,maxiter);
    end  
    
    % bicubic interpolation for reference
    im_b = imresize(im_l, [nrow, ncol], 'bicubic');
    
    % compute PSNR and SSIM for Bicubic and our method
    bb_psnr(TestImgIndex) = psnr(im_b,im_h);
    bb_ssim(TestImgIndex) = ssim(im_b,im_h);
    sr_psnr(TestImgIndex) = psnr(im_SR,im_h);
    sr_ssim(TestImgIndex) = ssim(im_SR,im_h);

    % display the objective results (PSNR and SSIM)
    fprintf('PSNR for Bicubic Interpolation: %f dB\n', bb_psnr(TestImgIndex));
    fprintf(['PSNR for ',method,' Recovery: %f dB\n'], sr_psnr(TestImgIndex));
    fprintf('SSIM for Bicubic Interpolation: %f dB\n', bb_ssim(TestImgIndex));
    fprintf(['SSIM for ',method,' Recovery: %f dB\n'], sr_ssim(TestImgIndex));

    % show the images
%     figure, imshow(im_b);
%     title('Bicubic Interpolation');
%     figure, imshow(uint8(im_SR));
%     title('LcR Recovery');
    
    % save the result
    strw = strcat('./results/',num2str(TestImgIndex),'_',char(method),'.bmp');
    imwrite(uint8(im_SR),strw,'bmp');
end
%%

fprintf('===============================================\n');
fprintf('Average PSNR of Bicubic: %f\n', sum(bb_psnr)/nTest);
fprintf('Average PSNR of our method: %f\n', sum(sr_psnr)/nTest);
fprintf('Average SSIM of Bicubic: %f\n', sum(bb_ssim)/nTest);
fprintf('Average SSIM of our method: %f\n', sum(sr_ssim)/nTest);
fprintf('===============================================\n');


