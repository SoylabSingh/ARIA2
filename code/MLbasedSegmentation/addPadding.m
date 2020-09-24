function addPadding(image_path, row, method)
% image_path = 'testRenaming';
% row = 256;
% format='JPG';
% method = 'input';
if not(exist(strcat(image_path,'_patches_',method)))
    mkdir(strcat(image_path,'_patches_',method))
end
% function addPadding(image_path,row,format)

imgs = imageDatastore(fullfile(image_path));
for i=1:length(imgs.Files)
    newStr = split(imgs.Files{i},'/');
    I = imread(fullfile(imgs.Files{i}));
    [~,~,channel]=size(I);
    w = ceil(size(I,1)/row)*row-size(I,1);
    h = ceil(size(I,2)/row)*row-size(I,2);
    pad = padarray(I,[w h],'pre');
    counter_patch = 0;
    for k=row:row:size(pad,1)
        for j=row:row:size(pad,2)
            if channel==1
                patch = pad(k-(row-1):k,j-(row-1):j);
            else
                patch = pad(k-(row-1):k,j-(row-1):j,:);
            end
        end
        imwrite(patch,fullfile(strcat(image_path,'_patches_',method),strcat('patch_',num2str(counter_patch),'_',strcat(newStr{end}))));
        counter_patch = counter_patch + 1;
    end
    
    
end








