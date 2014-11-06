%Makes, and cleans up mask, then makes serial edge measurements and plots them.
%Uses one source image (try to make it somewhat clean).
load('C:\Users\D\Documents\MATLAB\whiteCMap','whiteCMap','lifescale')

clearex('whiteCMap','lifescale')%Clear everything except variables for plots
close all
name= input('Cell number?: ');
layers= 30;
load(['cell' name '.mat'],'thrLife2','alignInt','bright')

%%=Find cell and make/clean mask=
%[cb2Data,finalMask,smoothPerim]= cellBound2(thrLife2);%Finds cell (largest object) and cleans up mask
[cb2Data,finalMask,smoothPerim]= cellBound4(bright);%Uses cellBound3 which uses brightfield image for mask
%This also saves all of the metadata for the original mask (ie. perimeter,
%centroid,area,ellipsicity etc)

eccentricity= cb2Data.stats(1,1).Eccentricity;
perimeter0= cb2Data.stats(1,1).Perimeter;
area= cb2Data.stats(1,1).Area;
Centroid= cb2Data.stats(1,1).Centroid;
MajorAxisLength= cb2Data.stats(1,1).MajorAxisLength;
MinorAxisLength= cb2Data.stats(1,1).MinorAxisLength;
Orientation= cb2Data.stats(1,1).Orientation;


[xEllipse,yEllipse]= ellips(Centroid,MajorAxisLength+MajorAxisLength*0.2,MinorAxisLength+MinorAxisLength*0.2,Orientation);%Gives coord for ellipse from given regionprops 
%[xEllipse,yEllipse]= ellips(Centroid,MajorAxisLength,MinorAxisLength,Orientation);%Gives coord for ellipse from given regionprops 
%The above now tells is to expand the width of the ellipse by 20% to make
%sure we include as many pixels as possible
ellipMask= poly2mask(xEllipse,yEllipse,512,512);%Takes coords and fills in area to make a mask

gcf
close
figure
imagesc(finalMask)
hold
plot(xEllipse,yEllipse,'.g')
plot(Centroid(1),Centroid(2),'og')

figure
close
figure
maskPerimPlot= gcf;%%-----------fig

ringData= struct();

perimsMask= [];%Initialize variables to store edge masks and their lifetime values
perimsLife= [];
perimsInt= [];

%hold on

perimeter= perimeter0;
counter0= 1;
counter= counter0;
%%==Make concentric edge masks and apply to lifetime image
while perimeter >= 0.05*perimeter0 %Will isolate 30 rings from peripery
    [erodMask,x,y]= concentric(ellipMask,counter);%Changed this to ellipmask
    edgeMask= edge(erodMask);
  
    perimLife= thrLife2.*(edge(erodMask));
    perimInt= alignInt.*(edge(erodMask));
    

    imagesc(perimLife,[1000 1500])


    pause(0.01)

    perimsMask= [perimsMask,edgeMask(:)];%Adds masks as column in matrix
    perimsLife= [perimsLife,perimLife(:)];
    perimsInt= [perimsInt,perimInt(:)];
    
    perimeter= regionprops(erodMask,'Perimeter')%This is a structure, need next line to get perimeter.
    perimeter= perimeter.Perimeter;
    counter= counter+1;
    
end

ringList= 1:counter-1;
newfig

%%=Select positions for measurements and map specific layers

[posRing,posRingIndex]= find(nansum(perimsLife)>0);%Find all edges whose perimeter lifetime > 0, store index in posRingIndex

ring1= posRingIndex(1);%First, most outer edge mask
ring2= ring1+10;
ring3= ring1+20;
ring4= posRingIndex(end);%Last, most inner edge mask

