function x = SVT_Blocks(y,lam)

[blocks,channels,seg] = size(y);
x = zeros(blocks,channels,seg);
for i = 1:blocks
    %Calculate SVD
    [U,Sig,V] = svd(permute(y(i,:,:), [2 3 1]),'econ');
    x(i,:,:) = U * wthresh(Sig, 's', lam) * V';
end

