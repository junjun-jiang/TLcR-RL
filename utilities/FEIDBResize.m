function [] = FEIDBResize(nrow,ncol,nTraining)
%%% generate the training samples from the FEI face database
disp('Crop the FEI Database to 120*100 pixels...');
for i = 1:200    
    if i <= 100
        I1 = imread(strcat('.\frontalimages_spatiallynormalized_part1\',num2str(i),'a.jpg'));
        I2 = imread(strcat('.\frontalimages_spatiallynormalized_part1\',num2str(i),'b.jpg'));
        I1 = imresize(I1,[nrow,ncol],'bicubic');
        I2 = imresize(I2,[nrow,ncol],'bicubic');
        imwrite(I1,strcat('.\trainingFaces\',num2str(2*i-1),'_h.jpg'));
        imwrite(I2,strcat('.\trainingFaces\',num2str(2*i),'_h.jpg'));        
    end
    
    if i > 100 & i <= nTraining/2
        I1 = imread(strcat('.\frontalimages_spatiallynormalized_part2\',num2str(i),'a.jpg'));
        I2 = imread(strcat('.\frontalimages_spatiallynormalized_part2\',num2str(i),'b.jpg'));
        I1 = imresize(I1,[nrow,ncol],'bicubic');
        I2 = imresize(I2,[nrow,ncol],'bicubic');
        imwrite(I1,strcat('.\trainingFaces\',num2str(200+2*(i-100)-1),'_h.jpg'));
        imwrite(I2,strcat('.\trainingFaces\',num2str(200+2*(i-100)),'_h.jpg'));
    end
    
    if i > nTraining/2
        I1 = imread(strcat('.\frontalimages_spatiallynormalized_part2\',num2str(i),'a.jpg'));
        I2 = imread(strcat('.\frontalimages_spatiallynormalized_part2\',num2str(i),'b.jpg'));
        I1 = imresize(I1,[nrow,ncol],'bicubic');
        I2 = imresize(I2,[nrow,ncol],'bicubic');
        imwrite(I1,strcat('.\testFaces\',num2str(2*(i-nTraining/2)-1),'_test.jpg'));
        imwrite(I2,strcat('.\testFaces\',num2str(2*(i-nTraining/2)),'_test.jpg'));
    end
end

disp('done.');