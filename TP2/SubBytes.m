function [matrice_reponse]=SubBytes(matrice_elements_hexa)

tabSubBytes = csvread('SubBytes.csv');

for i=1:size(matrice_elements_hexa,1)
    for j=1:(size(matrice_elements_hexa,2)/2)
        element_hexa=matrice_elements_hexa(i,2*j-1:2*j);
        element_bin=double(dec2bin(hex2dec(element_hexa),8))-48;
        
        ligne=element_bin(1)*8+element_bin(2)*4+element_bin(3)*2+element_bin(4)+1;
        colonne=element_bin(5)*8+element_bin(6)*4+element_bin(7)*2+element_bin(8)+1;

        reponse=dec2hex(tabSubBytes(ligne,colonne),2);
        matrice_reponse(i,2*j-1:2*j)=reponse;
    end
end

return,