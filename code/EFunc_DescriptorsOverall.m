function [ConvexArea, Depth, Width, NetworkArea] = EFunc_DescriptorsOverall(x,y,Pix2cm)
% Computes Convex Area, Depth, Width and NetworkArea

%calculates convex area
[K,ConvexArea] = convhull(x,y); 
ConvexArea = ConvexArea/(Pix2cm)^2;

%calculates depth
Depth = max(y) - min(y);
Depth = Depth/Pix2cm;

%calculates width
Width = max(x) - min(x);
Width = Width/Pix2cm;

%calculate network area
NetworkArea = length(y);
NetworkArea = NetworkArea/(Pix2cm)^2;
end
