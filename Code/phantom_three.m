% phantom_three.m
% This script defines the ellipses, generates the property maps, and performs the tasks for Q.2.3.

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

% Define imaging parameters
TR_values = [50, 250, 1000, 2500];  % Different TR values for the four images
TE = 10;   % Constant TE for all images

% Call the function to plot MRI images with varying TR values and SI vs. TR
plot_si_vs_tr(A_values, A_map, T1_map, T2_map, TR_values, TE);

% Call the function to compute and print the signal intensities
print_signal_intensities(A_values);
