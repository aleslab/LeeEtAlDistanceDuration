%Adapted from Peter Scarfe's PTB demos (at http://peterscarfe.com/) and 
%the PTB-3 MovingLineDemo.
% Clear the workspace and the screen
close all;
clear all;
sca

% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2);

% Get the screen numbers. This gives us a number for each of the screens
% attached to our computer. For help see: Screen Screens?
screens = Screen('Screens');

screenNumber = max(screens);

% Define black and white (white will be 1 and black 0).
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
grey = white / 2;
%% Generating the window with the line
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, black);

% Get the size of the on screen window in pixels.
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Query the frame duration
ifi = Screen('GetFlipInterval', window); %taken from PTB-3 MovingLineDemo
vbl=Screen('Flip', window); %taken from PTB-3 MovingLineDemo
% Get the centre coordinate of the window in pixels
%[xCenter, yCenter] = RectCenter(windowRect);

% basically for adapting this code into the wrapper you just need to start
% here. The wrapper script handles everything above.
%-------------------------------------------------------
% function [trialData] = drawDotTrial(screenInfo, conditionInfo)
%
x=0; %xcoordinate
xv = 10;
lw = 1; %linewidth
% 
% while (KbStrokeWait); %this moves the line while you hold down a key on 
%     %the keyboard. Want it to do the opposite and run until you press a key
%     %but it's not as simple as just doing ~KbStrokeWait.
%     
% x=mod(x+xv, screenXpixels);
% Screen('DrawLines', window, [x, x ; 0, screenYpixels], lw); 
% vbl=Screen('Flip', window,vbl+ifi/2); %taken from PTB-3 MovingLineDemo
% 
% end

% button = 0;
% 
% %Run until left mouse button is pressed:
% while ~button(1)
%     %Query mouse:
%     [xm, ym, button] = GetMouse;
%     
%     %Move line pair by 'xv' unless right mouse button is pressed, which
%     %will pause the animation:
%     if button(2)==0
%         x=mod(x+xv, screenXpixels);
%         Screen('DrawLines', window, [x, x ; 0, screenYpixels], lw); 
%         vbl=Screen('Flip', window,vbl+ifi/2); %taken from PTB-3 MovingLineDemo
% 
%     end 
% end

while x<1000; %so now you need to change this so that the x ==/less than/ 
    %whatever value is entered at the beginning. you also need to pick the
    %x coordinate to start at at the beginning.
     x=mod(x+xv, screenXpixels);
        Screen('DrawLines', window, [x, x ; 0, screenYpixels], lw); 
        vbl=Screen('Flip', window,vbl+ifi/2); %taken from PTB-3 MovingLineDemo

    end 
%this currently moves the position of the line across the screen until the
%left mouse button is pressed. right click pauses (so if right click/button
%(2) is false then it will run.

KbStrokeWait;

%This would be the end of your trial script. 
%%%%%
%--------------------------
% This also gets handled by the wrapper script. 
% Clear the screen. "sca" is short hand for "Screen CloseAll". This clears
% all features related to PTB. Note: we leave the variables in the
% workspace so you can have a look at them if you want.
% For help see: help sca
sca;