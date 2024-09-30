% phantom_four.m
% This script fixes TR at 250 ms and varies TE to calculate the signal intensity for Compartment 2.

% Clear workspace, close figures, and clear command window
clear;
clc;
close all;

% Define the phantom matrix size (N x N)
N = 512;

% Define the ellipses with parameters: [x_center, y_center, width, height, angle, intensity]
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

% Define imaging parameters for Q.2.4
TR = 250;  % Fixed TR value
TE_values = [10, 40, 80, 150];  % Varying TE values

% Select Compartment 2 for the calculation
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
plot(TE_values, SI_values, '-o', 'DisplayName', 'Compartment 2');
xlabel('TE (ms)');
ylabel('Signal Intensity (SI)');
title('Signal Intensity (SI) vs. TE for Compartment 2');
legend('Location', 'best');
grid on;  % Add grid for better readability

% Display the calculated signal intensities in the command window
disp('Signal Intensity (SI) values for Compartment 2 at different TE values:');
for i = 1:length(TE_values)
    fprintf('TE = %d ms: SI = %.4f\n', TE_values(i), SI_values(i));
end
