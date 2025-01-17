function [approximation] = rank_k_approximation(channel, k)
% RANK_K_APPROXIMATION Compute the rank-k approximation of a single image channel
%
% Inputs:
%   channel      - Single channel matrix (R, G, or B)
%   k            - Number of singular values to retain for the approximation
%
% Outputs:
%   approximation - Rank-k approximated channel matrix
    
    [U, S, V] = svd(channel);

    % A matrix cannot have more non-zero singular values than its rank.
    min_dim = min(size(S));
    if k > min_dim
        warning('k is greater than the minimum dimension of the channel. Setting k to %d.', min_dim);
        k = min_dim;
    end
    
    % Compute the rank-k approximation
    Uk = U(:, 1:k); % First k columns of U
    Sk = S(1:k, 1:k); % Top-left kxk submatrix of S
    Vk = V(:, 1:k); % First k columns of V
    approximation = Uk * Sk * Vk';
end