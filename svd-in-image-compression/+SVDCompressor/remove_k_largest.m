function approximation = remove_k_largest(image, k)
% REMOVE_K_LARGEST Remove the top-k singular values from an image
% Inputs:
%   image        - Input image matrix (grayscale or RGB)
%   k            - Number of singular values to remove from each channel
%
% Outputs:
%   approximation - Image with the top-k singular values removed (same format as input)

    image = im2double(image);
    num_channels = size(image, 3);
    approximation = image;

    for c = 1:num_channels
        [U, S, V] = svd(image(:, :, c));
        min_dim = min(size(S));
        if k > min_dim
            warning('k=%d exceeds the minimum dimension (%d) of channel %d. Setting k to %d.', ...
                k, min_dim, c, min_dim);
            current_k = min_dim;
        else
            current_k = k;
        end
        S(1:current_k, 1:current_k) = 0; % Set top-k singular values to zero
        approximation(:, :, c) = U * S * V';
    end
end