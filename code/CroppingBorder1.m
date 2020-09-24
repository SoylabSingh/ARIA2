function [out] = CroppingBorder1(BW)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
[y,x] = find(BW);  %// Find row and column locations that are non-zero
%// Find top left corner
xmin = min(x(:));
ymin = min(y(:));
%// Find bottom right corner
xmax = max(x(:));
ymax = max(y(:));
% Keeping Borders in the cropped image
if xmin>6
    xmin=xmin-5;
end

if ymin>6
    ymin=ymin-5;
end
%// Find width and height, 50 is added to keep borders
width = xmax - xmin+5 ;
height = ymax - ymin+5;
out = imcrop(BW, [xmin ymin width height]);
% RGB2= imcrop(RGB, [xmin ymin width height]);
end

