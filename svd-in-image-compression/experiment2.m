%% Initial setup
import SVDCompressor.*
image_path = 'cat.jpg';
original_image = imread(image_path);

if size(original_image, 3) ~= 3
    error('The input image is not an RGB color image.');
end

%% Define Singular Values to Remove
k_values = [1, 2, 3, 4, 5, 8, 10, 20];

%% Compression and Reconstruction
% Initialize cell array to store compressed images
compressed_images = cell(length(k_values), 1);
MSE_values = zeros(length(k_values), 1);

% Loop through each k value
for i = 1:length(k_values)
    k = k_values(i);
    
    % Remove top k singular values from each RGB channel
    compressed_image = remove_k_largest(original_image, k);
    compressed_images{i} = compressed_image;
    
    % Compute MSE
    mse = MSError(original_image, compressed_image);
    MSE_values(i) = mse;
end

%% Display compressed images for all k values
titles = arrayfun(@(k) ['k = ' num2str(k)], k_values, 'UniformOutput', false);
display_images(compressed_images, 'Compressed Images (k Singular Values Removed)', 2, 4, titles);

%% Plot Error vs. Number of Singular Values Removed
k_values_2 = [1:50, 60, 70, 80, 90];
MSE_values_2 = zeros(length(k_values_2), 1);

for i = 1:length(k_values_2)
    k = k_values_2(i);
    compressed_image = remove_k_largest(original_image, k);
    mse = MSError(original_image, compressed_image);
    MSE_values_2(i) = mse;
end

figure('Name', 'Error in Compression', 'NumberTitle', 'off');
loglog(k_values_2, MSE_values_2, 'LineWidth', 2);
xlabel('Number of Singular Values Removed (k)');
ylabel('Mean Squared Error (MSE)');
title('Error in Compression');
grid on;

%% Final visualization
image_only_largest = k_approx(original_image, 1);
image_all_but_largest = remove_k_largest(original_image, 1);
image_cell = {image_only_largest, image_all_but_largest, original_image};
titles = {'Only Largest Value', 'All but Largest Value', 'Original Image'};
display_images(image_cell, 'Singular Value Compression Comparison', 1, 3, titles);