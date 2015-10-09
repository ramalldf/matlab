% ============================
% %=Centroid and smoothmap =
% ============================
%This script uses brightfield, intensity, and lifetime maps along with the
%file prefix to order the pixels based on their distance from the cell
%centroid. It then fits a line to the sorted lifetime data.

%==Find centroid, make distance map==
[mask,Centroid]= maskCentroid(bright);
distMap= dist2Pt(Centroid,bright);%Uses brightfield image in workspace to make distance map
%because it has more points to work with than m2b channel

%=Use smoothmap to spatially smooth intensity (alignInt) and lifetime (thrLife2) data in your workspace=
close all
tic

[intSmooth,distMapSmooth1,index1]= smoothMap(distMap,alignInt,20);%The distMapSmooth and index variables should be the same for both int and life channels
smIntFig= gcf;
[thrLife2Smooth,distMapSmooth2,index2]= smoothMap(distMap,thrLife2,20);%Second channel to analyze
toc

%=Linear fit=
smFitExclusion = (distMapSmooth2 >= 96);%Exclude anything above threshold

ft_ = fittype('poly1');%Specifies linear fit
[smFit,gof] = fit(distMapSmooth2,thrLife2Smooth,ft_,'Exclude',smFitExclusion)
plot(smFit)
smLifeFig= gcf;%Define plot to save it
smCoeffNames= coeffnames(smFit);%List coeff parameters, values, formula
smCoeffVals= coeffvalues(smFit);
smFormula= formula(smFit);

saveas(smIntFig,['' prefix 'dist vs intensity.fig'])
saveas(smLifeFig,['' prefix 'dist vs lifetime.fig'])

save(['' prefix '_Distmap fits.mat'])

fileNames= [fileNames;prefix];
totalCoeffNames= [totalCoeffNames;smCoeffNames'];
totalCoeffs= [totalCoeffs;smCoeffVals];

clearex('whiteCMap','lifescale','fileNames','totalCoeffNames','totalCoeffs')

