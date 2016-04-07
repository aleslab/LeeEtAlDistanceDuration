function [expInfo] = drawFixation(expInfo, fixationType, responseSquare, apetureType)
% A function to draw fixation crosses, boxes around fixation crosses and an
% apeture to aid fixation.

%expInfo.stereoMode = 4;
%% Basic fixation cross

%x centre is expInfo.center(1)
%y centre is expInfo.center(2)
fixCrossDimPix = 20; %the size of the arms of our fixation cross
fixXCoords = [-fixCrossDimPix fixCrossDimPix 0 0]; %fixation cross x coordinates
fixYCoords = [0 0 -fixCrossDimPix fixCrossDimPix]; %fixation cross y coordinates
expInfo.FixCoords = [fixXCoords; fixYCoords]; %combined fixation cross coordinates
expInfo.fixWidthPix = 1; %the line width of the fixation cross
expInfo.lw = 1;

if strcmp(fixationType, 'cross');
    Screen('SelectStereoDrawBuffer', expInfo.curWindow, 0);
    Screen('DrawLines', expInfo.curWindow, expInfo.FixCoords, expInfo.fixWidthPix, 0, expInfo.center, 0);
    Screen('SelectStereoDrawBuffer', expInfo.curWindow, 1);
    Screen('DrawLines', expInfo.curWindow, expInfo.FixCoords, expInfo.fixWidthPix, 0, expInfo.center, 0);
end

%% box surrounding fixation cross when you can make a response

leftPointX = expInfo.center(1) - 30;
rightPointX = expInfo.center(1) + 30;
PointY1 = expInfo.center(2) + 30;
PointY2 = expInfo.center(2) - 30;

boxXcoords = [leftPointX leftPointX rightPointX rightPointX leftPointX rightPointX leftPointX rightPointX];
boxYcoords = [PointY1 PointY2 PointY1 PointY2 PointY1 PointY1 PointY2 PointY2];
expInfo.boxCoords = [boxXcoords; boxYcoords];

if responseSquare == 1;
    Screen('SelectStereoDrawBuffer', expInfo.curWindow, 0);
    Screen('DrawLines', expInfo.curWindow, expInfo.boxCoords, expInfo.lw, 0);
    Screen('SelectStereoDrawBuffer', expInfo.curWindow, 1);
    Screen('DrawLines', expInfo.curWindow, expInfo.boxCoords, expInfo.lw, 0);
end

%% apeture drawing

[screenXpixels, screenYpixels] = Screen('WindowSize', expInfo.curWindow);

if strcmp(apetureType, 'frame');
    
    rectSize = 100;
    
    leftRectMat = randn([screenYpixels, rectSize]);
    rightRectMat = randn([screenYpixels, rectSize]);
    topHorzMat = randn([rectSize, screenXpixels]);
    bottomHorzMat = randn([rectSize, screenXpixels]);
    
    leftRectLocation = [0 0 rectSize screenYpixels];
    rightRectLocation = [(screenXpixels-rectSize) 0 screenXpixels screenYpixels];
    topRectLocation = [0 0 screenXpixels rectSize]; %this draws the top rectangle along the entire length of the top of the screen
    bottomRectLocation = [0 (screenYpixels-rectSize) screenXpixels screenYpixels];
    
    leftRectTexture = Screen('MakeTexture', expInfo.curWindow, leftRectMat);
    Screen('SelectStereoDrawBuffer', expInfo.curWindow, 0);
    Screen('DrawTexture', expInfo.curWindow, leftRectTexture, [], [leftRectLocation]);
    Screen('SelectStereoDrawBuffer', expInfo.curWindow, 1);
    Screen('DrawTexture', expInfo.curWindow, leftRectTexture, [], [leftRectLocation]);
    
    rightRectTexture = Screen('MakeTexture', expInfo.curWindow, rightRectMat);
    Screen('SelectStereoDrawBuffer', expInfo.curWindow, 0);
    Screen('DrawTexture', expInfo.curWindow, rightRectTexture, [], [rightRectLocation]);
    Screen('SelectStereoDrawBuffer', expInfo.curWindow, 1);
    Screen('DrawTexture', expInfo.curWindow, rightRectTexture, [], [rightRectLocation]);
    
    topHorzTexture = Screen('MakeTexture', expInfo.curWindow, topHorzMat);
    Screen('SelectStereoDrawBuffer', expInfo.curWindow, 0);
    Screen('DrawTexture', expInfo.curWindow, topHorzTexture, [], [topRectLocation]);
    Screen('SelectStereoDrawBuffer', expInfo.curWindow, 1);
    Screen('DrawTexture', expInfo.curWindow, topHorzTexture, [], [topRectLocation]);
    
    bottomHorzTexture = Screen('MakeTexture', expInfo.curWindow, bottomHorzMat);
    Screen('SelectStereoDrawBuffer', expInfo.curWindow, 0);
    Screen('DrawTexture', expInfo.curWindow, bottomHorzTexture, [], [bottomRectLocation]);
    Screen('SelectStereoDrawBuffer', expInfo.curWindow, 1);
    Screen('DrawTexture', expInfo.curWindow, bottomHorzTexture, [], [bottomRectLocation]);
    
    
end

end



