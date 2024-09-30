% phantom_one.m
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
A_values = [1, 0.09, 0.3, 0.3, 0.45]; 

% Generate the property maps (A_map, T1_map, T2_map) using dynamic_phantom
[A_map, T1_map, T2_map] = dynamic_phantom(N, ellipse_parameters, A_values);

% Define imaging parameters for T1 and T2
TR = 250;  
TE = 10;  

% Generate the T1 signal intensity map
signal_intensity_map_T1 = calculate_signal_intensity(A_map, T1_map, T2_map, TR, TE, 'T1');

% Generate the T2 signal intensity map
signal_intensity_map_T2 = calculate_signal_intensity(A_map, T1_map, T2_map, TR, TE, 'T2');

% Display the A_map image
figure;
imshow(A_map, [0, 1]);  % Scale A_map values between 0 and 1
title('A-map (Water Content)');

% Display the T1 signal intensity map
figure;
imshow(signal_intensity_map_T1, []);
title('T1 Signal Intensity Map');

% Display the T2 signal intensity map
figure;
imshow(signal_intensity_map_T2, []);
title('T2 Signal Intensity Map');
