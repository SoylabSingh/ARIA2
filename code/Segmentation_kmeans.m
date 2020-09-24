function [Root] = Segmentation_kmeans(I_r)
%% Color-Based Segmentation Using K-Means Clustering
%% Step 1: Input Image and convert to HSV channel
lab_he=rgb2hsv(I_r);
%% Step 2: Classify the Colors in 'h*v*' Space Using K-Means Clustering
% Clustering is a way to separate groups of objects. K-means clustering treats
% each object as having a location in space. It finds partitions such that objects
% within each cluster are as close to each other as possible, and as far from
% objects in other clusters as possible. K-means clustering requires that you
% specify the number of clusters to be partitioned and a distance metric to quantify
% how close two objects are to each other.
% Since the color information exists in the 'h*v*' space, your objects are
% pixels with 'h*' and 'v*' values. Use |kmeans| to cluster the objects into three
% clusters using the Euclidean distance metric.
ab = double(lab_he(:,:,1:2));
nrows = size(ab,1);
ncols = size(ab,2);
ab = reshape(ab,nrows*ncols,2);
nColors = 2;
% repeat the clustering 3 times to avoid local minima
[cluster_idx, ~] = kmeans(ab,nColors,'distance','sqEuclidean', ...
    'Replicates',3);
%% Step 3: Label Every Pixel in the Image Using the Results from KMEANS
% For every object in your input, |kmeans| returns an index corresponding to
% a cluster. The |cluster_center| output from |kmeans| will be used later in the
% example. Label every pixel in the image with its |cluster_index|.
pixel_labels = reshape(cluster_idx,nrows,ncols);
%% Step 4: Create Images that Segment the H&E Image by Color.
% Using |pixel_labels|, you can separate objects in |hestain.png| by color,
% which will result in three images.
segmented_images = cell(1,2);
rgb_label = repmat(pixel_labels,[1 1 3]);

for k = 1:nColors
    color = I_r;
    color(rgb_label ~= k) = 0;
    segmented_images{k} = color;
end
%% Step 5: find root based on intensity of Blue Hue value
meanL1 = ImageIntensity_HueB(segmented_images{1});
meanL2 = ImageIntensity_HueB(segmented_images{2});
if meanL1<meanL2
    Root=segmented_images{2};
else
    Root=segmented_images{1};
end
Root=im2bw(Root);
end
