%updated 10/13/14

function [cropData,list,listName]= dataCrop4(lifeImage,intImage,name,list,listName);
% 
% if exist('list') == 0% Check for existence of meanList vector for all cells
%     list= [];
% else
% end

cropData= struct();
%==polygo roi crop==
[bw,xi,yi]= roipoly(lifeImage);
bw2= single(bw);
crop= bw2.*(lifeImage);
crop2= bw2.*(intImage);
%[crop,box]= imcrop(data);%Old code to crop image of roi in square
[cdfCrop,cdfInt]= sortCdf(crop);%From cropped roi data, get cdf and cdf intervals

midVal= 0.5;%For single gaussian mean will be at 0.5 so we'll be looking for lifetime value that's at interval position 0.5
closer= abs(cdfInt-midVal);%Make new vector of abs of interval coordinates - desired coordinate, 0.5
[closest,closestMidInt]= min(closer);%Finds [magnitude of smallest difference, coordinate in vector] of where 0.5 will be

midCdf= cdfCrop(closestMidInt);%Goes back to cdf data and fetches value for that coordinate (which is 0.5 ~ mean)

%==Places data in a structure==
cropData.cropLife= crop;
cropData.cropInt= crop2;
%cropName.box= box;
cropData.xi= xi;
cropData.yi= yi;
cropData.bw= bw; 
cropData.cdfCrop= cdfCrop;
cropData.cdfInt= cdfInt;
cropData.closestMidInt= closestMidInt;
cropData.midCdf= midCdf;

%Uses list you referenced earlier and adds midCdf value to it to make
%process faster
list= [list;midCdf];
listName= [listName;name];
