%% Initial setup
import SVDCompressor.*
original_image = imread('cat.jpg'); 

%% Define Ranks for Compression
k_common = 5;          
kY_low = 3;            
kC_high = 7;           
kY_high = 7;          
kC_low = 3;          
k_values = [5, 10, 20];

%% Perform SVD-Based Compression in RGB Color Space
rgb_reconstructed = k_approx(original_image, k_common);

%% Perform SVD-Based Compression in YCbCr Color Space

% --- Case 1: kY = kC = 5 ---
kY_case1 = k_common;
kC_case1 = k_common;
ycbcr_reconstructed_case1 = k_approx_ycbcr(original_image, kY_case1, kC_case1);

% --- Case 2: kY = 3 (Low), kC = 7 (High) ---
kY_case2 = kY_low;
kC_case2 = kC_high;
ycbcr_reconstructed_case2 = k_approx_ycbcr(original_image, kY_case2, kC_case2);

% --- Case 3: kY = 7 (High), kC = 3 (Low) ---
kY_case3 = kY_high;
kC_case3 = kC_low;
ycbcr_reconstructed_case3 = k_approx_ycbcr(original_image, kY_case3, kC_case3);

% --- Case 4: kY = 5 (Common), kC = 3 (Low) ---
kY_case4 = k_common;
kC_case4 = kC_low;
ycbcr_reconstructed_case4 = k_approx_ycbcr(original_image, kY_case4, kC_case4);

%% Compute CR and MSE

% --- Predefine tables for YCbCr ---
CR_Table = table([], [], 'VariableNames', {'k','Compression_Ratio'});
MSE_Table = table([], [], 'VariableNames', {'k','MSE'});

% --- Compute CR and MSE for YCbCr Case 1 with different k ---
for i = 1:length(k_values)
    k = k_values(i);
    CR_val = CR_ycbcr(original_image, k, k);
    reconstructed = k_approx_ycbcr(original_image, k, k);
    MSE_val = MSError(original_image, reconstructed);
    CR_Table  = [CR_Table;  {k, CR_val}];
    MSE_Table = [MSE_Table; {k, MSE_val}];
end

% --- Predefine tables for RGB ---
CR_RGB_Table = table([], [], 'VariableNames', {'k','Compression_Ratio_RGB'});
MSE_RGB_Table = table([], [], 'VariableNames', {'k','MSE_RGB'});

% --- Compute CR and MSE for RGB with different k ---
for i = 1:length(k_values)
    k = k_values(i);
    CR_val = CRatio(original_image, k);
    reconstructed = k_approx(original_image, k);
    MSE_val = MSError(original_image, reconstructed);
    CR_RGB_Table  = [CR_RGB_Table;  {k, CR_val}];
    MSE_RGB_Table = [MSE_RGB_Table; {k, MSE_val}];
end

% --- Combine YCbCr and RGB Tables ---
CR_Combined = [CR_Table, CR_RGB_Table(:,2)];    % Combine the 2nd column of CR_RGB
MSE_Combined = [MSE_Table, MSE_RGB_Table(:,2)]; % Combine the 2nd column of MSE_RGB
CR_Combined.Properties.VariableNames  = {'k', 'CR_YCbCr', 'CR_RGB'};
MSE_Combined.Properties.VariableNames = {'k', 'MSE_YCbCr', 'MSE_RGB'};

%% Visualize Reconstructed Images
image_cell = {original_image, rgb_reconstructed, ycbcr_reconstructed_case1, ...
              ycbcr_reconstructed_case2, ycbcr_reconstructed_case3, ycbcr_reconstructed_case4};
titles = {'Original', ...
          sprintf('RGB (k=%d)', k_common), ...
          sprintf('Case 1 (kY=kC=%d)', k_common), ...
          sprintf('Case 2 (kY=%d, kC=%d)', kY_case2, kC_case2), ...
          sprintf('Case 3 (kY=%d, kC=%d)', kY_case3, kC_case3), ...
          sprintf('Case 4 (kY=%d, kC=%d)', k_common, kC_case4)};
