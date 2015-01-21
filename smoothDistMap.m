%distMap smooth
clearex('lifescale','whiteCMap')
close all
newfig

file= input('Name of file?: ');
cell= tiffread2(['' file '.tif']);

m2b= cell(1,1).data;
actin= cell(1,2).data;

%==Find centroid, make distance map==
[mask,centroid]= maskCentroid(actin);
distMap= dist2Pt(centroid,actin);%Uses actin image to make dist map
%because it has more points to work with than m2b channel

%==Sort data==
[actinSmooth,distMapSmooth1,index1]= smoothMap(distMap,actin,20);%The distMapSmooth and index variables should be the same for both actin and m2b
[m2bSmooth,distMapSmooth2,index2]= smoothMap(distMap,m2b,20);%

%==Corrections/Normalization==
distMapCorrected= distMapSmooth1/2;%Correction factor for distance to keep it
%consistent with FLIM scope 20x water measurements

actinSmoothNorm= actinSmooth/max(actinSmooth);
m2bSmoothNorm= m2bSmooth/max(m2bSmooth);

%==Figures==
newfig
plot(distMapCorrected,actinSmoothNorm,'.r','MarkerSize',2)
hold
plot(distMapCorrected,m2bSmoothNorm,'.g','MarkerSize',2)
smoothActinM2b= gcf;
xlabel('Distance (pixels)')
ylabel('Intensity')
title(['Distance vs int ' file ''])
xlim([0 100])

saveas(smoothActinM2b,['' file ' plot smoothDistLife.fig'])
save(['' file '_smoothdistmap.mat'])


