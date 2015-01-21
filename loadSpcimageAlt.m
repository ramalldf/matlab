clearex('lifeScale','whiteCMap')
close all

%%=Name files=%%
prefix= input('Prefix of FLIM files: ');
%prefixSp5= prefix(1:end-1);
prefixSp5= input('Prefix of sp5: ');

life= 'color coded value.asc';
chi= 'chi.asc';
int= 'photons.asc';
t1= 't1.asc';
t2= 't2.asc';
%t3= 't3.asc';
a1= 'a1.asc';
a2= 'a2.asc';
%a3= 'a3.asc';
a1p= 'a1[%].asc';
a2p= 'a2[%].asc';
%a3p= 'a3p.asc';
scatter= 'scatter.asc';
offset= 'offset.asc';
shift= 'shift.asc';
residuals= 'residuals.asc';


%%=Load files=
%==Sp5 files
stackSp5= tiffread2(['' prefixSp5 '.tif']);

green= double(stackSp5(1,1).data);
%red= double(stackSp5(1,2).data);
bright= double(stackSp5(1,2).data);


%==FLIM files
rawChi= importdata(strcat(prefix,chi));
rawLife= importdata(strcat(prefix,life));
rawInt= importdata(strcat(prefix,int));
t1= importdata(strcat(prefix,t1));
t2= importdata(strcat(prefix,t2));
%t3= importdata(strcat(prefix,t3));
a1= importdata(strcat(prefix,a1));
a2= importdata(strcat(prefix,a2));
%a3= importdata(strcat(prefix,a3));
a1p= importdata(strcat(prefix,a1p));
a2p= importdata(strcat(prefix,a2p));
%a3p= importdata(strcat(prefix,a3p));
scatter= importdata(strcat(prefix,scatter));
offset= importdata(strcat(prefix,offset));
shift= importdata(strcat(prefix,shift));
residuals= importdata(strcat(prefix,residuals));

label= strcat('ThrLife',prefix);


%%=Align spcimage to sp5 data=

[alignInt,rowTransl,colTransl]= alignImage(rawInt,green);
[alignLife]= imtranslate(rawLife,[rowTransl,colTransl],0,'linear',1);
[alignChi]= imtranslate(rawChi,[rowTransl,colTransl],0,'linear',1);

[thrLife, lowThr, hiThr]= threshImage(alignChi,alignLife,0.9,2);

[thrLife2, lowThr2, hiThr2]= threshImage(alignInt,thrLife,25,300);

%%=Wrap data=
rawData= struct();

rawData.rawChi= rawChi;
rawData.rawLife= rawLife;
rawData.rawInt= rawInt;
rawData.t1= t1;
rawData.t2= t2;
%t3= importdata(strcat(prefix,t3));
rawData.a1= a1;
rawData.a2= a2;
%a3= importdata(strcat(prefix,a3));
rawData.a1p= a1p;
rawData.a2p= a2p;
%a3p= importdata(strcat(prefix,a3p));
rawData.scatter= scatter;
rawData.offset= offset;
rawData.shift= shift;
rawData.residuals= residuals;

rawData.green= green;
rawData.bright= bright;
%rawData.red= red;
rawData.thrLife= thrLife;
rawData.thrLife2= thrLife2;
rawData.alignInt= alignInt;
rawData.alignLife= alignLife;
rawData.alignChi= alignChi;
rawData.rowTransl= rowTransl;
rawData.colTransl= colTransl;

imagesc(thrLife2, [1600 2300])
pause(1)


finalEFF= uint16(thrLife2);


imwrite(finalEFF, ['FinalThrLife' num2str(prefix) '.tif'], 'WriteMode', 'append')

finalInt= uint16(alignInt);


newfig
intLifePlot= plot(alignInt(:),thrLife2(:), '.');
xlabel('Intensity (a.u.)')
ylabel('Lifetime (ps)')
ylim([0 3000])
figure; 
hist(thrLife2(:),3000);
lifeHist= gcf;
set(gcf,'Color',[1 1 1])%Set background to white, colormap to whiteCMap
xlabel('Lifetime (ps)')
ylabel('Density')
xlim([0 3000])

% clear all 
saveas(intLifePlot,['' prefix ' plot int vs thrLife2.fig'])
saveas(lifeHist,['' prefix ' hist thrLife2.fig'])

imwrite(finalInt, ['Int ' num2str(prefix) '.tif'])

clearvars -except rawData lifeScale whiteCMap thrLife2 alignInt alignChi prefix green bright red

save(['' num2str(prefix) '.mat'])



