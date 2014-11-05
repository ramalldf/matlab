%function newfig(whiteCMap);

figure
set(gcf,'Color',[1 1 1],'Colormap',whiteCMap)%Set background to white, colormap to whiteCMap
% Create ylabel
axis off
axes('FontWeight','bold','FontSize',14);
xlabel('X label','FontWeight','bold','FontSize',14);
ylabel('Y label','FontWeight','bold','FontSize',14);
