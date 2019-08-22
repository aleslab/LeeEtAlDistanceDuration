%actual timings are: 0.5-0.2 for no gap, 0.5-0.5-0.2 for 0.5s gap and
%0.5-1-0.2 for 1s gap, so 0.7, 1.2 and 1.7s, but then everything has a
%static 0.25s at the beginning, so 0.95, 1.45 and 1.95 in total

nT = 1950; %950, 1450 and 1950?
nX = 548; %219*5; %full screen is 21.9 deg

stimMat = zeros(nX,nT);
stimStart = 30; %the start position of the line on the screen. 
%In deg, 2.95deg from left edge, 8 deg from centre. rounded 29.5 - from
%2.95 deg
degVel = 2; %1; %20 deg/s
degVel2 = 3; %1.5; %30 deg/s 
barWidth = 4; %tthis is only if it's wider than one pixel
preStim = 250;
gapStart = 750; %after 0.25 static and first 0.50 of movement
gapDuration = 1000; %0, 500 or 1000

for iT = 1:preStim
    
    stimLocation = stimStart;
    stimMat(stimLocation: stimLocation+barWidth, iT) = 1;
    
end

for iT = preStim+1:gapStart-1
    
    stimLocation = round(stimLocation + degVel);
    stimMat(stimLocation: stimLocation+barWidth, iT) = 1;
    
end

for iT = gapStart:gapStart+gapDuration
    
  stimMat(stimLocation: stimLocation + barWidth, iT) = 1;
    
end

for iT = gapStart+gapDuration+1: nT
    
  stimLocation = round(stimLocation + degVel2);
    stimMat(stimLocation: stimLocation+barWidth, iT) = 1;  
    
end
figure(107)
imagesc(stimMat);

figure(108)
fourierMat = fft2(stimMat);
imagesc(fftshift(abs(fourierMat)));
