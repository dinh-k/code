%% Initial setup
import SVDCompressor.*
image_path = 'cat.jpg';
original_image = imread(image_path);

%% Define Rank Values
k_values_low = [2,3,4,5,7,8,9,10];       
k_values_high = [15, 20, 25, 30];
all_k_values = [k_values_low, k_values_high];

%% Compression and Reconstruction
% Initialize cell arrays to store reconstructed images
reconstructed_low = cell(length(k_values_low),1);
reconstructed_high = cell(length(k_values_high),1);

% Initialize arrays to store metrics
CR_values = zeros(length(all_k_values),1);
MSE_values = zeros(length(all_k_values),1);
Compressed_storage = zeros(length(all_k_values),1);

% Compute original storage
[M, N, C] = size(original_image);
switch class(original_image)
    case 'uint8'
        bytes_per_element = 1;
    case 'uint16'
        bytes_per_element = 2;
    case 'single'
        bytes_per_element = 4;
    case 'double'
        bytes_per_element = 8;
    otherwise
        error('Unsupported image class.');
end
original_size = M * N * C * bytes_per_element;

% Loop through each k value for low range (2-10)
for i = 1:length(k_values_low)
    k = k_values_low(i);
    
    % Generate rank-k approximation
    approx_image = k_approx(original_image, k);
    reconstructed_low{i} = approx_image;
    
    % Compute Compression Ratio
    CR = CRatio(original_image, k);
    CR_values(i) = CR;
    
    % Compute MSE
    mse = MSError(original_image, approx_image);
    MSE_values(i) = mse;
    
    % Compute compressed storage
    [m, n, c] = size(original_image);
    compressed_size = (m + n + 1) * k * c * bytes_per_element;
    Compressed_storage(i) = compressed_size;
end

% Loop through each k value for high range (15,20,25,30)
for i = 1:length(k_values_high)
    k = k_values_high(i);
    
    % Generate rank-k approximation
    approx_image = k_approx(original_image, k);
    reconstructed_high{i} = approx_image;
    
    % Compute Compression Ratio
    CR = CRatio(original_image, k);
    CR_values(length(k_values_low) + i) = CR;
    
    % Compute MSE
    mse = MSError(original_image, approx_image);
    MSE_values(length(k_values_low) + i) = mse;
    
    % Compute compressed storage
    [m, n, c] = size(original_image);
    compressed_size = (m + n + 1) * k * c * bytes_per_element;
    Compressed_storage(length(k_values_low) + i) = compressed_size;
end

%% Visualization of Reconstructed Images
display_images(reconstructed_low, 'Reconstructed Images (k = 2 to 10)', 2, 4, arrayfun(@(k) ['k = ' num2str(k)], k_values_low, 'UniformOutput', false));
display_images(reconstructed_high, 'Reconstructed Images (k = 15, 20, 25, 30)', 1, 4, arrayfun(@(k) ['k = ' num2str(k)], k_values_high, 'UniformOutput', false));

%% Compute Metrics and Generate Table
Original_storage = original_size;
Results_Table = table(all_k_values', CR_values, MSE_values, Compressed_storage, ...
    'VariableNames', {'k_Value', 'Compression_Ratio', 'MSE', 'Compressed_Storage_Bytes'});
disp('Compression Metrics for Various k Values:');
disp(Results_Table);

%% Create Chart for CR and MSE
figure('Name', 'Compression Metrics for Various k Values: CR and MSE', 'Color', 'w');

% Extract data for plotting
k_values = Results_Table.k_Value;
CR_values = Results_Table.Compression_Ratio;
MSE_values = Results_Table.MSE;

% Define colors for the chart
CR_color = [0.2 0.6 0.8];
MSE_color = [0.9 0.4 0.3];

% Bar chart for CR
yyaxis left;
b = bar(k_values, CR_values, 0.6, 'FaceColor', CR_color, 'EdgeColor', 'none', 'BarWidth', 0.6);
ylabel('Compression Ratio (CR)', 'FontSize', 12, 'Color', CR_color);
ylim([0 max(CR_values) * 1.2]);
ax = gca;
ax.YColor = CR_color;

% Line chart for MSE
yyaxis right;
p = plot(k_values, MSE_values, '-o', 'LineWidth', 2, 'MarkerSize', 8, ...
          'Color', MSE_color, 'MarkerFaceColor', MSE_color);
ylabel('Mean Squared Error (MSE)', 'FontSize', 12, 'Color', MSE_color);
ylim([0 max(MSE_values) * 1.2]);
ax.YColor = MSE_color;

% Grid, title, labels, legends
grid on;
title('Compression Metrics for Various k Values', 'FontSize', 13);
xlabel('k Value', 'FontSize', 12);
xticks(k_values);
legend([b, p], {'Compression Ratio', 'Mean Squared Error'}, ...
    'Location', 'northeast', 'FontSize', 11, 'Box', 'off');