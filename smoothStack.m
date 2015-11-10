%Function takes the CENTERED, element-wise moving average of a matrix stack.
%window must be an odd integer: it will round down to nearest odd
%integer if it is even
%Updated 11/9/15
function [outputStack]= smoothStack(inputStack,window);
%Checks to see that window is odd, subtracts window by 1 if even
if rem(window,2) == 0%Uses modulo operation to verify if odd/even
    disp('Window must be an odd integer. Rounding down to:')
    window= window-1
end

%Defines gap between center and edge of window based on window size
interval= (window-1)/2;%

%Lists center frames in output stack for given window size
range= [1+interval:length(inputStack)-interval];

%Initialize your output structure to append averages into
outputStack(length(inputStack))= struct();

%Iterate through frames that have sufficient flanking frames
for i = 1+interval:length(inputStack)-interval
    workingStack= inputStack(1,i-interval:i+interval);%Slice relevant frames in window
    workingCell= struct2cell(workingStack);%Convert to cell array
    workingCell= workingCell(end,1,:);%Pull out data elements from array
    %This happens to be the last element in the cell array

    workingMat= cell2mat(workingCell);%Convert to 3d matrix

    matAvg= mean(workingMat,window);%Average matrices in 3d matrix
    outputStack(i).data = matAvg;%Insert into structure
end

%Redefine output structure to range (removes empty flanking elements)
outputStack= outputStack(1,range);

    


