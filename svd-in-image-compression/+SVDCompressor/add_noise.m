function [noisy_image] = add_noise(image, noise_level)
% ADD_NOISE Add Gaussian noise to a color image
%
% Inputs:
%   image        - Input color image (RGB format).
%   noise_level  - Standard deviation of the Gaussian noise to be added. A 
%                  higher value results in more intense noise.
%
% Outputs:
%   noisy_image  - Output image of the same size and type as the input image,
%                  with added Gaussian noise. The pixel values are clipped
%                  to maintain valid intensity ranges.

    % Store original class
    original_class = class(image);
    
    % Convert image to double for processing
    image_double = im2double(image);
    
    % Add Gaussian noise
    noise = noise_level * randn(size(image_double));
    noisy_image_double = image_double + noise;
    
    % Clip to [0, 1]
    noisy_image_double = min(max(noisy_image_double, 0), 1);
    
    % Convert back to original class
    switch original_class
        case 'uint8'
            noisy_image = im2uint8(noisy_image_double);
        case 'uint16'
            noisy_image = im2uint16(noisy_image_double);
        case 'single'
            noisy_image = single(noisy_image_double);
        otherwise
            noisy_image = noisy_image_double;
            warning('Unsupported image class. Returning as double.');
    end
end