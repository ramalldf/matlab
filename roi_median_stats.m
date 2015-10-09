function [roi_median,roi_data]= roi_median_stats(image,roi_coords_file);
%Function input: image (float) for region of interest (ROI) measurements, text file with x,y coordinates
%output: median value for region, structure with additional properties for
%region

%%Load coordinates for region: column 1: x coordinates, col 2: y coords
roi_coords= importdata(['' roi_coords_file '.txt']);

[x,y]= size(image);%Find dimensions of image for poly2mask function
roi= poly2mask(roi_coords(:,1),roi_coords(:,2),x,y);%Generates binary mask from coords
roi1= single(roi);%Turns mask to single to multiply by raw image data

roi_image= roi1.*image;%Applies roi1 mask to given image
roi_image(find(roi_image<= 0))= NaN;%Converts zeros to NaNs
roi_median= nanmedian(roi_image(:))%Calculate median without NaNs

%Use regionprops to make additional measurements within roi
roi_data= regionprops(roi,roi_image,'Area','Orientation','Perimeter','MajorAxisLength','MinorAxisLength','Centroid','Eccentricity','MaxIntensity','MeanIntensity','MinIntensity','WeightedCentroid','PixelValues','BoundingBox');

roi_data.median = roi_median;
roi_data.coords = roi_coords;
roi_data.roi_image = roi_image;
roi_data.mask = roi;
roi_data.name = roi_coords_file;


