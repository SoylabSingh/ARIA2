function testSemantic(image_path_test,net)

    imgs_out = imageDatastore(image_path_test);
    for i=1:length(imgs_out.Files)
        newStr = split(imgs.Files{i},'/');
        I = imread(fullfile(imgs.Files{i}));
        [~,~,channel]=size(I);
        w = ceil(size(I,1)/row)*row-size(I,1);
        h = ceil(size(I,2)/row)*row-size(I,2);

        pad = padarray(I,[w h],'pre');
        output = zeros(size(pad,1),size(pad,2));
        counter_patch = 0;
        for k=row:row:size(pad,1)
            for j=row:row:size(pad,2)
                if channel==1
                    patch = pad(k-(row-1):k,j-(row-1):j);
                else
                    patch = pad(k-(row-1):k,j-(row-1):j,:);
                end

                C = semanticseg(patch, net);
                output(k-(row-1):k,j-(row-1):j) = C;

            end
        end
        imwrite(patch,fullfile(strcat(image_path_test_,'_output'),strcat(newStr{end})));
    end
end
