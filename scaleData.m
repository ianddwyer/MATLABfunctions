%float scalar and vectors should be currently stable, cautious of matrices and complex
%[scaledData,scaling,label] = scaleData(0.1); fprintf("input value: %f\nrescale with: %f\nunit prefix: %s\n",scaledData,scaling,label)
function [scaledData,scaling,label] = scaleData(number)
            % provides scaling for mean value of arrays
            if length(number)>1
                number = mean(number,'all');
                numberOld = number;
                number = 10^(mean(log10(number),'all')/10);
            else
                numberOld = number;
            end
            
            %counts sig figs to right and left of zero
            if floor(abs(number))~=0 %ensure inf does not occur
                sigfigs_left = ceil(log10(floor(abs(number))))+1;
                left = 1; %set switch condition 
            else
                if number==0
                    sigfigs_right = 0;
                else
                    sigfigs_right = floor(log10(1/(abs(number)-floor(abs(number)))))
                end
                left = 0; %set switch condition 
            end

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
                    mag = floor((sigfigs_left-1)/3);
                    
                    scaling = 10^-(mag*3);  
                    switch mag
                        case 0
                            label = "";
                        case 1
                            label = "";
                        case 2
                            label = "k"; %kilo
                        case 3
                            label = "M"; %mega
                        case 4
                            label = "G"; %giga
                        case 5
                            label = "T"; %Tera
                        case 6
                            label = "P"; %peta
                        otherwise
                            error("ERROR: Number too large for correct output")
                    end
            end
            scaledData = scaling.*numberOld;  
end
