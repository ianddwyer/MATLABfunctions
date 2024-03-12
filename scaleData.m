
%% CHECK SIG FIGS FOR GENERAL AUTOSCALING FUNCTION
% 
% clear; clc; close all;
% 
% number = 6677676865650; %original to store
% [scaling,label,figs] = scaleData(number);
% 
% scalednum = number*scaling;
% 
% fprintf("Original Number: %f\n",number)
% fprintf("Scaled to %0.03f[%sunits]\n",round(scalednum,3),label)

%% THE FUNCTION
function [scaling,label,figs] = scaleData(number)
    
    %init sigfig counters
    sigfigs_left = 0;
    sigfigs_right = 0;
    
    %counts sig figs to left of decimal
    numleft = floor(number);
    numright = number-floor(number);

    %find label from mag, init vars
    label = "";
    mag = 0;
    
    while (abs(numleft)>0)
        numleft = round(numleft/10);
        sigfigs_left = sigfigs_left+1;
    end
    
    %counts sig figs to right based on number of zeros before useful value
    numleft = floor(number); %redeclare for logical comparisons
    while (double(abs(numright))<1 && abs(numleft)<=0)
        numright = numright*10;
        sigfigs_right = sigfigs_right+1;
    end
    
    %prefer to scale towards larger magnitude using conditional
    if sigfigs_left>0
        %reduce size for large values
        scaling = 10^-(sigfigs_left-1);
    else
        %increase size for small values
        scaling = 10^(sigfigs_right);
    end
    
    %check for reduction scaling 
    if scaling>1
        %test number of 3s places
        mag = floor(sigfigs_right/3);
        if mag == 1
            label = "milli";
        elseif mag == 2
            label = "micro";
        elseif mag == 3
            label = "nano";
        elseif mag == 4
            label = "pico";
        elseif mag == 5
            label = "femto";
        elseif mag>5
            error("ERROR: Number too small for correct output")
        end
    
    %check for increase scaling 
    elseif scaling<1
        %test number of 3s places
        mag = floor(sigfigs_left/3);
        if mag == 1
            label = "kilo";
        elseif mag == 2
            label = "mega";
        elseif mag == 3
            label = "giga";
        elseif mag == 4
            label = "tera";
        elseif mag == 5
            label = "peta";
        elseif mag>5
            error("ERROR: Number too large for correct output")
        end
    end

    %prefer to scale towards larger magnitude using conditional
    %redefine scaling after obtaining label
    if sigfigs_left>1
        scaling = 10^-(mag*3);
        figs = sigfigs_left-1;
    else  
        scaling = 10^(mag*3);
        figs = sigfigs_right;
    end

    %sprintf("%i sigfigs to left and %i zeros before right sigfigs",sigfigs_left,sigfigs_right)

end