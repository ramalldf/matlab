%[meanCrop,sqrDim] = getMeanRoi(Image, x, y) %Gets mean of 5x5 ROI, centers
%at x and y (if given)

function [meanCrop,x, y] = getMeanRoi(Image,x,y);
if exist('x','var') ==1 && exist('y','var')== 1%If  x, y variables (coordinates)
    %exist for point selected, use coordinate to make a 5x5 square
    %that will be cropped from Image. We'll get mean from the pixels in 
    %that square 
x= round(x);%Round to land on one pixel
y= round(y);

sqrDim= 5;
x1 = x-sqrDim;
y1 = y-sqrDim;
x2 = x+sqrDim;
y2 = y+sqrDim;

imageCrop = Image(y1:y2,x1:x2);
meanCrop = mean(imageCrop(:));

%If x and y don't already exist, use ginput to select starting coordinate
else
imagesc(Image)
disp('works')
[x,y]= ginput(1);

x= round(x);
y= round(y);

disp(x)
disp(y)

sqrDim= 5;
x1 = x-sqrDim;
y1 = y-sqrDim;
x2 = x+sqrDim;
y2 = y+sqrDim;

imageCrop = Image(y1:y2,x1:x2);
meanCrop = mean(imageCrop(:));


end


