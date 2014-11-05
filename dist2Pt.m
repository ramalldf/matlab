function [distanceMatrix]= dist2Pt(Centroid,matrix);

x0= round(Centroid(1));
y0= round(Centroid(2));


[xSize,ySize]= size(matrix);
%[xSize,ySize]= size(test);


xLength= 1:xSize;
yLength= 1:ySize;

xDiff= x0-xLength;
yDiff= y0-yLength;

xSqr= xDiff.^2;
ySqr= yDiff.^2;


distance= sqrt(xSqr+ySqr)

%distance= sqrt((xDiff.^2)+(yDiff.^2))

xMat= [];
yMat= [];

for counter= 1:xSize
xMat= [xMat;xSqr];
end

for counter= 1:ySize
yMat= [yMat,ySqr'];
end

distMat= xMat+yMat;
distanceMatrix= sqrt(distMat);


