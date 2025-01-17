function [approximation] = k_approx(image, k)
% K_APPROX Compute the rank-k approximation of a grayscale or RGB color image
% 
% Inputs:
%   image        - Input image matrix (grayscale or RGB)
%   k            - Number of singular values to retain for the approximation
%
% Outputs:
%   approximation - Rank-k approximated image matrix (same format as input)

    image = im2double(image);
    
    if size(image, 3) == 1
        % Grayscale image
        approximation = rank_k_approximation(image, k);

    elseif size(image, 3) == 3
        % Color image
        % Split the image into red, green, and blue channels
        R = image(:, :, 1);
        G = image(:, :, 2);
        B = image(:, :, 3);
        
        % Compute the rank-k approximation for each channel
        Rk = rank_k_approximation(R, k);
        Gk = rank_k_approximation(G, k);
        Bk = rank_k_approximation(B, k);
        
        % Combine the approximations to form the final image
        approximation = cat(3, Rk, Gk, Bk);
    else
        error('Unsupported image format. The input must be a grayscale or RGB color image.');
    end
end