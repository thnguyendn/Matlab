function [reponse]=SubBytes(matrice_elements_hexa)

tabSubBytes = csvread('SubBytes.csv');

for i=1:size(matrice_elements_hexa,1)
    for j=1:(size(matrice_elements_hexa,2)/4)
        element_hexa=matrice_elements_hexa(i,4*j-3:4*j);
        element_bin=double(dec2bin(hex2dec(element_hexa),16))-48;
        ligne=element_bin(1)*128+element_bin(2)*64+element_bin(3)*32+element_bin(4)*16+element_bin(5)*8+element_bin(6)*4+element_bin(7)*2+element_bin(8)*1+1;
        colonne=element_bin(9)*128+element_bin(10)*64+element_bin(11)*32+element_bin(12)*16+element_bin(13)*8+element_bin(14)*4+element_bin(15)*2+element_bin(16)*1+1;

        reponse=dec2hex(tabSubBytes(ligne,colonne),4);
        matrice_reponse(i,4*j-3:4*j)=reponse;
    end
end

reponse=matrice_reponse;

return,