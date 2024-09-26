
%float scalar and vectors should be currently stable, cautious of matrices
%[scaledData,scaling,label] = scaleData(0.1); fprintf("input value: %f\nrescale with: %f\nunit prefix: %s\n",scaledData,scaling,label)
function [scaledData,scaling,label] = scaleData(number)
            % provides scaling for mean value of arrays
            if length(number)>1
                number = mean(number,'all');
            end
            
            %counts sig figs to right and left of zero
            sigfigs_left = ceil(log10(floor(number)))-1;
            sigfigs_right = floor(log10(1/(number-floor(number))));
            
            %for conditionals
            left = isinf(sigfigs_right);
            
            %check for reduction scaling 
            switch left
                case 0
                    %test number of 3s places
                    mag = floor(sigfigs_right/3)+1;
                    if mod(sigfigs_right,3)==0
                        mag = mag-1;
                    end
                    scaling = 10^(mag*3);
                    switch mag
                        case 0
                            label = "";
                        case 1
                            label = "m"; %milli
                        case 2
                            label = "u"; %micro
                        case 3
                            label = "n"; %nano
                        case 4
                            label = "p"; %pico
                        case 5
                            label = "f"; %femto
                        otherwise
                            error("ERROR: Number too small for correct output")
                    end
            %check for increase scaling 
                case 1
                    %test number of 3s places
                    mag = floor((sigfigs_left)/3);
                    scaling = 10^-(mag*3);  
                    switch mag
                        case 0
                            label = "";
                        case 1
                            label = "k"; %kilo
                        case 2
                            label = "M"; %mega
                        case 3
                            label = "G"; %giga
                        case 4
                            label = "T"; %Tera
                        case 5
                            label = "P"; %peta
                        otherwise
                            error("ERROR: Number too large for correct output")
                    end
            end
            scaledData = scaling.*number;  
end
