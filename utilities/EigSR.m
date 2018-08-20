function [SR_test] = EigSR(HR_Train,LR_Train,LR_Test,Rate)

LR_Test = LR_Test(:);
T_HR = reshape(HR_Train,size(HR_Train,1)*size(HR_Train,2),size(HR_Train,3));
T_LR = reshape(LR_Train,size(LR_Train,1)*size(LR_Train,2),size(LR_Train,3));

[nfeas Train_NUM] = size(T_HR);
[nfeas Test_NUM] = size(LR_Test);


m = mean(T_LR,2); % Computing the average face image m = (1/P)*sum(Tj's)    (j = 1 : P)
Train_Number = size(T_LR,2);

A = [];  
for i = 1 : Train_Number
    temp = double(T_LR(:,i)) - m; % Computing the difference image for each image in the training set Ai = Ti - m
    A = [A temp]; % Merging all centered images
end

L = A'*A; % L is the surrogate of covariance matrix C=A*A'.
[V D] = eig(L); % Diagonal elements of D are the eigenvalues for both L=A'*A and C=A*A'.

S=sqrt(D);
Eigenfaces = A * V*inv(S); % A: centered image vectors  这里有疑问，公式不是U=AVS^(-1)

m_h = mean(T_HR,2); % Computing the average face image m = (1/P)*sum(Tj's)    (j = 1 : P)
Train_Number = size(T_HR,2);

A_h = [];  
for i = 1 : Train_Number
    temp = double(T_HR(:,i)) - m_h; % Computing the difference image for each image in the training set Ai = Ti - m
    A_h = [A_h temp]; % Merging all centered images
end

% MatName = strcat('China_Eigenfaces_',num2str(Train_NUM),'.mat');
% load(MatName,'m','Eigenfaces','A','D','V','S','m_h','A_h');    

    D_diag = diag(D);
    for i = 1:size(D)
        PCANum = i;
        if sum(D_diag(size(D_diag)-i+1:size(D_diag)))/sum(D_diag) > Rate            
            break;
        end
    end
%     PCANum
% PCANum = Rate;

%%% 将输入图像嵌入到低分辨率主成分空间中
W = Eigenfaces(:,Train_NUM-PCANum+1:Train_NUM);
fac = pinv(W'*W)*W'*(LR_Test - repmat(m,1,Test_NUM));
%         PCAImh = W*fac+repmat(m,1,Test_NUM);

%%% 求解转换之后的高分辨率图像系数
Vv = V(:,Train_NUM-PCANum+1:Train_NUM);
Ss = S(Train_NUM-PCANum+1:Train_NUM,Train_NUM-PCANum+1:Train_NUM);
c = Vv*inv(Ss)*fac;

%%% 将系数映射到高分辨率图像，并将合成结果保存
SR_test = double(A_h)*c + repmat(m_h,1,Test_NUM);        

SR_test = reshape(SR_test,size(HR_Train,1),size(HR_Train,2));
