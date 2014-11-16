%Uses parametric equation for ellipse
%x= offsetX + a*cos(t);
%y= offsetY+ b*cost(t);

function [x,y]= ellips(Centroid,MajorAxisLength,MinorAxisLength,Orientation);

phi= linspace(0,2*pi,100);% 0 to 2pi, 100 regularly-spaced points

offsetX = Centroid(1);%Coordinates for center of the cell
offsetY = Centroid(2);

longRadius = MajorAxisLength/2;%Radius would be this length divided by two
shortRadius = MinorAxisLength/2;

theta = pi*Orientation/180;
R = [cos(theta),sin(theta);-sin(theta),cos(theta)];%Orientation of ellipse

xy = [longRadius*cos(phi); shortRadius*sin(phi)];%Ellipse pre orientation
xy = R*xy;%Ellipse post orientation

x = xy(1,:) + offsetX;%x coordinates
y = xy(2,:) + offsetY;%y coordinates

plot(x,y,'.g','LineWidth',2);