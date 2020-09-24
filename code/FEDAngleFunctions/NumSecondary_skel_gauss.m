function NofSR= NumSecondary_skel_gauss(path,Root,x,y)

% % add padding to the image
% Root = padarray(Root,[50 50],'both');
n=size(Root);
% offset primary root skeleton * pixels step

% draw only primary root in a separate image
BWtest=zeros(n(1),n(2));
for i=1:length(path);BWtest(y(path(i)),x(path(i)))=1;end;
% dilate skeletonize primary root
se = strel('disk',5);
dilatedBWtest = imdilate(BWtest,se);

% draw only the secondary root skeleton in a separate image
spt=[y x];
spt(path,:) = []; %removes primary root points from the skeletonized image
sy = spt(:,1); %assign the y location of the remaining roots to sy
sx = spt(:,2); %assign the x location of the remaining roots to sx

BWsec=zeros(n(1),n(2));
%create image with seconday root only
for np = 1 : max(size(sy))
    BWsec(sy(np),sx(np))=1;
end

BWsec(~dilatedBWtest)=0;
CC=bwconncomp(BWsec,8);
NofSR=CC.NumObjects;
end