display_images(image_cell, 'Reconstructed Images with k=5', 1, 6, titles);

%% Create a Table for CR and MSE Comparison in Case 1 with MSE Difference

% Calculate the difference in MSE between YCbCr and RGB
MSE_Difference = MSE_Combined.MSE_YCbCr - MSE_Combined.MSE_RGB;

Comparison_Table = table(k_values', CR_Combined.CR_YCbCr, CR_Combined.CR_RGB, ...
    MSE_Combined.MSE_YCbCr, MSE_Combined.MSE_RGB, MSE_Difference, ...
    'VariableNames', {'k', 'CR_YCbCr', 'CR_RGB', 'MSE_YCbCr', 'MSE_RGB', 'MSE_YCbCr - MSE_RGB'});
disp('Comparison Table: CR and MSE for YCbCr and RGB');
disp(Comparison_Table);

%% Comparison of YCbCr Cases 1-4: CR and MSE Table
caseNumbers = (1:4)';
kY_values = [kY_case1, kY_case2, kY_case3, kY_case4];
kC_values = [kC_case1, kC_case2, kC_case3, kC_case4];
CR_values  = zeros(4,1);
MSE_values = zeros(4,1);

% Loop over each case
for i = 1:4
    % Compute CR for each (kY, kC)
    CR_values(i) = CR_ycbcr(original_image, kY_values(i), kC_values(i));
    
    % Reconstruct image for each (kY, kC)
    reconstructed = k_approx_ycbcr(original_image, kY_values(i), kC_values(i));
    
    % Compute MSE
    MSE_values(i) = MSError(original_image, reconstructed);
end

% Create a table
YCbCr_Comparison_Table = table(caseNumbers, kY_values', kC_values', ...
                               CR_values, MSE_values, ...
    'VariableNames', {'Case', 'kY', 'kC', 'CR', 'MSE'});
disp('Comparison of YCbCr Cases 1-4:');
disp(YCbCr_Comparison_Table);

%% Create a Dual Axis Chart with Inverted MSE
figure('Name', 'Comparison of YCbCr Cases 1-4: CR and Inverted MSE', 'Color', 'w');

% Extract data for plotting
cases = YCbCr_Comparison_Table.Case;
CR_values = YCbCr_Comparison_Table.CR;
MSE_values = YCbCr_Comparison_Table.MSE;

% Compute inverted MSE (1/MSE) and normalize it
MSE_inverted = 1 ./ MSE_values;
MSE_inverted_normalized = MSE_inverted / max(MSE_inverted) * max(CR_values);

% Define colors
CR_color = [0.2 0.6 0.8]; 
MSE_color = [0.9 0.4 0.3];

% Create a bar chart for CR values on the primary y-axis
yyaxis left;
b = bar(cases, CR_values, 0.4, 'FaceColor', CR_color, 'EdgeColor', 'none', 'BarWidth', 0.6);
ylabel('Compression Ratio (CR)', 'FontSize', 12, 'Color', CR_color);
ylim([0 max(CR_values) * 1.2]);
ax = gca; % Current axes
ax.YColor = CR_color;

% Overlay a line chart for normalized inverted MSE on the secondary y-axis
yyaxis right;
p = plot(cases, MSE_inverted_normalized, '-o', 'LineWidth', 2, 'MarkerSize', 8, ...
          'Color', MSE_color, 'MarkerFaceColor', MSE_color);
ylabel('Normalized Inverted MSE (1/MSE)', 'FontSize', 12, 'Color', MSE_color);
ylim([0 max(MSE_inverted_normalized) * 1.2]);
ax.YColor = MSE_color;

grid on;
title('Comparison of YCbCr Cases 1-4', 'FontSize', 14);
xlabel('Case', 'FontSize', 12);
xticks(cases);
xticklabels({'Case 1', 'Case 2', 'Case 3', 'Case 4'});
legend([b, p], {'Compression Ratio', 'Inverted MSE'}, ...
    'Location', 'northwest', 'FontSize', 11, 'Box', 'off');