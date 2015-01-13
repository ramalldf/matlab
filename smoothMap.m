%Sorts and smooths distmap and plots them
%Requires pair of distance map and intensity map

function [intensityIndexSmooth,distMapSmooth,index]= smoothMap(distMap,image,steps);

%==Sort distance map==

[distMapSort, index] = sort(distMap(:));
intensityIndex = image(index);

indexnotnan = find(~isnan(intensityIndex));
intNonNan = intensityIndex(indexnotnan);
distMapSortNonNan = distMapSort(indexnotnan);

distMapSmooth = smooth(distMapSortNonNan,steps);
intensityIndexSmooth = smooth(intensityIndex,steps);
% figure
% plot(distMapSortNonNan,intNonNan,'.')
% hold
% plot(distMapSmooth,intensityIndexSmooth,'.g')
% smoothDistLife= gcf;
% xlabel('Distance (pixels')
% ylabel('Lifetime (ps)')

% title(file)
% xlim([0 200])
% ylim([500 3000])