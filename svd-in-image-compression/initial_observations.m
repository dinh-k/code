cat = imread('cat.jpg'); 
whos % Display information about the workspace variables

%% Get the 2D matrix representing the intensity of each color channel (Red, Green, Blue)
R2 = cat(:, :, 1); % Extract the red channel of the image
G2 = cat(:, :, 2); % Extract the green channel of the image
B2 = cat(:, :, 3); % Extract the blue channel of the image

% Visualize the grayscale version of each channel (R, G, B)
figure;
subplot(1, 3, 1);
imshow(R2); 
title('Red Intensity (R2)'); 

subplot(1, 3, 2);
imshow(G2); 
title('Green Intensity (G2)'); 

subplot(1, 3, 3);
imshow(B2); 
title('Blue Intensity (B2)');

%% Create new images with only one color channel at a time (R3, G3, B3)
R3 = cat; 
R3(:, :, [2 3]) = 0; % Set the green and blue channels to 0 to isolate the red channel

G3 = cat; 
G3(:, :, [1 3]) = 0; 

B3 = cat;
B3(:, :, [1 2]) = 0;

% Visualize the images with only one channel (R, G, B)
figure;
subplot(1, 3, 1);
imshow(R3); 
title('Red Channel'); 

subplot(1, 3, 2);
imshow(G3);
title('Green Channel'); 

subplot(1, 3, 3);
imshow(B3); 
title('Blue Channel');