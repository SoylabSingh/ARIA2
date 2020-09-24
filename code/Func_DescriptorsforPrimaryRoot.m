function [MedianR1, MaximumR1, TRLUpper, TRLLower, LengthDistribution, Perimeter, Diameter, Volume, SurfaceArea,TRAUpper, TRALower,s] = Func_DescriptorsforPrimaryRoot(skeBW,Root,x,y,path,YstClick,Pix2cm)
% Outputs Median number of roots, maximum number of roots, total root
% length in the upper one-third(upper), total root length in the lower
% two-thirds(lower), length distribution, perimeter of root

%Calculates the median,maximum number of pixel at every y
s2 = sum(skeBW');
% remove zero entries
s = s2(s2 ~= 0);
MedianR1 = median(s);
MaximumR1 = prctile(s,84);

% Crop the border to get the length of the root
Roott=CroppingBorder1(Root);

%Calculates the upper one third and lower two thirds of the Root
TRLUpper = sum(sum(skeBW(YstClick:round(1/3*(max(size(Roott))),0),:)));
TRLLower = sum(sum(skeBW(round(1/3*(max(size(Roott))),0)+1:max(size(Roott)),:)));
TRLUpper=TRLUpper/(Pix2cm) ;
TRLLower=TRLLower/(Pix2cm) ;
LengthDistribution = TRLUpper/TRLLower;

TRAUpper = sum(sum(Root(YstClick:round(1/3*(max(size(Roott))),0),:)));
TRALower = sum(sum(Root(round(1/3*(max(size(Roott))),0)+1:max(size(Roott)),:)));
TRAUpper=TRAUpper/(Pix2cm^2) ;
TRALower=TRALower/(Pix2cm^2) ;

%calculate the perimeter of the root
Perimeter = Func_Perimeter(Root);
Perimeter = Perimeter/Pix2cm;

[~,Column] = size(Root);
D = zeros(1,Column);

for n = 1 : length(path)
    D(n) = 1;
    xpt = x(path(n));
    ypt = y(path(n));
    %check left
    while Root(ypt,xpt) == 1
        D(n) = D(n) + 1;
        xpt = xpt - 1;
    end
    xpt = x(path(n));
    xpt = xpt + 1;
    %checks right
    while Root(ypt,xpt) == 1
        D(n) = D(n) + 1;
        xpt = xpt + 1;
    end
end
D = D/Pix2cm;
Diameter = mean(D);

Volume = sum(pi*D.^2/4);
SurfaceArea = sum(pi*D);
SurfaceArea = SurfaceArea/Pix2cm;

end
