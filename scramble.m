function [scrambledImage] = scramble(origImage);

scrambX= origImage(randperm(length(origImage(:))));
scrambXResh= reshape(scrambX,size(origImage));
scrambledImage= scrambXResh;

