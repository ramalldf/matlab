%Finds the nanmedian of your population. Adds a cdf plot as an optional arg
%argument 1: matrix or vector
%argument 2: 'Color' of your cdf plot that will be generated
%ie. [medLifetime]= medianCdf(matrix, 'green');

function [med]= medianCdf(varargin)% Varargin allows for optional arguments
if length(varargin)==1 %Case with one argument
    data= varargin{1};%Excludes NaNs
    med= nanmedian(data(:));
elseif length(varargin)==2 %Case with two arguments
    data= varargin{1};
    med= nanmedian(data(:));
    
    %%=cdf plot=
matrixList= data(:);
matrixList= matrixList(find(matrixList>0));
sortedList= sort((matrixList(:)));
intervals= [1./length(sortedList):1./length(sortedList):1];
plot(sortedList, intervals,'color',varargin{2},'LineWidth',2)
xlabel('Lifetime (ps)')
ylabel('Probability')
xlim([0 3500])
ylim([0 1])
    
end

    