completeTemp= zeros(512,512);%Initialize zero image matrix (same as our perimsLife matrices) to which you'll add lifetime perimeters 
complete= completeTemp(:);%Vectorizes to give same dimensions as columns we made for perimsLife et al.
complete= complete+ perimsLife(:,ring1)+perimsLife(:,ring2)+perimsLife(:,ring3)+perimsLife(:,ring4);%Adds specific layers to them (should be no overlap since they're different layers)
complete2= reshape(complete,512,512);%Reassembles into a matrix (image)

%%=Find median (0.5 on cdf) for each edge and use as value for image of
%%edge

[midRing1]= cdfPt5(perimsLife(:,ring1),'green');
[midRing2]= cdfPt5(perimsLife(:,ring2),'green');
[midRing3]= cdfPt5(perimsLife(:,ring3),'green');
[midRing4]= cdfPt5(perimsLife(:,ring4),'green');

midRingFour= [midRing1;midRing2;midRing3;midRing4];
% midLayers= 1:30;
% midLayers(layers)= midLayers(:,cdfPt5(perimsLife(:,layers),'green'));

close%Closes last figure from cdfPt5 fxns above

ring1MidMask= perimsMask(:,ring1)*midRing1;%Multiply median ring value by particular mask
ring2MidMask= perimsMask(:,ring2)*midRing2;
ring3MidMask= perimsMask(:,ring3)*midRing3;
ring4MidMask= perimsMask(:,ring4)*midRing4;

completeMidRings= completeTemp(:)+ring1MidMask+ring2MidMask+ring3MidMask+ring4MidMask;%Add values to make new image
completeMidRings= reshape(completeMidRings,512,512);


newfig%%---------------fig
plotRings= gcf;
col1= rand(1,3);
col2= rand(1,3);
col3= rand(1,3);
col4= rand(1,3);

plot(perimsLife(:,1),'.','color',col1)
hold on
plot(perimsLife(:,10),'.','color',col2)
plot(perimsLife(:,20),'.','color',col3)
plot(perimsLife(:,30),'.','color',col4)

xlabel('Pixel index','FontWeight','bold','FontSize',14)
ylabel('Lifetime (ps)','FontWeight','bold','FontSize',14)

newfig%%--------------fig
cdfRings= gcf;
sortCdf2(perimsLife(:,1),col1);
hold
sortCdf2(perimsLife(:,10),col2);
sortCdf2(perimsLife(:,20),col3);
sortCdf2(perimsLife(:,30),col4);

xlabel('Lifetime (ps)', 'FontWeight','bold','FontSize',14)
ylabel('Probability','FontWeight','bold','FontSize',14)

newfig%%------------fig
mapRings= gcf;
imagesc(thrLife2,[1000 2300])
pause(2)
imagesc(complete2,lifescale)
colorbar
 
newfig%%----------fig
mapRingsMid= gcf;
imagesc(completeMidRings,[1600 1800])
colorbar

ringData.perimsLife= perimsLife;
ringData.perimsMask= perimsMask;
ringData.complete2= complete2;
ringData.perimsInt= perimsInt;

scriptUsed= importdata('rings6.m');%Saves content of script I used


% xlim([100 400])
% ylim([100 400])

%Uncomment if you want it to go faster
% saveas(smoothPerim,['cell ' name ' plot smoothPerim.fig'])
% saveas(plotRings,['cell ' name ' plot ringsPixels.fig'])
% saveas(cdfRings,['cell ' name ' cdf rings.fig'])
% saveas(mapRings,['cell ' name ' imagesc mapRingsLife.fig'])
% saveas(mapRingsMid,['cell ' name ' imagesc rawMask.fig'])

newfig
midLifeLayers= [];
midIntLayers= [];
for layers= 1:counter-1% Number of rings
 singleLifeLayer= cdfPt5(perimsLife(:,layers),'green');%Finding pt5 for each
 singleIntLayer= cdfPt5(perimsInt(:,layers),'green');%Finding pt5 for each

 
 midLifeLayers= [midLifeLayers;singleLifeLayer];
 midIntLayers= [midIntLayers;singleIntLayer];
 
end

plotMidRings= plot(midLifeLayers,'LineWidth',2);
hold
plot(midIntLayers,'r','LineWidth',2)

xlabel('Ring Index (pixel)','FontWeight','bold','FontSize',14)
ylabel('Median Lifetime (ps)','FontWeight','bold','FontSize',14)
title(['cell ' name ' rings'])

figure
lifeIntPlot= plotyy(1:length(midLifeLayers),midLifeLayers,1:length(midIntLayers),midIntLayers);

%Comment out below if you want it to go faster
title(['cell ' name ' Int vs Life'])

%saveas(plotMidRings,['cell ' name ' plot midRings.fig'])
%saveas(lifeIntPlot,['cell ' name ' plot lifeIntRings.fig'])

save(['cell' name ' ellipRings.mat'])

