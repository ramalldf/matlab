%Plots cdf and finds value at probability = 0.5
%pt5Val should be close to the value for the mean for normal distrib.

function [pt5Val]= cdfPt5(matrix,color);%Uses sortCdf2 fxn which requires color for plot

[cdfVal,valInter]= sortCdf2(matrix,color);

midVal= 0.5;%For single gaussian mean will be at 0.5 so we'll be looking for lifetime value that's at interval position 0.5
closer= abs(valInter-midVal);%Make new vector of abs of interval coordinates - desired coordinate, 0.5
[closest,closestMidInt]= min(closer);%Finds [magnitude of smallest difference, coordinate in vector] of where 0.5 will be

pt5Val= cdfVal(closestMidInt);

% hold
% plot(pt5Val,midVal,'ob')