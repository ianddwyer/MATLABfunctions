
%% CHECK SIG FIGS FOR GENERAL AUTOSCALING FUNCTION
% 
% Test code with below
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

%float scalar and vectors should be currently stable, cautious of matrices
function [scaledData,scaling,label] = scaleData(num)
    
    if length(num)>1
        number = mean(num,'all');
    else
        number = num;
    end

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
        mag = floor(sigfigs_right/3)+1;
        if mod(sigfigs_right,3)==0
            mag = mag-1;
        end
        if mag == 0
            label = ""
        elseif mag == 1
            label = "m"; %milli
        elseif mag == 2
            label = "u"; %micro
        elseif mag == 3
            label = "n"; %nano
        elseif mag == 4
            label = "p"; %pico
        elseif mag == 5
            label = "f"; %femto
        elseif mag>5
            error("ERROR: Number too small for correct output")
        end
    
    %check for increase scaling 
    elseif scaling<1
        %test number of 3s places
        mag = floor((sigfigs_left-2)/3)
        if mag <= 0
            label = "";
        elseif mag == 1
            label = "k"; %kilo
        elseif mag == 2
            label = "M"; %mega
        elseif mag == 3
            label = "G"; %giga
        elseif mag == 4
            label = "T"; %Tera
        elseif mag == 5
            label = "P"; %peta
        elseif mag>5
            error("ERROR: Number too large for correct output")
        end
    end
    
    
    %prefer to scale towards larger magnitude using conditional
    %redefine scaling after obtaining label
    if sigfigs_left>0
        scaling = 10^-(mag*3);
        %figs = sigfigs_left-1;
    else  
        scaling = 10^((mag)*3); %may be a bug here, check later
        %figs = sigfigs_right;
    end
    scaledData = scaling*num;
    %sprintf("%i sigfigs to left and %i zeros before right sigfigs",sigfigs_left,sigfigs_right)

end