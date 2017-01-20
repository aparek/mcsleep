function nrm = sum_of_nuc_norm(u)

nrm = 0;
[blocks,~,~] = size(u);
for i = 1:blocks
    %Extract a block from the signal y
    nrm = nrm + sum(svd(permute(u(i,:,:), [2 3 1]),'econ'));
end

    
