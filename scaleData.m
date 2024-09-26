
%float scalar and vectors should be currently stable, cautious of matrices
%[scaledData,scaling,label] = scaleData(0.1); fprintf("input value: %f\nrescale with: %f\nunit prefix: %s\n",scaledData,scaling,label)
function [scaledData,scaling,label] = scaleData(num)
        try
            %print stored location to avoid forgetting to include this for other users
            %fprintf("location of scaleData function:\n\t 'C:\\Users\\Eian\\Documents\\MATLAB\\R2022b\\CustomLibrary' \n");
            % provides scaling for mean value of arrays
            if length(num)>1
                number = mean(num,'all');
            else
                number = num;
            end
        
            %find label from mag, init vars
            label = "";
            mag = 0;
            
            %counts sig figs to right and left of zero
            sigfigs_left = ceil(log10(floor(number)))-1;
            sigfigs_right = floor(log10(1/(number-floor(number))));
            
            %prefer to scale towards larger magnitude using conditional
            if sigfigs_left>0 %reduce size for large values
                scaling = 10^-(sigfigs_left-1);
            else %increase size for small values
                scaling = 10^(sigfigs_right);
            end
            
            %check for reduction scaling 
            if scaling>1
                %test number of 3s places
                mag = floor(sigfigs_right/3)+1;
                if mod(sigfigs_right,3)==0
                    mag = mag-1;
                end
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
            elseif scaling<1
                %test number of 3s places
                mag = floor((sigfigs_left)/3);
                if mag <= 0
                    label = "";
                else
                    switch mag
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
            end

            %prefer to scale towards larger magnitude using conditional
            %redefine scaling after obtaining label
            if sigfigs_left>0
                scaling = 10^-(mag*3);
            else  
                scaling = 10^(mag*3);
            end
            scaledData = scaling*num;
        catch
            error(sprintf("\nUsage:\n\t[scalednum,scaling,label] = scaleData(number)"))
        end   
end
