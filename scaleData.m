
%% CHECK SIG FIGS FOR GENERAL AUTOSCALING FUNCTION
%test with below in console
%[scaledData,scaling,label] = scaleData(0.1); 
%fprintf("input value: %f\nrescale with: %f\nunit prefix: %s\n",scaledData,scaling,label)

%% THE FUNCTION

%float scalar and vectors should be currently stable, cautious of matrices
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
        
            %init sigfig counters
            sigfigs_left =  -1;
            sigfigs_right = 0;
            
            %counts sig figs to left of decimal
            numleft = floor(number);
            numright = number-floor(number);
        
            %find label from mag, init vars
            label = "";
            mag = 0;
            
            while (abs(numleft)>0)
                numleft = floor(numleft/10);
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
                    label = "";
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
                mag = floor((sigfigs_left)/3);
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
                scaling = 10^(mag*3);
                %figs = sigfigs_right;
            end
            scaledData = scaling*num;
        catch
            error(sprintf("\nUsage:\n\t[scalednum,scaling,label] = scaleData(number)"))
        end

    
end
