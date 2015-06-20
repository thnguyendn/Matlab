function [inverse]=FindInverseMatrice(A)

nbreDeBits=16;
arrayRes = csvread('ArrayRes.csv');
% Trouver l'inverse de determinant de A dans le corps GF2^16
inverse_det=Inverse(num2str(determinant(A)), arrayRes, nbreDeBits);

for i=1:size(A,1)
    for j=1:size(A,2)
        P=A;
        P(i,:)=[];
        P(:,j)=[];
        element_bin=num2str(PolyMulti(double(inverse_det),determinant(P),nbreDeBits));
        inverse(i,j)=bin2dec(element_bin);
    end
end
% la “formule” de Laplace inv(A)= 1/det(A)*com(A)'. D'où le résultat doit
% être transposé
inverse=inverse';

return,

function [sum]=determinant(A)

nbreDeBits=16;
[r,c]=size(A);
if c==1
    sum=double(dec2bin(A(1,1),nbreDeBits))-48;
else
    if c==2
        poly_bin_1=double(dec2bin(A(1,1),nbreDeBits))-48;
        poly_bin_2=double(dec2bin(A(2,2),nbreDeBits))-48;
        poly_bin_3=double(dec2bin(A(1,2),nbreDeBits))-48;
        poly_bin_4=double(dec2bin(A(2,1),nbreDeBits))-48;
        sum=xor(PolyMulti(poly_bin_1, poly_bin_2, nbreDeBits),PolyMulti(poly_bin_3, poly_bin_4, nbreDeBits));
        sum=double(sum);
    else
        for ii=1:c
            if ii==1
                coeff=double(dec2bin(A(1,1),nbreDeBits))-48;
                sum=PolyMulti(coeff,determinant(A(2:r,2:c)),nbreDeBits);
                sum=double(sum);
            elseif (ii>1 && ii<c)
                coeff=double(dec2bin(A(1,ii),nbreDeBits))-48;
                multi=PolyMulti(coeff,determinant(A(2:r,[1:ii-1,ii+1:c])),nbreDeBits);
                sum=xor(sum,multi);
                sum=double(sum);
            else     
                coeff=double(dec2bin(A(1,c),nbreDeBits))-48;
                multi=PolyMulti(coeff,determinant(A(2:r,1:c-1)),nbreDeBits);
                sum=xor(sum,multi);
                sum=double(sum);
            end
        end
    end
end

return,