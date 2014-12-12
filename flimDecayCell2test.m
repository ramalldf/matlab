

%test is raw data of photons collected. It is 16538x256; the 16538
%corresponds to pixels positions (512x512 normally but now I just have a
%portion of that to allow for quicker testing. 256 refers to the time
%points for each pixel
%If I wanted to analyze a 100x100 image with its time points, i'd take only
%the first 10,000 rows of that matrix. Thus:

set(0,'DefaultFigureWindowStyle','docked')%Have figure docked by default
%==Load raw data=
%Need to import and select only the cells that I'm interested in, then
%convert the cell to mat format to give me a 2d matrix
m= dlmread('cell2flimdecaytest3Full.img_binned_raw_data','',11,1);
indices= vect2block(fullInt,50,50);
test0=m(indices,:);
%==Convert to 3D matrix

test1(20,20,255)=0;%Initialize a 20x20x255 matrix

%===Jack's help===

%Test2 is 400x255 and we want to turn it to 20x20x255
for counter= 1:255
test1(:,:,counter)= vec2mat(test0(:,counter),20);%Loop through each column for 10 rows to make 10x10 matrix
counter
end

%==Binning=

%Assign mask/structuring element  that will filter only the values you
%want, we'll call it 'bin'
bin= [1,1,1;1,1,1;1,1,1];

testBin2(20,20,255)= zeros;%Initialize binned matrix

%=The following will convolve bin mask with data through each timepoint's
%matrix
for counter= 1:255
    testBin2(:,:,counter)= conv2(test1(:,:,counter),bin,'same');
end

test3= reshape(testBin2,[400 255]);

exc= (time<= 50);%Logical exclusion rule 
fitParams= [];%List of all constants from fits
totalCounts=[];%Sum of all counts in decay 
for counter= 1:length(time)
    counts=  sum(test3(counter,:));%Counts events
    if counts<100%Threshold to fit, if below, fill in with NaN's
        coeffs=[NaN,NaN,NaN,NaN];
        fitParams = [fitParams;coeffs]; 
        totalCounts= [totalCounts;counts];
        
    else
    fits= fit(time,transpose(test3(counter,:)),'exp2','Exclude',exc);
    disp('fine')
    coeffs= coeffvalues(fits);
    disp('fine 2')
    fitParams= [fitParams;coeffs];
    totalCounts= [totalCounts;counts];
    disp('fine 3')
    counter
    end
end
