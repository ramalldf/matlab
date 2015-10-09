function [erodeMask, xCoord, yCoord]= concentric(newMask,stepSize);

%Take smooth mask and erodes object cleanly
%StepSize designates how much to erode 
step= strel('disk',stepSize);
newMask2= bwboundaries(newMask,8);%Finds boundary of all objects, stores in a cell
newCoord= newMask2{1,1};%Takes largest object (our cell) and lists coordinates of boundary
xCoord= newCoord(:,2);%Separates coords matrix into vectors
yCoord= newCoord(:,1);
newMask3= poly2mask(xCoord,yCoord,512,512);%Uses coordinates to make new mask
newMask3= imerode(newMask,step);%Erodes new mask
erodeMask= newMask3;%Returns new mask object







