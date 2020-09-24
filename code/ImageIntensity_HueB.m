function meanL = ImageIntensity_HueB(A2)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
A = rgb2hsv(A2);
counts=sum(sum((A(:,:,3)~=0)));
meanL=sum(sum(A(:,:,3)))/counts;
end

