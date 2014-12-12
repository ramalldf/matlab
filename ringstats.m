%Trims down the number of variables and keeps the ones we really will use.

load('C:\Users\D\Documents\MATLAB\whiteCMap','whiteCMap','lifescale')

clearex('whiteCMap','lifescale')

prefix= input('Name of ring file?: ');

load(['' prefix '_ ellipRings.mat'],'thrLife2','alignInt','ellipMask','midIntLayers','midLifeLayers','Centroid','MajorAxisLength','MinorAxisLength','Orientation','area','eccentricity','layers','name','perimeter0');
ellipseMaskedLife= ellipMask.*thrLife2;
ellipseMaskedLife(find(ellipseMaskedLife ==0)) = NaN;%Replace zeros with NaN
ellipseMedianLife= nanmedian(ellipseMaskedLife(:));
midIntLayersNorm= midIntLayers/(max(midIntLayers(:)));
%inTable= (midIntLayers,midLifeLayers,Centroid,MajorAxisLength,Orientation,area,eccentricity,layers,name,perimeter0);
save(['' prefix '_ringStats.mat'])