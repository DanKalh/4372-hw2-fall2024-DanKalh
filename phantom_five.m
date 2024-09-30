% phantom_five.m
% This script computes the SSIM between the pairs of images generated in Q.2.1 using .fig files.

% Clear workspace, close figures, and clear command window
clear;
clc;
close all;

% Define the filenames
filenames = {'MRI_Image_TR_50.fig', 'MRI_Image_TR_250.fig', 'MRI_Image_TR_1000.fig', 'MRI_Image_TR_2500.fig'};

% Check if files exist
for i = 1:length(filenames)
    if ~isfile(filenames{i})
        error('File not found: %s', filenames{i});
    end
end

% Load the images generated in Q.2.1 from .fig files
image1_fig = openfig(filenames{1}, 'invisible');
image2_fig = openfig(filenames{2}, 'invisible');
image3_fig = openfig(filenames{3}, 'invisible');
image4_fig = openfig(filenames{4}, 'invisible');

% Extract image data from the .fig files
image1 = getimage(findobj(image1_fig, 'Type', 'image'));
image2 = getimage(findobj(image2_fig, 'Type', 'image'));
image3 = getimage(findobj(image3_fig, 'Type', 'image'));
image4 = getimage(findobj(image4_fig, 'Type', 'image'));

% Close the figures after extracting the image data
close(image1_fig);
close(image2_fig);
close(image3_fig);
close(image4_fig);

% Compute SSIM between the specified pairs of images
ssim_1_2 = ssim(image1, image2);
ssim_1_3 = ssim(image1, image3);
ssim_1_4 = ssim(image1, image4);

% Display the SSIM results
disp('SSIM values between image pairs:');
fprintf('SSIM between Image 1 (TR=50) and Image 2 (TR=250): %.4f\n', ssim_1_2);
fprintf('SSIM between Image 1 (TR=50) and Image 3 (TR=1000): %.4f\n', ssim_1_3);
fprintf('SSIM between Image 1 (TR=50) and Image 4 (TR=2500): %.4f\n', ssim_1_4);
