%Quick and dirty rigid translational image registration
%Uses dftregistration function created by Manuel Guizar [1] and Matlab's
%imtranslate function. 
%[1]
%Link: http://www.mathworks.com/matlabcentral/fileexchange/18401-efficient-subpixel-image-registration-by-cross-correlation 
%and Manuel Guizar-Sicairos, Samuel T. Thurman, and James R. Fienup,
%"Efficient subpixel image registration algorithms," Opt. Lett. 33, 156-158 (2008).

function [alignedImage,rowTransl,colTransl]= alignImage(imageToAlign,referenceImage);

shifts= dftregistration(fft2(referenceImage),fft2(imageToAlign),1);%Will use fft of images to align to 1 pixel accuracy
%Change third parameter to increase accuracy (10= 1/10 pixel accuracy,
%100= 1/100 pixel accuracy. See link for more info.
rowTransl= shifts(3);%Rows to translate
colTransl= shifts(4);%Columns to translate

alignedImage= imtranslate(imageToAlign,[shifts(3),shifts(4)],0,'linear',1);%Row,column shift,0 = value of padding cells, 'linear' is default method to translate, 1 keeps same dimensions size as original


