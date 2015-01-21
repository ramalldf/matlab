%Sorts and smooths distmap and plots them
%Requires pair of distance map and intensity map

function [intensityIndexSmooth,distMapSmooth,index]= smoothMap(distMap,image,steps);

%==Sort distance map==

[distMapSort, index] = sort(distMap(:));
intensityIndex = image(index);

indexnotnan = find(~isnan(intensityIndex));
intNonNan = intensityIndex(indexnotnan);
distMapSortNonNan = distMapSort(indexnotnan);
% 
distMapSmooth = smooth(distMapSortNonNan,steps);
intensityIndexSmooth = smooth(intNonNan,steps);

% disp('Here')
% disp(length(distMapSortNonNan(:)))
% disp('Here again')
% disp(length(intensityIndex(:)))
% distMapSmooth = smooth(distMapSortNonNan(1:40000),steps);
% %intensityIndexSmooth = smooth(intensityIndex(1:40000),steps);
% intensityIndexSmooth = smooth(intNonNan(1:40000),steps);

% figure
% plot(distMapSortNonNan,image(:),'.')
% plot(distMapSmooth,intensityIndexSmooth,'.g')
% smoothDistLife= gcf;
% xlabel('Distance (pixels')
% ylabel('Lifetime (ps)')


figure
plot(distMapSort,intensityIndex,'.')
hold
plot(distMapSmooth,intensityIndexSmooth,'.g')
smoothDistLife= gcf;
xlabel('Distance (pixels')
% ylabel('Lifetime (ps)')