% phantom_two.m
% This script defines the ellipses, generates the property maps, and computes T1 and T2 images.

% Clear workspace, close figures, and clear command window
clear;
clc;
close all;

% Define the phantom matrix size (N x N)
N = 512;

% Define the ellipses with parameters: [x_center, y_center, width, height, angle, intensity]
% These values reflect your original specifications for each part of the phantom
ellipse_parameters = [
    0, 0, 0.69, 0.92, 0, 1;           % Compartment 1: Skull
    0, -0.0184, 0.6624, 0.874, 0, -0.8; % Compartment 2: Brain
    0.12, 0.05, 0.18, 0.45, -5, -0.1;    % Compartment 3: Brain Matter 1
    -0.12, 0.05, 0.18, 0.35, 20, -0.1;   % Compartment 4: Brain Matter 2
    0.0, -0.25, 0.1, 0.1, 0.2, 0.15;     % Compartment 5: Tumor
];

% Define the water content (A values) for each compartment
A_values = [1, 0.09, 0.3, 0.3, 0.45];  % Updated A values

% Generate the property maps (A_map, T1_map, T2_map) using dynamic_phantom
[A_map, T1_map, T2_map] = dynamic_phantom(N, ellipse_parameters, A_values);

% Define imaging parameters
TR_values = [50, 250, 1000, 2500];  % Different TR values for the four images
TE = 10;  % Constant TE for all images

% Loop through each TR value to generate and display images
num_images = length(TR_values);
num_compartments = length(A_values);

for img = 1:num_images
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
    title(sprintf('MRI Image %d (TR = %d ms, TE = %d ms)', img, TR, TE));
    
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
end

% Call the function to compute and print the signal intensities
print_signal_intensities(A_values);
