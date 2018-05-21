function BlockSize = GetCurrentBlockSize(imrow,imcol,patch_size,overlap,i,j)

U = ceil((imrow-overlap)/(patch_size-overlap)); 
V= ceil((imcol-overlap)/(patch_size-overlap)); 

if i == U && j ==V
    BlockSize = [imrow-patch_size+1 imrow imcol-patch_size+1 imcol];  
elseif i == U
    BlockSize = [imrow-patch_size+1 imrow ((patch_size-overlap)*j-(patch_size-overlap-1)) ((patch_size-overlap)*j+overlap)];    
elseif j == V
    BlockSize = [((patch_size-overlap)*i-(patch_size-overlap-1)) ((patch_size-overlap)*i+overlap) imcol-patch_size+1 imcol];    
else
    BlockSize = [((patch_size-overlap)*i-(patch_size-overlap-1)) ((patch_size-overlap)*i+overlap) ((patch_size-overlap)*j-(patch_size-overlap-1)) ((patch_size-overlap)*j+overlap)];        
end