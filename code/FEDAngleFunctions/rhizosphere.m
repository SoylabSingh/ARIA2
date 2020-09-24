function [ r_area,rsd ] = rhizosphere(QCshape2,fname,Root )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
fname(fname=='_') = '-';
se = strel('disk',10);
dilatedI = imdilate(Root,se);
% figure;
% imshowpair(Root, dilatedI);
rhizsphere=dilatedI-Root;
r_area=bwarea(rhizsphere);
cBW=bwboundaries(dilatedI);
[~, max_index] = max(cellfun('size', cBW, 1));
loc2=cBW{max_index,1};
% Getting the co-efficient for Elliptic Fourier Transform (forward
% transformation)
rsd=fEfourier(loc2,100,false,false);

% save (filenamefc,'rsd')
% Perfroming Inverse Fourier Transform 
rrsdall=rEfourier(rsd,100,700);

% define colorspec
colorspec = {[0.9 0.1 0.5]; [0.8 0.5 0.1]; [0.6 0.3 0.3]; ...
  [0.3 0.1 0.1]; [0.2 0.2 0]};

h=figure(6);
for a=1:2
i = a*10;
subplot(1,2,a)
% imshow(imcomplement(Root));
imshow(Root);
rrsd=rEfourier(rsd,i+1,700);
hold on;
plot(rrsd(:,2),rrsd(:,1),'*','Color','r'); 
title(strcat('Number of Harmonics = ',num2str(i)));
set(gca, 'YDir', 'reverse');
clearvars rrsd
end
suptitle('Shape captured by Fourier Descriptors')
set(h,'units','normalized','outerposition',[0 0 1 1]);

filename=fullfile(QCshape2,strcat(fname,'.jpg'));
saveas(h,filename,'jpg')
%saveas(h,filename,'fig');
pause(0.1)
close(h)
end

