function [reponse]=PolyMulti(poly_bin_1, poly_bin_2, nbreDeBits)

res=conv(poly_bin_1,poly_bin_2);
res=mod((num2str(res)-48),2);

res=[zeros(1,2*nbreDeBits-1-size(res,2)) res];
reponse_mat=res(nbreDeBits:2*nbreDeBits-1);

if nbreDeBits==8
%%%%% GF2^8
    if res(1)==1, reponse_mat=xor([1 0 0 1 1 0 1 0], reponse_mat); end
    if res(2)==1, reponse_mat=xor([0 1 0 0 1 1 0 1], reponse_mat); end
    if res(3)==1, reponse_mat=xor([1 0 1 0 1 0 1 1], reponse_mat); end
    if res(4)==1, reponse_mat=xor([1 1 0 1 1 0 0 0], reponse_mat); end
    if res(5)==1, reponse_mat=xor([0 1 1 0 1 1 0 0], reponse_mat); end
    if res(6)==1, reponse_mat=xor([0 0 1 1 0 1 1 0], reponse_mat); end
    if res(7)==1, reponse_mat=xor([0 0 0 1 1 0 1 1], reponse_mat); end
elseif nbreDeBits==4
%%%%% GF2^4
    if res(1)==1, reponse_mat=xor([1 1 0 0], reponse_mat); end
    if res(2)==1, reponse_mat=xor([0 1 1 0], reponse_mat); end
    if res(3)==1, reponse_mat=xor([0 0 1 1], reponse_mat); end
end
reponse=double(reponse_mat);

return,