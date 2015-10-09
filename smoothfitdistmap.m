% ============================
% %=Centroid and smoothmap =
% ============================
%==Find centroid, make distance map==
[mask,Centroid]= maskCentroid(bright);
distMap= dist2Pt(Centroid,bright);%Uses actin image to make dist map
%because it has more points to work with than m2b channel

%=Test smoothmap for lifetime data=
close all
tic

[intSmooth,distMapSmooth1,index1]= smoothMap(distMap,alignInt,20);%The distMapSmooth and index variables should be the same for both actin and m2b
smIntFig= gcf;
[thrLife2Smooth,distMapSmooth2,index2]= smoothMap(distMap,thrLife2,20);%
toc

%=Linear fit=
smFitExclusion = (distMapSmooth2 >= 96);%Exclude anything above threshold

ft_ = fittype('poly1');%Linear fit
[smFit,gof] = fit(distMapSmooth2,thrLife2Smooth,ft_,'Exclude',smFitExclusion)
plot(smFit)
smLifeFig= gcf;
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

