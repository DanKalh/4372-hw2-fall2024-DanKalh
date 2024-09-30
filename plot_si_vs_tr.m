function plot_si_vs_tr(A_values, A_map, T1_map, T2_map, TR_values, TE)
    % plot_si_vs_tr: Generates MRI images for varying TR values and plots SI vs TR.
    %
    % Inputs:
    %   A_values - Vector of water content values for each compartment.
    %   A_map    - Water content map for the entire phantom.
    %   T1_map   - T1 values for the entire phantom.
    %   T2_map   - T2 values for the entire phantom.
    %   TR_values - Vector of TR values to use for each image.
    %   TE       - Echo time (constant for all images).

    % Number of compartments
    num_compartments = length(A_values);

    % Loop over each TR value to generate four separate images
    for img = 1:length(TR_values)
        TR = TR_values(img);
        
        % Compute signal intensity for each pixel in the image
        signal_intensity_map = calculate_signal_intensity(A_map, T1_map, T2_map, TR, TE, 'T1');

        % Compute signal intensities for each compartment for the legend
        SI_values = zeros(1, num_compartments);
        for comp = 1:num_compartments
            T1 = 250 + (comp - 1) * 375;
            T2 = 10 + (comp - 1) * 25;
            SI_values(comp) = A_values(comp) * (1 - exp(-TR / T1)) * exp(-TE / T2);
        end

        % Display the signal intensity map
        figure;
        imshow(signal_intensity_map, []);
        title(sprintf('MRI Image (TR = %d ms, TE = %d ms)', TR, TE));
        
        % Add a legend with TR, TE, and SI values
        legend_text = sprintf('TR = %d ms, TE = %d ms\nSI(1) = %.4f\nSI(2) = %.4f\nSI(3) = %.4f\nSI(4) = %.4f\nSI(5) = %.4f', ...
                              TR, TE, SI_values(1), SI_values(2), SI_values(3), SI_values(4), SI_values(5));
        
        % Get the size of the image to determine text position
        image_size = size(signal_intensity_map);
        text_x = 10;  % X-position for text (left padding)
        text_y = image_size(1) - 50;  % Y-position for text (near the bottom)

        % Add the text to the image
        text(text_x, text_y, legend_text, 'Color', 'white', 'FontSize', 10, 'FontWeight', 'bold', ...
             'BackgroundColor', 'black', 'Margin', 5, 'VerticalAlignment', 'top');

        % Save the figure as a .fig file
        savefig(gcf, sprintf('MRI_Image_TR_%d.fig', TR));
    end

    % Plotting SI vs TR
    SI_values_vs_TR = zeros(num_compartments, length(TR_values));
    for comp = 1:num_compartments
        A = A_values(comp);
        T1 = 250 + (comp - 1) * 375;  % Calculate T1 for this compartment
        T2 = 10 + (comp - 1) * 25;    % Calculate T2 for this compartment

        % Loop through each TR value
        for i = 1:length(TR_values)
            TR = TR_values(i);
            % Calculate SI for the current TR, T1, T2, and A
            SI_values_vs_TR(comp, i) = A * (1 - exp(-TR / T1)) * exp(-TE / T2);
        end
    end

    % Create a new figure for SI vs TR plot
    figure;
    hold on;  % Allow multiple lines on the same plot
    for comp = 1:num_compartments
        plot(TR_values, SI_values_vs_TR(comp, :), '-o', 'DisplayName', sprintf('Compartment %d', comp));
    end
    hold off;

    % Add labels, title, and legend
    xlabel('TR (ms)');
    ylabel('Signal Intensity (SI)');
    title('Signal Intensity (SI) vs. TR for Each Compartment');
    legend('Location', 'best');
    grid on;  % Add grid for better readability
end
