
%% CHECK SIG FIGS FOR GENERAL AUTOSCALING FUNCTION
clear; clc; close all;

number = 1/7686565000000000; %original to store
[scaling,label,figs] = scaleData(number);

scalednum = number*scaling;

fprintf("Original Number: %d\n",number)
fprintf("Scaled to %0.03f[%sunits]\n",round(scalednum,3),label)
