function print_signal_intensities(A_values)

    % Define the TR and TE values for each image
    TR_values = [50, 250, 1000, 2500];  % For Image 1, 2, 3, and 4
    TE = 10;  % Constant TE for all images

    % Initialize a matrix to store the signal intensities for each compartment and image
    num_compartments = length(A_values);
    SI_values = zeros(num_compartments, length(TR_values));

    % Loop through each compartment
    for comp = 1:num_compartments
        A = A_values(comp);
        
        % Calculate T1 and T2 values based on the compartment index
        T1 = 250 + (comp - 1) * 375;
        T2 = 10 + (comp - 1) * 25;
        
        % Loop through each image (with different TR values)
        for img = 1:length(TR_values)
            TR = TR_values(img);
            
            % Compute the signal intensity using the given formula
            SI_values(comp, img) = A * (1 - exp(-TR / T1)) * exp(-TE / T2);
        end
    end

    % Display the computed signal intensities
    disp('Signal Intensity (SI) values for each compartment and image:');
    disp('-----------------------------------------------');
    disp('Compartment  |   SI(1)   |   SI(2)   |   SI(3)   |   SI(4)');
    disp('-----------------------------------------------');
    for comp = 1:num_compartments
        fprintf('     %d       |  %.4f  |  %.4f  |  %.4f  |  %.4f\n', comp, SI_values(comp, 1), SI_values(comp, 2), SI_values(comp, 3), SI_values(comp, 4));
    end
end
