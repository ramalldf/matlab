%Sorts and smooths distance map and plots sorted distance map and
%corresponding intensity value
%Requires pair of distance map and intensity map, steps= size of moving avg.
%filter

function [intensityIndexSmooth,distMapSmooth,index]= smoothMap(distMap,image,steps);

%==Sort distance map==

[distMapSort, index] = sort(distMap(:));%Sorts distance map and exports indices of sorted data
intensityIndex = image(index);%New vector using indices of ordered elements

indexnotnan = find(~isnan(intensityIndex));%Find indices of non-Nan elements
intNonNan = intensityIndex(indexnotnan);%New int vector with non-Nan indices of ordered elements
distMapSortNonNan = distMapSort(indexnotnan);%Apply non-Nan filter to sorted distance map too
% 
distMapSmooth = smooth(distMapSortNonNan,steps);%Smooth ordered distance map
intensityIndexSmooth = smooth(intNonNan,steps);%Smooth ordered intensity map

figure
plot(distMapSort,intensityIndex,'.')%Plots data before smoothing
hold
plot(distMapSmooth,intensityIndexSmooth,'.g')%After smoothing
smoothDistLife= gcf;
xlabel('Distance (pixels')
% ylabel('Lifetime (ps)')