function [Root] = Segmentation_userdefined(I_r)
% Segmenting the foreground from the background and considering the largest connected component as root 
% Segment the foreground using user-defined function
[BW,~] = createMask(I_r);
% dilate the image to fill small gaps
se = strel('disk',2);
BW=imdilate(BW,se);
BW=imerode(BW,se);
BW = bwareaopen(BW, 50);
% find largest connected component and consider as root
CC = bwconncomp(BW,8);
Root=BW;
ImgSize = size(Root); %image size for ind2sub function which converts indexed value of image to x and y coordinates
%load('RootSizeMultiplier.txt')
CCinMat = zeros(1,CC.NumObjects); %preallocates Connected components in matrix format
a = CC.PixelIdxList;
for n = 1:CC.NumObjects
    CCinMat(n) = max(size(cell2mat(a(n))));       %converts CC values to matrix
end
Rootidx_ID = find(CCinMat == max(CCinMat));  %find the largest connected components
Rootidx = cell2mat(a(Rootidx_ID));         %finds the indexed value of the largest connected components
[y, x] = ind2sub(ImgSize,Rootidx);        %converts indexed value to x and y coordinates
%preallocats memory for replotting the root from x and y coordinates
[Row,Column] = size(Root);
Root = zeros(Row,Column);
%plots the connected components of the root which are in x and y
%coordinates
for n = 1 : max(size(y))
    Root(y(n),x(n))=1;
end
end
