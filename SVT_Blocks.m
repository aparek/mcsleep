function x = SVT_Blocks(y,lam)
% function x = SVT_Blocks(y,lam)
%
% This function applies the singular value thresholding algorithm to each
% block of the coefficient array y. The coefficient array y is assumed to
% contain multichannel signal blocks whose singular values will be
% thresholded by lam. 
%
% Ankit Parekh (ankit.parekh@nyu.edu)
% Last Edit: 1/19/2017

[blocks,channels,seg] = size(y);
x = zeros(blocks,channels,seg);

for i = 1:blocks
    %Calculate SVD
    [U,Sig,V] = svd(permute(y(i,:,:), [2 3 1]),'econ');
    
    % Shrink the singular values using soft-threshold and form the blocks
    x(i,:,:) = U * soft(Sig, lam) * V';
end

