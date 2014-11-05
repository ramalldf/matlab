%This function takes list and creates a scatter plot with non-overlapping
%coordinates. With help from Jack Chai. Updated 9/2/14, 2:03 am, diego

function [randXAxis]= scatterP2(yAxis);

xAxis= 1:length(yAxis);%Counts number of x coordinates to generate
randXAxis=xAxis+0.05*randn(size(xAxis)); %to offset each yellow pts slightly so they don't overlap

%%% plotting command %%%


figure('Color','w'); plot(randXAxis,yAxis,'ob','Markersize', 8, 'MarkerFaceColor','r','MarkerEdgeColor','k')
ylabel('Lifetime (ps)','FontSize',14,'FontWeight','bold')

xlim([0 length(yAxis)+1])

hold on

 meanPlotLen= [1,randXAxis(end)+1];%Xaxis for mean
 meanPlotVals= [mean(yAxis),mean(yAxis)];%Plot mean line Y values
plot(meanPlotLen,meanPlotVals,'g','LineWidth',4)
set(gca,'FontSize',14,'color','w','FontWeight','bold')

