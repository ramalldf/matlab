%Function dist2Pt creates a distance matrix for distances from given centroid

%Input: Centroid coordinates and SQUARE sample matrix
%Output: matrix where each element corresponds to a distance from centroid
%We'll use the Pythag. Theorem to find x and y distances from centroid for all elements in matrix 

%Thanks to Jack Chai for discussions!

function [distanceMatrix]= dist2Pt(Centroid,matrix);

x0= round(Centroid(2));%Rounds centroid coordinates for x and y
y0= round(Centroid(1));

[ySize,xSize]= size(matrix);%Get dimensions of matrix

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

%Insert the same vector, xSqr, into every row in xMat
%Reason is that x distance for all rows will be the same at a given column (x) 
for counter= 1:xSize
xMat= [xMat;xSqr];
end

%Now do the same for ySqr',(transpose of ySqr), into every column in yMat
%y distance from centroid will be the same for a
 
for counter= 1:ySize
yMat= [yMat,ySqr'];
end

%Now add matrices and take square root to get distance at each element
sumXMatYMat= xMat+yMat;
distanceMatrix= sqrt(sumXMatYMat);


