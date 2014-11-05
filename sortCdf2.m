%Makes cdf and plots in color of choice

function [sortedList,intervals]= sortCdf2(matrix,color);%

matrixList= matrix(:);
matrixList= matrixList(find(matrixList>0));
sortedList= sort((matrixList(:)));
intervals= [1./length(sortedList):1./length(sortedList):1];
%figure
plot(sortedList, intervals,'color',color,'LineWidth',2)
%plot(sortedList, intervals,'color',whiteCMap)

med= median(sortedList);

%['label'

xlabel('Lifetime (ps)')
ylabel('Probability')
xlim([0 3000])
ylim([0 1])



