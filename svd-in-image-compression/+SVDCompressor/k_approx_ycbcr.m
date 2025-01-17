function [approximation] = k_approx_ycbcr(image, kY, kC)
% K_APPROX_YCBCR Compute the rank-k approximation of a color image in YCbCr
% color space
%
% Inputs:
%   image        - Input RGB image matrix (MxNx3)
%   kY
%   kC
%
% Outputs:
%   approximation - Rank-k approximated image in RGB color space

    original_class = class(image);
    
    % Convert image to double in [0,1]
    image_double = im2double(image);
    
    % Convert the image to YCbCr color space
    image_ycbcr = rgb2ycbcr(image_double);
    Y = image_ycbcr(:, :, 1);
    Cb = image_ycbcr(:, :, 2);
    Cr = image_ycbcr(:, :, 3);
    
    % Compute the rank-kY approximation for the luminance channel (Y)
    Yk = rank_k_approximation(Y, kY);
    
    % Compute the rank-kC approximation for the color channels
    Cbk = rank_k_approximation(Cb, kC);
    Crk = rank_k_approximation(Cr, kC);
    
    % Combine the approximated luminance channel (Y) with the original chrominance channels (Cb, Cr) 
    approximation_ycbcr = cat(3, Yk, Cbk, Crk);
    
    % Convert the approximation back to RGB color space
    approximation_rgb = ycbcr2rgb(approximation_ycbcr);
    
    % Clip the values to maintain valid intensity range [0,1]
    approximation_rgb = min(max(approximation_rgb, 0), 1);
    
    % Convert back to original class
    switch original_class
        case 'uint8'
            approximation = im2uint8(approximation_rgb);
        case 'uint16'
            approximation = im2uint16(approximation_rgb);
        case 'single'
            approximation = single(approximation_rgb);
        case 'double'
            approximation = approximation_rgb;
        otherwise
            approximation = approximation_rgb;
            warning('Unsupported image class. Returning as double.');
    end
end