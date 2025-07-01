function [scaledData, scaling, label] = scaleData(num)
    % scaleData: autoscales a scalar or vector using metric prefixes
    % [scaledData, scaling, label] = scaleData(num)
    % Example: num = 0.00047 → scaledData = 470, scaling = 1e6, label = 'u'

    try
        % If input is a vector, use its mean to determine scale
        if length(num) > 1
            number = mean(num, 'all');
        else
            number = num;
        end

        % Initialize significant figure counters
        sigfigs_left = -1;
        sigfigs_right = 0;

        % Break into integer and fractional parts
        numleft = floor(number);
        numright = number - numleft;

        % Init label and magnitude
        label = "";
        mag = 0;

        % Count digits to the left of the decimal
        while abs(numleft) > 0
            numleft = floor(numleft / 10);
            sigfigs_left = sigfigs_left + 1;
        end

        % Re-declare integer part for logical checks
        numleft = floor(number);

        % Count zeros to the right of the decimal before a significant digit
        while (abs(numright) < 1 && abs(numleft) <= 0 && numright ~= 0)
            numright = numright * 10;
            sigfigs_right = sigfigs_right + 1;
        end

        % Determine direction of scaling
        if sigfigs_left > 0
            scaling = 10^-(sigfigs_left - 1);  % large values
        else
            scaling = 10^(sigfigs_right);     % small values
        end

        % Choose label and magnitude
        if scaling > 1  % small number, scale up
            mag = floor(sigfigs_right / 3) + 1;
            if mod(sigfigs_right, 3) == 0
                mag = mag - 1;
            end

            switch mag
                case 0, label = "";
                case 1, label = "m";  % milli
                case 2, label = "u";  % micro
                case 3, label = "n";  % nano
                case 4, label = "p";  % pico
                case 5, label = "f";  % femto
                otherwise, error("ERROR: Number too small for correct output");
            end

        elseif scaling < 1  % large number, scale down
            mag = floor(sigfigs_left / 3);

            switch mag
                case 0, label = "";
                case 1, label = "k";  % kilo
                case 2, label = "M";  % mega
                case 3, label = "G";  % giga
                case 4, label = "T";  % tera
                case 5, label = "P";  % peta
                otherwise, error("ERROR: Number too large for correct output");
            end
        end

        % Recalculate scaling based on final mag and direction
        if sigfigs_left > 0
            scaling = 10^-(mag * 3);
        else
            scaling = 10^(mag * 3);
        end

        % Apply final scaling to input
        scaledData = scaling * num;

    catch
        error("Usage:\n\t[scaledData, scaling, label] = scaleData(number)");
    end
end
