function plot_si_vs_te(A_values, T1_map, T2_map, TR, TE_values)
    % plot_si_vs_te: Computes and plots the signal intensity (SI) versus TE for Compartment 2.
    %
    % Inputs:
    %   A_values - Vector of water content values for each compartment.
    %   T1_map   - T1 values for the entire phantom.
    %   T2_map   - T2 values for the entire phantom.
    %   TR       - Fixed repetition time.
    %   TE_values - Vector of TE values to use for the plot.

    % Select the parameters for Compartment 2
    compartment_index = 2;
    A = A_values(compartment_index);
    T1 = 250 + (compartment_index - 1) * 375;  % Calculate T1 for Compartment 2
    T2 = 10 + (compartment_index - 1) * 25;    % Calculate T2 for Compartment 2

    % Initialize an array to store the SI values for each TE
    SI_values = zeros(1, length(TE_values));

    % Loop through each TE value and calculate the signal intensity
    for i = 1:length(TE_values)
        TE = TE_values(i);
        % Calculate SI for the current TE
        SI_values(i) = A * (1 - exp(-TR / T1)) * exp(-TE / T2);
    end

    % Plot SI versus TE
    figure;
    plot(TE_values, SI_values, '-o', 'DisplayName', sprintf('Compartment %d', compartment_index));
    
    % Add labels, title, and legend
    xlabel('TE (ms)');
    ylabel('Signal Intensity (SI)');
    title('Signal Intensity (SI) vs. TE for Compartment 2');
    legend('Location', 'best');
    grid on;  % Add grid for better readability
end
