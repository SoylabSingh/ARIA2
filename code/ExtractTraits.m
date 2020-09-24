function [TotalRootLength,Primaryrootlength,sumSecondaryLength,meanSecondaryLength,lengthSLbyPL,MedianR, MaximumR,LengthDistribution, Perimeter, Diameter, Volume, SurfaceArea,TRLUpper, TRLLower, ...
    CM, CMT, CMM, CMB, CP, CPT, CPM, CPB,ConvexArea, Depth, Width, NetworkArea,NofSR,NofSR2,NofSR3,Root,skeBW,sroot,x,y,path,...
    Area,TRAUpper, TRALower,RatY] = ExtractTraits(Ip,Pix2cm,QCimage2,fname,Iori)
%finding the Primary root using longest shortest path and then outputs the length
%in Centimeters of the primary root. Since we know the coordinates of the primary
%root, we subtract it from the original image, thus leaving only secondary
%roots to be analyzed
% Developers : Hsiang Sing Naik & Nigel Lee
% Copyright : Baskar Ganapathysubramanian
% Version 1 : July 14, 2013
% Version 2: December 7, 2016 by Zaki Jubery
fname(fname=='_') = '-';
%% Find Starting point of the root system
% Find row and column locations that are non-zero
[y,~] = find(Ip);  
%Find top left corner
ymin = min(y(:));
XstClick= min(find(Ip(ymin(1),:)));
YstClick=ymin(1);
%% ParimaryRootAnalysis
[sroot, Root,~,Primaryrootlength, x, y, path, MedianR, MaximumR,LengthDistribution, Perimeter, Diameter,...
    Volume, SurfaceArea,TRLUpper,TRLLower,skeBW,Area,TRAUpper, TRALower,RatY] = PrimaryRootAnalyzer(Ip,YstClick,XstClick,Pix2cm);
%% SecondaryRootAnalsysis and Total Root Length
[SecondaryLength, Y, ~, ~, ~] = EFunc_SecRoot(sroot, Primaryrootlength,Pix2cm);
TotalRootLength = Primaryrootlength+sum(SecondaryLength); 
%% Computes the center of mass and center of point for the overall image ( need to change Y)
[CM, CMT, CMM, CMB, CP, CPT, CPM, CPB,~,~,~] = EFunc_Centers(SecondaryLength,Y,Ip);
%% Computes overall descriptors Convex Area, Depth, Width and NetworkArea
[ConvexArea, Depth, Width, NetworkArea] = EFunc_DescriptorsOverall(x,y,Pix2cm);

% Number of secondary roots
NofSR= NumSecondary_masked2(path,Root,x,y,Iori);
NofSR2= NumSecondary_skel2BP(path,Root,x,y,Iori);
NofSR3= NumSecondary_skel_gauss(path,Root,x,y);
%% Data visualization and saving to check root status
figure (3);
subplot(1,2,1);
imshow(Iori)  %Displays original root image
title('Original Root')
subplot(1,2,2);
imshow(zeros(size(Ip)));  %Displays segmented root image
hold on;
plot(x,y,'.g','MarkerSize',1) ;    %plots the root image onto a graph in red
hold on;
plot(x(path),y(path),'.r','MarkerSize',1);  %plots the primary root on top of the root image in black.
set(gca,'YDir','Reverse')
hold off;
title('Primary(red) and Secondary(green)');
suptitle(fname);
% get the figure and axes handles
hFig = gcf;
% set the figure to full screen
set(hFig,'units','normalized','outerposition',[0 0 1 1]);
filename=fullfile(QCimage2,strcat(fname,'.jpg'));
saveas(gcf,filename,'jpg');
% saveas(gcf,filename,'fig');
%% Prepare  data
sumSecondaryLength=sum(SecondaryLength);
meanSecondaryLength=mean(SecondaryLength);
lengthSLbyPL=length(SecondaryLength)/Primaryrootlength;
end



