function [ rsd ] = chull_EFD( QCshape,fname,Root )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
fname(fname=='_') = '-';
s=regionprops(Root,'ConvexHull'); % here convexhull provides the co-ordinates of the convex area
chull=s.ConvexHull;
% Getting the co-efficient for Elliptic Fourier Transform (forward
% transformation)
rsd=fEfourier(chull,100,false,false);
% Perfroming Inverse Fourier Transform 

% define colorspec
colorspec = {[0.9 0.1 0.5]; [0.8 0.5 0.1]; [0.6 0.3 0.3]; ...
  [0.3 0.1 0.1]; [0.2 0.2 0]};

h=figure(5);
% rsd size is 4,100
for a=1:2
i = a*10;
subplot(1,2,a)
% imshow(imcomplement(Root));
imshow(Root);
rrsd=rEfourier(rsd,i+1,700);
hold on;
plot(rrsd(:,1),rrsd(:,2),'*','Color','r'); 
title(strcat('Number of Harmonics = ',num2str(i)));
set(gca, 'YDir', 'reverse');
clearvars rrsd
end
suptitle('ConvexHull Shape captured by Fourier Descriptors')
set(h,'units','normalized','outerposition',[0 0 1 1]);
filename=fullfile(QCshape,strcat(fname,'.jpg'));
saveas(h,filename,'jpg');
%saveas(h,filename,'fig');
pause(0.1)
close(h);
end

