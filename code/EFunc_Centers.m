function [CM, CMT, CMM, CMB, CP, CPT, CPM, CPB,n_top,n_mid,n_bot] = EFunc_Centers(SecRootLength,Y,Image)
% Computes the center of mass and center of point for the overall image, a
% top section of the image, a middle section of the image and a bottom
% section of an image. This is denoted by T for top, M for middle and B for
% bottom
% Developers : Hsiang Sing Naik & Nigel Lee
% Copyright : Baskar Ganapathysubramanian
% Version 1 : July 18, 2013
[r,~]=find(Image);
sY=max(r);
n_top = find(Y <= sY/3);                %finding values of Y that are in the top section
n_mid = find(Y > sY/3 & Y <= sY*2/3); %finding values of Y that are in the middle section
n_bot = find(Y > sY*2/3);                %finding values of Y that are in the bottom section

CM = sum((SecRootLength).*Y/sY)/(sum(SecRootLength));  %computes the center of mass of the secondary roots with respect to length
CP = sum(1.*Y/sY)/length(Y);  %computes the center of mass of all secondary roots without respect to length
        
CMT = sum((SecRootLength(n_top)).*Y(n_top)/(sY))/(sum(SecRootLength(n_top)));  %computes the center of mass for top section
CPT = sum(1.*Y(n_top)/(sY))/length(Y(n_top));  %computes the center of point for middle section
        
CMM = sum((SecRootLength(n_mid)).*Y(n_mid)/(sY))/(sum(SecRootLength(n_mid)));  %computes the center of mass for top section
CPM = sum(1.*Y(n_mid)/(sY))/length(Y(n_mid)); %computes the center of point for middle section

CMB = sum((SecRootLength(n_bot)).*Y(n_bot)/(sY))/(sum(SecRootLength(n_bot)));  %computes the center of mass for top section
CPB = sum(1.*Y(n_bot)/(sY))/length(Y(n_bot)); %computes the center of point for middle section
end
