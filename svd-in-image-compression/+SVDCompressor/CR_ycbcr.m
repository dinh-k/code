function CR = CR_ycbcr(original, kY, kC)
% CR_YCBCR Compute the Compression Ratio (CR) for an image in the YCbCr color space.
%
% Inputs:
%   original - Input color image (RGB format). The image can be of type 
%              'uint8', 'uint16', 'single', or 'double'.
%   kY       - Rank used for the Y (luminance) component during compression.
%   kC       - Rank used for the Cb and Cr (chrominance) components during compression.
%
% Outputs:
%   CR       - The computed compression ratio. Higher values indicate 
%              greater compression.

    % Get image dimensions and channels
    [M, N, C] = size(original);

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
            error('Unsupported image class. Only uint8, uint16, single, and double are supported.');
    end

    % Compute the original storage size in bytes
    original_size = M * N * C * bytes_per_element;

    % Compute the compressed storage size
    compressed_size = (M + N + 1) * kY * bytes_per_element + ...
                      2 * (M + N + 1) * kC * bytes_per_element;

    % Compute the Compression Ratio
    CR = original_size / compressed_size;
end