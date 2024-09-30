function [A_map, T1_map, T2_map] = dynamic_phantom(N, ellipse_parameters, A_values)

    % Initialize property maps
    A_map = zeros(N);
    T1_map = zeros(N);
    T2_map = zeros(N);
    
    % Generate x and y axis grids that span [-1, 1]
    x_axis = ((0:N-1) - (N-1)/2) / ((N-1)/2);
    x_grid = repmat(x_axis, N, 1);   % X coordinates
    y_grid = rot90(x_grid);          % Y coordinates

    % Loop through each ellipse and add its properties to the maps
    num_ellipses = size(ellipse_parameters, 1);
    for k = 1:num_ellipses
        % Extract ellipse properties for the current ellipse
        center_x = ellipse_parameters(k, 1);
        center_y = ellipse_parameters(k, 2);
        width = ellipse_parameters(k, 3);
        height = ellipse_parameters(k, 4);
        rotation_angle = ellipse_parameters(k, 5);
        intensity = ellipse_parameters(k, 6);

        % Convert rotation angle to radians
        rotation_angle_rad = rotation_angle * pi / 180;

        % Shift the x and y grids by the ellipse center position
        x_shifted = x_grid - center_x;
        y_shifted = y_grid - center_y;

        % Rotate the coordinates based on the rotation angle
        x_rotated = x_shifted * cos(rotation_angle_rad) + y_shifted * sin(rotation_angle_rad);
        y_rotated = -x_shifted * sin(rotation_angle_rad) + y_shifted * cos(rotation_angle_rad);

        % Equation of the ellipse (normalized form)
        semi_axis_a = width / 2;  % Horizontal semi-axis (width / 2)
        semi_axis_b = height / 2; % Vertical semi-axis (height / 2)
        ellipse_equation = (x_rotated.^2) / (semi_axis_a^2) + (y_rotated.^2) / (semi_axis_b^2);

        % Find pixels inside the ellipse (where equation is <= 1)
        ellipse_mask = ellipse_equation <= 1;

        % Set the A, T1, and T2 values for each compartment
        A_value = A_values(k);                  % Use the passed A values for water content
        T1_value = 250 + (k - 1) * 375;        % Example calculation for T1
        T2_value = 10 + (k - 1) * 25;          % Example calculation for T2

        % Assign values to the property maps
        A_map(ellipse_mask) = A_value;
        T1_map(ellipse_mask) = T1_value;
        T2_map(ellipse_mask) = T2_value;
    end
end
