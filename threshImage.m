% [threshed, lowBound, highBound]= threshImage(image, lowBound, highBound)
%Returns thresholded image with upper and lower bounds

function [threshedSource, lowBound, highBound]= threshImage(maskSource, targetSource, lowBound, highBound);

%maskSource= single(maskSource);%Turns to floating point which will make a difference later.

[x,y]= size(maskSource);
threshedSource = targetSource;
threshedSource(find(maskSource>highBound)) = NaN;
threshedSource(find(maskSource<lowBound)) = NaN;


% for i= 1:x
%     for j= 1:y
%         if maskSource(i,j)> highBound% Thresholding out high values
%             threshedSource(i,j)= NaN;
%         elseif maskSource(i,j)< lowBound%Thresholding low values
%                 threshedSource(i,j) = NaN;
%             else
%                 threshedSource(i,j)= targetSource(i,j);
%             end
%         end
%     end
% end
% 


                