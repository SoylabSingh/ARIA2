function NofSR= NumSecondary_skel2BP_B(path,Root,x,y)
n=size(Root);
BWRoot=zeros(n(1),n(2));
for i=1:length(x);BWRoot(y(i),x(i))=1;end;
BP=bwmorph(BWRoot,'branchpoints');
% figure;imshow(BP);
[yball,xball]=find(BP);
%primary root path image
BWPRimage=zeros(n(1),n(2));
for i=1:length(path);BWPRimage(y(path(i)),x(path(i)))=1;end;

se = strel('disk',10);
BWPRimage=imdilate(BWPRimage,se);

% masked branch points on the primary root
BP(~BWPRimage)=0;

% find the number of connect components 
CC = bwconncomp(BP,8);
NofSR=CC.NumObjects;

% find location of branch points
[yb,xb]=find(BP);
% figure;imshow(RootColor);hold on; plot(xb,yb,'*g');
end
