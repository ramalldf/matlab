%Updated 9/7/15: Script loads raw files, measures background values in each channel,
%corrects each channel image for background, and fret channel for
%bleed-through before calculating FRET efficiency. Finally, it thresholds
%based on acceptor channel image, and writes (exports) files

%fretwheel_tested.m requires following files in directory:
%*Registered donor, fret, acceptor channel images using same prefix, ie.
%'stackdonor.tif', 'stackfret.tif', 'stackacceptor.tif'
%tiffread2.m = reads .tiff stacks
%*getMeanRoi.m = measures mean of pixel values in 11x11 box centered at
%selection point
%*threshImage.m = thresholds image based on given intensity range of reference
%image

close all

%%Load files using a common prefix%%
labelEFF= input('Label for written file: ');

donorStack= tiffread2(['' labelEFF 'donor.tif']);
fretStack= tiffread2(['' labelEFF 'fret.tif']);
acceptorStack= tiffread2(['' labelEFF 'acceptor.tif']);

%Select location to measure background in donor,fret, acceptor channels
imagesc(acceptorStack(1,1).data, [0 1000])
[donorBack,xBack,yBack]= getMeanRoi(donorStack(1,1).data);

%Apply xBack and yBack coordinates to get mean background values for
%fret/acceptor channels
[fretBack,xBack,yBack]= getMeanRoi(fretStack(1,1).data,xBack,yBack);
[acceptorBack,xBack,yBack]= getMeanRoi(acceptorStack(1,1).data,xBack,yBack);

%Bleed-through values 
btdonor= 0.6072;%40x air updated 1/21/15; May be different for your system
btacceptor= 0.0437

%Initialize structures to save processed FRET images
EFFStack= struct();

%Loop through each image in stack and calculate FRET efficiency images
for counter= 1:length(donorStack)
    
    donor= donorStack(1,counter).data;
    fret= fretStack(1,counter).data;
    acceptor= acceptorStack(1,counter).data;
    
    %Apply background subtraction
    donor= donor-donorBack; fret= fret-fretBack; acceptor= acceptor-acceptorBack;

    %Convert to floating point to multiply by bleedthrough constants
    donor= single(donor); fret= single(fret); acceptor= single(acceptor);
    fretcorrected= fret - donor.*(btdonor) - acceptor.*(btacceptor);%Bleedthrough correction for donor and acceptor channels.
    
    %Calculate FRET efficiency with corrected fretcorrected and donor chs
    efficiency= 100.*(fretcorrected./(fretcorrected+donor));
    
    %Threshold efficiency (mask) image using acceptor channel (100 to Inf)
    EFFStack(1,counter).data= efficiency;%Save to structure
    mask_efficiency2= threshImage(acceptor,efficiency,100,Inf);%Mask
    maskEFFStack2(1,counter).data= mask_efficiency2;%Save to structure
    
    %Convert to unsigned integer to write raw and masked efficiency files
    EFF= uint16(efficiency);  
    maskEFF2= uint16(mask_efficiency2);
    imwrite(EFF,['' num2str(labelEFF) 'Eff.tif'], 'WriteMode', 'append')
    
    imwrite(maskEFF2,['' num2str(labelEFF) 'MaskEff2.tif'], 'WriteMode', 'append')

    close all
end

save(['' num2str(labelEFF) '.mat'])%Save variables to mat file
    

