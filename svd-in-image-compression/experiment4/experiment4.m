%% Initial setup
import SVDCompressor.*
original_image = im2double(imread('cat.jpg'));

%% Define Noise Levels and Generate Noisy Images
noise_levels = [0.05, 0.1, 0.2];
noisy_images = cell(1, numel(noise_levels));

for i = 1:numel(noise_levels)
    noisy_images{i} = add_noise(original_image, noise_levels(i));
end
[noisy_image_low, noisy_image_medium, noisy_image_high] = deal(noisy_images{:});

%% Plot Original and Noisy Images
images_to_plot = [{original_image}, noisy_images];
subplot_titles = {'Original Image', ...
                  sprintf('Low Noise (\\sigma=%.2f)', noise_levels(1)), ...
                  sprintf('Medium Noise (\\sigma=%.2f)', noise_levels(2)), ...
                  sprintf('High Noise (\\sigma=%.2f)', noise_levels(3))};
display_images(images_to_plot, 'Original and Noisy Images', 1, 4, subplot_titles);

%% Reconstruct Images with Fixed k=15
k_fixed = 15;
reconstructed_images_k15 = cell(1, numel(images_to_plot));

for i = 1:numel(images_to_plot)
    reconstructed_images_k15{i} = k_approx(images_to_plot{i}, k_fixed);
end
[reconstructed_original_k15, reconstructed_low_k15, ...
 reconstructed_medium_k15, reconstructed_high_k15] = deal(reconstructed_images_k15{:});

%% Plot Reconstructed Images with k=15
image_cell = reconstructed_images_k15;
titles = subplot_titles;
display_images(image_cell, 'Reconstructed Images with k=15', 1, 4, titles);

%% Define k values for graphs
k_values_graphs = { ...
    [2, 3, 5, 8, 10, 12, 13, 15, 20, 21, 25, 30, 40, 41, 45, 50, 80, 100, 120, 200, 250, 300, 400, 500, 600, 650, 700, 750, 780, 800], ...
    [1, 2, 3, 4, 5, 6, 7, 8, 10, 11, 12, 13, 15, 18, 20, 21, 25, 28, 30, 32, 35, 38, 40, 41, 45, 50] ...
};
num_graphs = length(k_values_graphs);

% Preallocate storage
mse_graphs = cell(1, num_graphs);
reconstructions_graphs = cell(1, num_graphs);

% Precompute SVD-based approximations for all noise levels and original
for g = 1:num_graphs
    k_values = k_values_graphs{g};
    num_k = length(k_values);
    mse_graphs{g} = zeros(num_k, 3); % Columns: low, medium, high noise
    mse_original_graph = zeros(num_k, 1);

    reconstructions_graphs{g} = cell(1, 4); % Original + 3 noisy images
    for i = 1:4
        img = images_to_plot{i};
        reconstructions = arrayfun(@(k) k_approx(img, k), k_values, 'UniformOutput', false);
        reconstructions_graphs{g}{i} = reconstructions;
    end

    % Compute MSE
    for i = 1:num_k
        % Original image
        mse_original_graph(i) = MSError(original_image, reconstructions_graphs{g}{1}{i});

        % Noisy images
        for j = 1:3
            mse_graphs{g}(i, j) = MSError(original_image, reconstructions_graphs{g}{j + 1}{i});
        end
    end
    mse_graphs{g} = [mse_original_graph, mse_graphs{g}];
end

%% Generate Graphs
% Define custom colors and labels
colors = {[0.2, 0.6, 0.8], [0.4, 0.8, 0.2], [0.9, 0.4, 0.3], [0.5, 0.5, 0.5]};
labels = {'Noise-Free', 'Low Noise', 'Medium Noise', 'High Noise'};

% Plot for each k-values graph
for g = 1:num_graphs
    figure('Name', sprintf('Mean Square Error vs. Rank k (Graph %d)', g), ...
           'NumberTitle', 'off', ...
           'Position', [100, 100, 900, 600]);

    hold on;

    k_values = k_values_graphs{g};
    mse_data = mse_graphs{g};

    % Plot MSE for Original Image
    plot(k_values, mse_data(:, 1), ...
         'LineWidth', 2, ...
         'Color', colors{4}, ...
         'DisplayName', labels{1});

    % Plot MSE for Noisy Images
    for j = 1:3
        plot(k_values, mse_data(:, j + 1), ...
             'LineWidth', 2, ...
             'MarkerSize', 5, ...
             'Color', colors{j}, ...
             'MarkerFaceColor', colors{j}, ...
             'DisplayName', labels{j + 1});
    end

    % Add horizontal lines for MSE of the noisy images at each level
    for j = 1:3
        mse_noisy_image = MSError(original_image, noisy_images{j});  % MSE for original noisy image
        plot(k_values, repmat(mse_noisy_image, size(k_values)), ...
             'LineStyle', '--', 'Color', colors{j}, 'LineWidth', 2, ...
             'DisplayName', sprintf('Original %s', labels{j + 1}));
    end

    xlabel('Rank k', 'FontSize', 14, 'FontWeight', 'bold');
    ylabel('Mean Square Error (MSE)', 'FontSize', 14, 'FontWeight', 'bold');
    title(sprintf('Mean Square Error vs. Rank k (Graph %d)', g), ...
          'FontSize', 16, 'FontWeight', 'bold');
    legend('Location', 'northeast', 'FontSize', 12, 'Box', 'off');
    set(gca, 'FontSize', 12);
    grid on;

    hold off;
end

%% Compute and create CR table
selected_k_values = [1, 10, 50, 200, 400, 850];
num_selected_k = length(selected_k_values);
cr_table = zeros(num_selected_k, 4); % Columns: Original, Low Noise, Medium Noise, High Noise

% Compute CR
for i = 1:num_selected_k
    k = selected_k_values(i);

    % CR for original image
    cr_table(i, 1) = CRatio(original_image, k);

    % CR for noisy images
    for j = 1:3
        cr_table(i, j + 1) = CRatio(noisy_images{j}, k);
    end
end

cr_table_display = array2table(cr_table, ...
    'VariableNames', {'Original', 'Low_Noise', 'Medium_Noise', 'High_Noise'}, ...
    'RowNames', arrayfun(@(k) sprintf('k=%d', k), selected_k_values, 'UniformOutput', false));
disp('Compression Ratios for Selected k Values:');
disp(cr_table_display);

%% Reconstruct and Plot Images for High Noise Level with Different k Values
k_values_specific_high = [5, 32];
titles_high_noise = {'High Noise (k=5)', 'High Noise (k=32)'};

reconstructed_images_specific_high = cell(1, 2);
for i = 1:2
    reconstructed_images_specific_high{i} = k_approx(noisy_image_high, k_values_specific_high(i));
end

% Plot the reconstructed high-noise images
figure('Name', 'Reconstructed High Noise Images with Specific k Values', 'NumberTitle', 'off');

for i = 1:2
    subplot(1, 2, i);
    imshow(reconstructed_images_specific_high{i}, []);
    title(titles_high_noise{i});
end

% Compute MSE for the 2 reconstructed images
mse_values_high = zeros(1, 2);

for i = 1:2
    mse_values_high(i) = MSError(original_image, reconstructed_images_specific_high{i});  % MSE
end

% Create a table to display MSE values
mse_table_high = table( ...
    k_values_specific_high', mse_values_high', ...
    'VariableNames', {'k Value', 'MSE'}, ...
    'RowNames', titles_high_noise);
disp('MSE for Reconstructed High Noise Images:');
disp(mse_table_high);