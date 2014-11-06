%Thresholds,masks,finds and smooths edges of cell boundary
%Updated to include ellipse options 11/1/14


function [cb2Data,finalMask,smoothPerim]= cellBound4(image);
cb2Data= struct();
close all

%%==Make mask for original image==
imagesc(image,[1500 2300])%Show original image
test= image;
pause(1)


test= edge(image);%Turns to binary, 0 means no additional tresholding
imagesc(test)
pause(0.1)

seD= strel('disk',1);%Use a disk as structuring element to keep edges round
se5= strel('disk',5);
test1= imdilate(test,se5);
imagesc(test1); pause(0.1)
test2= imfill(test1,'holes');%Fills holes
test2= bwareaopen(test1,75);%Cleans up image to remove objects less than 75px in size
imagesc(test1); pause(0.1)


test3= imclose(test2,seD);%Smoothes edge
imagesc(test3); pause(0.1)

test3= imclearborder(test3);%Clears edge
imagesc(test3); pause(0.1)

% test= edge(bright);
% se5= strel('disk',5);%Need to make this big enough extend outside of cell
% while keeping shape intact. Better if too big.
% test2= imdilate(test,se5);
% test3= imfill(test2,'holes');
%test3= imclose(se5);


mask= test3;
figure('Color',[1 1 1]) 
imagesc(mask); 
disp('Works!')
cb2Data.mask= mask;
%cb2Data.lowBound= lowBound; %Put back in there when you add thresh option
cb2Data.seD= seD;

hold

%%==Trace cell boundaries==
allBounds= bwboundaries(test3,8);%y finds perimeter coords for ALL objects, each in a cell array
boundLengths= cellfun(@length, allBounds);%List of perim. lengths of all cells (objects)
cellPos= find(boundLengths==max(boundLengths(:)));%Finds index of largest cell in that list
cellCoord= allBounds{cellPos,1};%Coordinates of mask perimeter

plot(cellCoord(:,2),cellCoord(:,1),'g')%Plot coordinates over mask
cb2Data.cellCoord= cellCoord;

%%==Smooth perimeter==
smWindow= 10;%Size of moving average
perimX= smooth(cellCoord(:,2),smWindow);
perimY= smooth(cellCoord(:,1),smWindow);

plot(perimX,perimY,'m')
legend('Perim','Smooth Perim')
pause(1)
smoothPerim= gcf;
finalMask= poly2mask(perimX,perimY,512,512);%New mask from smooth border.

figure
imagesc(finalMask)
pause(0.1)

cb2Data.smWindow= smWindow;
cb2Data.perimX= perimX;
cb2Data.perimY= perimY;
cb2Data.finalMask= finalMask;
cb2Data.allBounds= allBounds;
cb2Data.boundLengths= boundLengths;
cb2Data.cellPos= cellPos;

stats= regionprops(finalMask,image,'Area','Orientation','Perimeter','MajorAxisLength','MinorAxisLength','Centroid','Eccentricity','MaxIntensity','MeanIntensity','MinIntensity','WeightedCentroid','PixelValues','BoundingBox');
cb2Data.stats= stats;

%===Alternative method to edge detection: Use brightfield image instead===

% test= edge(bright);
% test2= imdilate(test);
% se= strel('disk',5);%Need to make this big enough extend outside of cell while keeping shape intact. Better if too big.
% test2= imdilate(test,se);
% test3= imfill(test2,'holes');


