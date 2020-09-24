function [sroot,Root,DistMat, dist_cm, x, y, path, MedianR, MaximumR,LengthDistribution, Perimeter, Diameter, Volume, SurfaceArea,TRLUpper, TRLLower,skeBW,Area,TRAUpper, TRALower,RatY] = PrimaryRootAnalyzer(Root3pc,YstClick,XstClick,Pix2cm)
%finding the Primary root using longest shortest path and then outputs the length
%in Centimeters of the primary root. Since we know the coordinates of the primary
%root, we subtract it from the original image, thus leaving only secondary
%roots to be analyzed
% Developers : Hsiang Sing Naik & Nigel Lee
% Copyright : Baskar Ganapathysubramanian
% Version 1 : July 14, 2013
% Version 2: December 7, 2016 by Zaki Jubery
%% Use gaussian filter on BWMROOT
Root2=Root3pc;
Root = BoundaryChecker(Root2);   %clear the boundaries of the image which could cause problem
%% Identify connected components and set largest one as root
neigh_n = 8;    %checks all 8 positions for nearest neighbours (N,E,S,W,NE,NW,SE,SW)
CC = bwconncomp(Root,neigh_n); %locates all connected components
ImgSize = size(Root); %image size for ind2sub function which converts indexed value of image to x and y coordinates
CCinMat = zeros(1,CC.NumObjects); %preallocates Connected components in matrix format
a = CC.PixelIdxList;
for n = 1:CC.NumObjects
    CCinMat(n) = max(size(cell2mat(a(n))));       %converts CC values to matrix
end
Rootidx_ID = CCinMat == max(CCinMat);  %find the largest connected components
Rootidx = cell2mat(a(Rootidx_ID));         %finds the indexed value of the largest connected components
[y, x] = ind2sub(ImgSize,Rootidx);        %converts indexed value to x and y coordinates

%preallocats memory for replotting the root from x and y coordinates
[Row,Column] = size(Root);
Root = zeros(Row,Column);
%plots the connected components of the root which are in x and y coordinates
for n = 1 : max(size(y))
    Root(y(n),x(n))=1;
end
% measure Area
Area=bwarea(Root)/(Pix2cm)^2;
Root(1:YstClick,:) = 0;      %removes all points above the start of the primary root
%% Skeletonize and clean the image
skeBW = bwmorph(Root,'skel','inf');
skeBW = bwmorph(skeBW,'clean');
% prune spur segments
skeBW=bwmorph(skeBW,'spur',20);
%% convert the skeletonized image into a graph and find primary root
%step 1: identify all useful pixels (Find coordinate of nonzero pixels)
[y,x] = find(skeBW);
Pt = [y x];
%step 2:find distance matrix between all these useful point
% (Find index and distance matrix of 10 closet points for all the nonzero
%  pixels)
[IDX,D] = knnsearch(Pt,Pt,'K',10);
% step 3:removes self counting
D(:,1)= [];
IDX(:,1) = [];
% step 4:preallocates the distance matrix
DistMat = sparse(max(size(y)));
k = 0;
for i=1:size(y,1)
    %find neighbors ID
    NN = find( D(i,:) < 2);
    if NN == 1
        %%change name (basically find the all the endpoints, because it has only one neighbour)
        Endpoints_ID(k+1) = IDX(i,NN); % all endpoints
        k = k+1;
    end
    NN_ID = IDX(i,NN);
    n_NN_ID = max(size(NN_ID));
    
    %find distance from NN_ID to i
    for j=1:n_NN_ID
        DistMat(i,NN_ID(j)) = D(i,NN(j));
        DistMat(NN_ID(j),i) = D(i,NN(j));
    end
end
% Step 5: Find closet starting point based on the mouse click ( or top
% point)
%finding closest start point to the coordinates the user has input
%after skeletonizing,since everything has become one pixel
startpts = [YstClick,XstClick];
startpts = round(startpts);
[Istart,~] = knnsearch(Pt,startpts, 'K',2);
% Step 6: Find the shortest path from starting points to each endpoints
%Locates all the Endpointss on the graph, and creates a shortest path from the
%start point to each Endpoints. Using this concept, the end point of the primary
%root can be located, by using the longest "shortest path" from the
%starting point to the Endpoints.
% [null] = Func_Diagnostic('Finding Longest Shortest Path...');
max_length = max(size(Endpoints_ID));
dist = zeros(max_length,1); %preallocate memory for shortest distance of all Endpoints (endpoints) ids
for n = 1 : max_length
    [dist(n)]=graphshortestpath(DistMat,Istart(1),Endpoints_ID(n));
end
% Step 7: Find longest of the shortest paths, this is the primary root
%ID of the longest "shortest path"
n = find(dist == max(dist));
% Step 8: Outputs details of the shortest path.
[dist, path, ~]=graphshortestpath(DistMat,Istart(1),Endpoints_ID(n(1)));
%% Compute descriptors of the primary root
[MedianR, MaximumR, TRLUpper, TRLLower, LengthDistribution, Perimeter, Diameter, Volume, SurfaceArea,TRAUpper, TRALower,RatY] = Func_DescriptorsforPrimaryRoot(skeBW,Root,x,y,path,YstClick,Pix2cm);
%% Remove primary root from the image and Visualize secondary roots on to a graph.
spt = Pt;
spt(path,:) = []; %removes primary root points from the skeletonized image
sy = spt(:,1); %assign the y location of the remaining roots to sy
sx = spt(:,2); %assign the x location of the remaining roots to sx
%preallocate memory for secondary root
[Row,Column] = size(Root);
sroot = zeros(Row,Column);
%plots the secondary root from sx and sy
for n = 1 : max(size(sy))
    sroot(sy(n),sx(n))=1;
end
%converts pixel to Centimeters
dist_cm = dist/Pix2cm;
end
