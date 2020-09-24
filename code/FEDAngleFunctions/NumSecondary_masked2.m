function NofSR= NumSecondary_masked2(path,Root,x,y,RootColor)
% % add padding to the image to faciliate dilation
Root = padarray(Root,[25 25],'both');
n=size(Root);
warning('off')
% offset primary root 25 pixels step
count=1;
for k=20:5:40
% draw only offset primary root in a separate image
%right side
BWtest=zeros(n(1),n(2));
for i=1:length(path);BWtest(y(path(i)),x(path(i))+k)=1;end;
% use BWtest as masked on Root image
se = strel('line',1,0);
BWtest=imdilate(BWtest,se);
maskedRoot=Root;
maskedRoot(~(BWtest))=0;

%identify all nonzero pixels in imdiff
[ysn,xsn] = find(maskedRoot);

% figure;imshow(Root);hold on; plot(xsn,ysn,'*r');
% find the number of connect components 
CC = bwconncomp(maskedRoot,8);
NoSR1(count)=CC.NumObjects;

%left side
BWtest2=zeros(n(1),n(2));
for i=1:length(path);BWtest2(y(path(i)),x(path(i))-k)=1;end;
% use BWtest as masked on Root image
BWtest2=imdilate(BWtest2,se);
maskedRoot2=Root;
maskedRoot2(~(BWtest2))=0;

%identify all nonzero pixels in imdiff
[ysn2,xsn2] = find(maskedRoot2);

% figure;imshow(RootColor);hold on; plot(xsn2,ysn2,'*g');hold on; plot(xsn,ysn,'*g');
% find the number of connect components 
CC = bwconncomp(maskedRoot,8);
NoSR2(count)=CC.NumObjects;
% pause
TNSR(count)=NoSR1(count)+NoSR2(count);
count=count+1;
end
% use the maximum number of connected components on two sides as total number of Secondary root
NofSR=max(NoSR1)+max(NoSR2);
end

