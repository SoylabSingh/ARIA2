function NodeRoots= SegmentsNearNodes(path,Root,x,y,k)
n=size(Root);
warning('off')
% draw only offset primary root in a separate image
%right side
BWtest=zeros(n(1),n(2));

for i=1:length(path)
        BWtest(y(path(i)),x(path(i)):x(path(i))+2*k)=1;
end

n=size(Root);
% use BWtest as masked on Root image
se = strel('line',1,0);
BWtest=imdilate(BWtest,se);
if size(BWtest)==size(Root)
maskedRoot=Root;
maskedRoot(~(BWtest))=0;
else
    % safety for the roots near the border,dilation make the image size
    % bigger in that case
maskedRoot=zeros(n(1),n(2)); 
end

%left side
BWtest2=zeros(n(1),n(2));
for i=1:length(path);BWtest2(y(path(i)),x(path(i))-2*k:x(path(i)))=1;end;
% use BWtest as masked on Root image
BWtest2=imdilate(BWtest2,se);
if size(BWtest2)==size(Root)
maskedRoot2=Root;
maskedRoot2(~(BWtest2))=0;
else
  % safety for the roots near the border,dilation make the image size
    % bigger in that case
maskedRoot2=zeros(n(1),n(2)); 
end
NodeRoots=maskedRoot+maskedRoot2;
end
