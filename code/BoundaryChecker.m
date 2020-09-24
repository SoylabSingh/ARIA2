function [Image] = BoundaryChecker(Image)
%Checks for the boundary of the root. This is so that when image is
%displayed, it will display a proper version of the root, excluding most of
%the empty background.
% Developers : Hsiang Sing Naik & Nigel Lee
% Copyright : Baskar Ganapathysubramanian

% Version 1 : July 14, 2013


Image(1,:) = 0;
Image(:,min(size(Image))) = 0;
Image(max(size(Image)),:) = 0;
Image(:,1) = 0;
end