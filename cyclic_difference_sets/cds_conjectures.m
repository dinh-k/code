function cds_conjectures()
    % Example verification for Big Conjecture
    verify_cds(7, 'Big Conjecture: Example where D forms a CDS');
    verify_cds(13, 'Big Conjecture: Example where D does not form a CDS');
    
    % Example verification for Second Conjecture
    verify_cds(17, 'Second Conjecture Example');
    
    % Example verification for Third Conjecture
    verify_cds(14, 'Third Conjecture Example for m = 2p');
    verify_cds(10, 'Third Conjecture Example for m = 2p');
end

function verify_cds(m, description)
    fprintf('\n%s (m = %d):\n', description, m);
    squares = unique(mod((1:m-1).^2, m));
    fprintf('Non-zero squares: %s\n', mat2str(squares));
    
    differences = mod(bsxfun(@minus, squares', squares), m);
    difference_counts = histcounts(differences(:), 0:m);
    
    fprintf('Difference counts:\n');
    disp(array2table(difference_counts, 'VariableNames', compose("Diff_%d", 0:m-1)));
    
    is_cds = all(difference_counts(2:end) == difference_counts(2));
    if is_cds
        fprintf('The set of non-zero squares forms a CDS.\n');
    else
        fprintf('The set of non-zero squares does NOT form a CDS.\n');
    end
end
