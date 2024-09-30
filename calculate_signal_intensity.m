function signal_intensity_map = calculate_signal_intensity(A_map, T1_map, T2_map, TR, TE, weighting_type)
    % calculate_signal_intensity.m
    % Computes the signal intensity map for T1- or T2-weighted imaging.
    
    % Initialize the signal intensity map
    [N, ~] = size(A_map);
    signal_intensity_map = zeros(N);
    
    % Calculate signal intensity based on the weighting type
    switch lower(weighting_type)
        case 't1'
            % T1 signal intensity formula
            signal_intensity_map = A_map .* (1 - exp(-TR ./ T1_map)) .* exp(-TE ./ T2_map);
        case 't2'
            % T2 signal intensity formula
            signal_intensity_map = A_map .* exp(-TE ./ T2_map);
        otherwise
            error('Invalid weighting type. Choose either "T1" or "T2".');
    end
end
