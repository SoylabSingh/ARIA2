function [image] = Func_Threshold(Image)
%Computes a global threshold (level) that can be used to convert an intensity image to a binary image with im2bw.
%In other words, changes a picture to just black and white.

level = graythresh(Image);
image = im2bw(Image,level);


end

