function CR = CRatio(original, k)
% CRATIO Calculate the Compression Ratio (CR) for SVD-based compression
%
% Inputs:
%   original   - Matrix representing the original image (grayscale or RGB)
%   k          - Number of singular values retained for compression
%
% Outputs:
%   CR         - Compression Ratio, calculated as original_size / compressed_size

    [M, N, C] = size(original); % Image dimensions and channels

    % Determine the number of bytes per element based on the data type
    switch class(original)
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

    % Original storage in bytes
    original_size = M * N * C * bytes_per_element;

    % Compute the compressed storage size
    compressed_size = (M + N + 1) * k * C * bytes_per_element;

    % Compute Compression Ratio
    CR = original_size / compressed_size;
end