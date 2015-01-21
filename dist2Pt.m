%Function dist2Pt creates a distance matrix for distances from given centroid

%Input: Centroid coordinates and sample matrix (to get correct dimensions) and
%Output: matrix where each element corresponds to a distance from centroid
%We'll use the Pythag. Theorem to find x and y distances from centroid for all elements in matrix 

%Thanks to Jack Chai for discussions!

function [distanceMatrix]= dist2Pt(Centroid,matrix);

x0= round(Centroid(1));%Rounds centroid coordinates for x and y
y0= round(Centroid(2));

[xSize,ySize]= size(matrix);%Get dimensions of matrix

xLength= 1:xSize;%Vectors for all x and y coordinates
yLength= 1:ySize;

%%Will use pythagorean theorem to find distance from point as
%%distance= sqrt((xDiff.^2)+(yDiff.^2)) 

xDiff= x0-xLength;%Differences in length from centroid and all possible positions in x
yDiff= y0-yLength;%Same for y

xSqr= xDiff.^2;
ySqr= yDiff.^2;

%%Empty matrices that we'll add and take the sqrt of at the end to give us a distance for every
%%xy combination

xMat= [];
yMat= [];

%Insert the same vector, xSqr, into every column in xMat 
for counter= 1:xSize
xMat= [xMat;xSqr];
end

%Insert the same vector, ySqr',(transpose of ySqr), into every row in yMat 
 
for counter= 1:ySize
yMat= [yMat,ySqr'];
end

sumXMatYMat= xMat+yMat;
distanceMatrix= sqrt(sumXMatYMat);


