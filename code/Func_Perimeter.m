function [Perimeter] = Func_Perimeter(Image)
%finds the perimeter of the image



Image = Func_Threshold(Image);
Data = regionprops(Image, 'perimeter');
Perimeter = Data(1).Perimeter;
end