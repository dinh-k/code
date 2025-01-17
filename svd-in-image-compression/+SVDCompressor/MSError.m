function MSE = MSError(original, reconstructed)
% MSE Calculate the Mean Square Error (MSE) between two images
%
% Inputs:
%   original      - Original image matrix (grayscale or RGB)
%   reconstructed - Reconstructed or compressed image matrix (same size as original)
%
% Outputs:
%   MSE           - Mean Square Error value
    
    original = im2double(original);
    reconstructed = im2double(reconstructed);
    
    % Ensure both images have the same size
    if ~isequal(size(original), size(reconstructed))
        error('Original and reconstructed images must have the same dimensions.');
    end
    
    % Compute the Mean Square Error
    difference = original - reconstructed;
    MSE = mean(difference(:).^2);
end