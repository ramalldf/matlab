function [fitParams,totalCounts] = autoFits4(time,decayMatrix,exclusion);

tic
time= time(1:length(decayMatrix(1,:)));%Matches length of x and y
% ft = fittype('a.*exp(-x/b) + c.*exp(-x/d) + e',...
%     'dependent',{'y'},'independent',{'x'},...
%     'coefficients',{'a', 'b', 'c', 'd', 'e'});
exc= (time<=exclusion);
fitParams= [];%List of all constants from fits
totalCounts=[];%Sum of all counts in decay 
for counter= 1:length(decayMatrix(:,1))   
    counts=  sum(decayMatrix(counter,:));%Counts events
    e= counts;
    fo = fitoptions('method','NonlinearLeastSquares','Lower',[0 500   0 500   0],'Upper',[1 3000    1 3000 1000],'Exclude',exc);
    ft = fittype('a.*exp(-x/b) + c.*exp(-x/d) + e',...
    'dependent',{'y'},'independent',{'x'},...
    'coefficients',{'a', 'b', 'c', 'd', 'e'});
    if counts<200%Threshold to fit, if below, fill in with NaN's
        coeffs=[NaN,NaN,NaN,NaN];
        fitParams = [fitParams;coeffs]; 
        totalCounts= [totalCounts;counts];
        
    else
    fits= fit(time,transpose(decayMatrix(counter,:)),ft,fo);
    %disp('fine')
    coeffs= coeffvalues(fits);
    %disp('fine 2')
    fitParams= [fitParams;coeffs];
    totalCounts= [totalCounts;counts];
    %disp('fine 3')
    end
end
toc