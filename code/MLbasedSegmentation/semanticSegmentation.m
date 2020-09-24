% image_path_input = 'Agron_Train';
% image_path_label = 'Agron_label';
% row = 256;
% classes = ["plant","background"];
% batch_size=4;
% epoch_num=10;
function semanticSegmentation(image_path_input,image_path_label, row, classes, batch_size, epoch_num)




vgg16();

if not(exist('pretrained'))
    mkdir('pretrained')
end

pretrainedURL = 'https://www.mathworks.com/supportfiles/vision/data/segnetVGG16CamVid.mat';
pretrainedFolder = fullfile('pretrained','pretrainedSegNet');
pretrainedSegNet = fullfile(pretrainedFolder,'segnetVGG16CamVid.mat'); 
if ~exist(pretrainedFolder,'dir')
    mkdir(pretrainedFolder);
    disp('Downloading pretrained SegNet (107 MB)...');
    websave(pretrainedSegNet,pretrainedURL);
end


method='input';
addPadding(image_path_input, row, method);
imgs = imageDatastore(strcat(image_path_input,'_patches_',method));

method='label';
addPadding(image_path_label, row, method);
labelIDs = camvidPixelLabelIDs();
pxgs = pixelLabelDatastore(strcat(image_path_label,'_patches_',method),classes,labelIDs);


[imgsTrain,imgsTest,pxgsTrain,pxgsTest] = partitionCamVidData(imgs,pxgs);

imageSize = [row row 3];
numClasses = numel(classes);
lgraph = segnetLayers(imageSize,numClasses,'vgg16');


options = trainingOptions('sgdm', ...
    'Momentum',0.9, ...
    'InitialLearnRate',1e-3, ...
    'L2Regularization',0.0005, ...
    'MaxEpochs',epoch_num, ...  
    'MiniBatchSize',batch_size, ...
    'Shuffle','every-epoch', ...
    'VerboseFrequency',2);
pximds = pixelLabelImageDatastore(imgsTrain,pxgsTrain);
[net, info] = trainNetwork(pximds,lgraph,options);


pxgsResults = semanticseg(imgsTest,net, ...
    'MiniBatchSize',batch_size, ...
    'Verbose',false);
metrics = evaluateSemanticSegmentation(pxgsResults,pxgsTest,'Verbose',false);


save(strcat('semantic_vgg16_',epoch_num,'.mat'),'net');
