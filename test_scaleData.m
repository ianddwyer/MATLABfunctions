
%% CHECK SIG FIGS FOR GENERAL AUTOSCALING FUNCTION
% Test code with below
%
clear; clc; close all;

number = 0.064; %original to store
[scalednum,scaling,label] = scaleData(number)

fprintf("Original Number: %f\n",number)
fprintf("Scaled to %0.03f[%sunits]\n",round(scalednum,3),label)
