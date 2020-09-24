function [N1,N2,N3,edges]=DirectionalityMeasurementv2(QCdirection,fname,skeBW,sskeBW,x,y,path)
% try
fname(fname=='_') = '-';
th=0.8; % th is fft filter parameter, varies between 0 to 1. 
ss=50; % ss is the size of domain around the root tip for segmented root
subsegstep=50; % subsegstep is the size of segmented section around the root
nodeseg = 50; % indicates the size of domain used for selecting root segments near the base
sf = 0.05; % smoothing factor for the fit
% identify location of the root tip
EpBW=bwmorph(skeBW,'endpoints');
[yb,xb] = find(EpBW);
ntip=length(yb);
Angletipdata=zeros(ntip,3);
TipsImage=zeros(size(skeBW));
for i=1:ntip
    try
    segImg=skeBW(yb(i)-ss:yb(i)+ss,xb(i)-ss:xb(i)+ss);
    TipsImage(segImg)=1;
            P2=segImg;
            % hough transform and measure the angle with highest occurace
            [H,T,R] = hough(P2);
            % find the peak angle
            P  = houghpeaks(H,1);           
            Angletip(i)=abs(T(P(:,2)));
            Angletipdata(i,1)=yb(i);
            Angletipdata(i,2)=xb(i);
            Angletipdata(i,3)=Angletip(i);
            
    catch
    end
end


%% finding only secondary roots
%% Segment image with 5 by 5 subsegments (row-wise)
E1_base=sskeBW;
n=size(sskeBW);
Angle=NaN(uint16(n(1)/subsegstep),uint16(n(2)/subsegstep));
count=1;
for i=1:subsegstep:n(1)-subsegstep
    for j=1:subsegstep:n(2)-subsegstep
        ct=j:j+subsegstep;
        segImg=sskeBW(i:i+subsegstep,j:j+subsegstep);
        % consider image with white pixel only
        if bwarea(segImg)>1
            P2=segImg;
            [H,T,R] = hough(P2);
            % find the peak angle
            P  = houghpeaks(H,1);
            Angle(i,j)=T(P(:,2));
            Angleall(count)=abs(T(P(:,2)));
            count=count+1;
        end
    end
end


%% finding only secondary roots segments at the nodes
NodeRoots= SegmentsNearNodes(path,sskeBW,x,y,nodeseg);
E2_base=NodeRoots;
% detect individual segment
[label,n]=bwlabel(NodeRoots);
CC=bwconncomp(NodeRoots);
S2=regionprops(CC,'BoundingBox');
C2 = regionprops(CC,'centroid');
centroids = cat(1,C2.Centroid);
Anglenodedata=zeros(n,3);
% for i=1:length(S2)
for i=1:n
    segImg=imcrop(NodeRoots,S2(i).BoundingBox);
    P2=segImg;
    % hough transform and measure the angle with highest occurace
    [H,T,R] = hough(P2);
    % find the peak angle
    P  = houghpeaks(H,1);
    Anglenode(i)=abs(T(P(:,2)));
    Anglenodedata(i,1)=centroids(i,1);
    Anglenodedata(i,2)=centroids(i,2);
    Anglenodedata(i,3)=Anglenode(i);
end


% h=figure;hold on;
edges=0:2:90;
h=figure(4);
subplot 131
hold on;
N2 = histcounts(Angleall,edges); dataN2=[edges(2:46)',N2']; Index=dataN2(:,2)>0;N2select=dataN2(Index,:);f2 = fit(N2select(:,1),N2select(:,2),'smoothingspline','SmoothingParam',sf);plot(f2,'g--',N2select(:,1),N2select(:,2));
% scatter(N2select(:,1),N2select(:,2),'g*');
legend('segments','fit')
legend('boxoff')
legend('Location','northwest')
xlabel('Absolute angle in degree');
ylabel('Count');
subplot 132
hold on;
N1 = histcounts(Anglenode,edges); dataN1=[edges(2:46)',N1']; Index=dataN1(:,2)>0;N1select=dataN1(Index,:);f1 = fit(N1select(:,1),N1select(:,2),'smoothingspline','SmoothingParam',sf);plot(f1,'r-',N1select(:,1),N1select(:,2));
% scatter(N1select(:,1),N1select(:,2),'rs');
legend('near nodes','fit')
legend('boxoff')
legend('Location','northwest')
xlabel('Absolute angle in degree');
ylabel('Count');
subplot 133
hold on;
N3 = histcounts(Angletip,edges); dataN3=[edges(2:46)',N3']; Index=dataN3(:,2)>0;N3select=dataN3(Index,:);f3 = fit(N3select(:,1),N3select(:,2),'smoothingspline','SmoothingParam',sf);plot(f3,'b:',N3select(:,1),N3select(:,2));
% scatter(N3select(:,1),N3select(:,2),'b+');
legend('root tips','fit')
legend('boxoff')
legend('Location','northwest')
ylabel('Count');

suptitle('Distribution of Angles');
set(h,'units','normalized','outerposition',[0 0 1 1]);
filename=fullfile(QCdirection,strcat(fname,'.jpg'));
saveas(h,filename,'jpg')
%saveas(h,filename,'fig')
pause(0.1)
close(h)
% catch
%    disp({'Having problem with angle evaluation in ', fname})
%    N1=zeros(1,45);
%    N2=zeros(1,45);
%    N3=zeros(1,45);
%    edges=zeros(1,46);
% end
end
