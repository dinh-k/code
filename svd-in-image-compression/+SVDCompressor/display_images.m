function [] = display_images(image_cell, figure_title, num_rows, num_cols, titles)
%DISPLAY_IMAGES Displays images in a grid layout. Each image can have a custom title, 
%   which can either be provided as a cell array of titles or as a format
%   string that is dynamically applied to each image.
%
% Inputs:
%   image_cell    - Cell array of images to display
%   titles        - Either a cell array of titles (1 per image), or a format string
%   figure_title  - The title of the figure window
%   num_rows      - The number of rows in the grid layout
%   num_cols      - The number of columns in the grid layout

% Outputs:
%   None (this function does not return any value, it only displays the images)

    figure('Name', figure_title, 'NumberTitle', 'off');
    tiledlayout(num_rows, num_cols, 'TileSpacing', 'compact', 'Padding', 'compact');
    
    if iscell(titles)
        % If titles is a cell array, use the provided titles directly
        for i = 1:length(image_cell)
            nexttile;
            imshow(image_cell{i});
            title(titles{i});
        end
    else
        % If titles is a format string, apply it dynamically to each image
        for i = 1:length(image_cell)
            nexttile;
            imshow(image_cell{i});
            title(sprintf(titles, i));
        end
    end
end