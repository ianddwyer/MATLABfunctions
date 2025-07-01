%% CHECK SIG FIGS FOR GENERAL AUTOSCALING FUNCTION
% Test code with below
%
clear; clc; close all;

%original to store
number = [0.001,0.1,0.01]; 

%run test
[scalednum,scaling,label] = scaleData(number);

%print test results
fprintf("Rescale Factor: %f\n",scaling)
fprintf("Label: %s\n",label)
fprintf("Original Number: [")
for i = 1:length(number)
    fprintf("%0.3f",number(i));
    if i~=length(number)
        fprintf(",")
    end
end
fprintf("]\n")

fprintf("Scaled to: [")
for i = 1:length(number)
    fprintf("%i",scalednum(i));
    if i~=length(number)
        fprintf(",")
    end
end
fprintf("]%s\n\n",label)
