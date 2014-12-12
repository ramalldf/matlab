%distMap smooth
clear all
close all

file= input('Name of file?: ');
load(file)

distMap= dist2Pt(Centroid,thrLife2);
[distmapsort, index] = sort(distMap(:));
thrLife2sort = thrLife2(index);

indexnotnan = find(~isnan(thrLife2sort));
thrLife2notnansort = thrLife2sort(indexnotnan);
distamp2notnansort = distmapsort(indexnotnan);

distmapsmooth = smooth(distamp2notnansort,20);
thrlifesmooth = smooth(thrLife2notnansort,20);
newfig
plot(distamp2notnansort,thrLife2notnansort,'.')
hold
plot(distmapsmooth,thrlifesmooth,'.g')
smoothDistLife= gcf;
xlabel('Distance (pixels')
ylabel('Lifetime (ps)')
title(file)
xlim([0 100])
ylim([500 3000])

saveas(smoothDistLife,['cell' name ' plot smoothDistLife.fig'])
save(['cell' file '_smoothdistmap.mat'])

% coeffs= [];
% fit2Gauss= fit(distmapsmooth',thrlifesmooth,'gauss2')
% coeffs= coeffvalues(fit2Gauss);