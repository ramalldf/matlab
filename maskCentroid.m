function [mask,centroid]= maskCentroid(image);
%Finds mask and centroid coordinates for given transmitted channel image

test= edge(image);%Turns to binary, 0 means no additional tresholding
imagesc(test)
pause(0.1)

seD= strel('disk',1);%Use a disk as structuring element to keep edges round
se5= strel('disk',5);
test1= imdilate(test,se5);
imagesc(test1); pause(0.1)
test2= imfill(test1,'holes');%Fills holes
test2= bwareaopen(test1,75);%Cleans up image to remove objects less than 75px in size
test2= imclearborder(test2);%
test2= imfill(test2,'holes');
imagesc(test2); pause(0.1)
mask= test2;
stats= regionprops(mask,'Centroid');
centroid= stats.Centroid;
hold
plot(centroid(1),centroid(2),'og')