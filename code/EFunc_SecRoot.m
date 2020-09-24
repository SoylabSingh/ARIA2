function [All_sec_root_lengths_cm, Y, extremerootlength_cm, extremeY, extremerootlength_ID] = EFunc_SecRoot(sroot, primaryrootlength,Pix2cm)
%analyze the secondary roots and outputs the length and Y start location of
%the root in inches
% Developers : Hsiang Sing Naik & Nigel Lee
% Copyright : Baskar Ganapathysubramanian
% Version 1 : July 14, 2013
% Version 2 : December 7, 2016 by Zaki Jubery

%% Identify all connected components and measure length of each components
neigh_n = 8;
CC = bwconncomp(sroot,neigh_n); %locate all connected components of secondary roots
All_sec_root_lengths = zeros(1,CC.NumObjects); %preallocates memory for all length of roots
k=0;
for i=1:CC.NumObjects
    this_sec_root_length = size(CC.PixelIdxList{i},1); %length of root in pixels
    All_sec_root_lengths(k+1) = this_sec_root_length; %insert length of root in pixels into variable
    IND = CC.PixelIdxList{i};
    [Ypt, ~] = ind2sub(size(sroot),IND); %find Y co-ordinate of the root, ind2sub : Subscripts from linear index
    Y(k+1) = Ypt(1);% assign 1st point as the starting point;
    % (if root goes upward then where would be the starting point????)
    k = k+1;
end
%% isolates the extreme secondary roots those are 1.2 times bigger than the primary root
%threshold for extreme values is assume to be 1.2 times the size of primary root
[ExtremeThresholdMultiplier] = UserSet_ExtremeThresholdMultiplier();
[primaryrootlength_pixel] = primaryrootlength*Pix2cm;
extremethreshold = (primaryrootlength_pixel)*ExtremeThresholdMultiplier; %calculates the extreme threshold value
extremerootlength_ID = find(All_sec_root_lengths>extremethreshold); %finds if any secondary root exceeds the extreme threshold
extremerootlength = All_sec_root_lengths(extremerootlength_ID); %assign roots found to exceed extreme threshold to a variable
extremeY = Y(extremerootlength_ID);  %isolates secondary roots that exceeds extreme threshold Y start location

%% converts pixels to cm
All_sec_root_lengths_cm = All_sec_root_lengths/Pix2cm;
extremerootlength_cm = extremerootlength/Pix2cm;
end
