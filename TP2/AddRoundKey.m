function [ matrice_hexa_arrange ] = AddRoundKey(State,sous_cle);

% Transformer matrice hexa en matrice decimal
for i=1:size(State,1)
    for j=1:(size(State,2)/2)
        element_hexa=State(i,2*j-1:2*j);
        element_dec=hex2dec((element_hexa));
        
        State_dec(i,j)=element_dec;
    end
end

nbreDeBits=8;
nbreOctDansMot=4;
State_dec=uint8(dec2bin(reshape(State_dec,1,[]),nbreDeBits))-48;
sous_cle=uint8(dec2bin(reshape(sous_cle,1,[]),nbreDeBits))-48;

matrice_dec=reshape(bin2dec(num2str(double(xor(State_dec,sous_cle)))),nbreOctDansMot,[]);
matrice_arrange=[1 17 5 21 9 25 13 29;
                2 18 6 22 10 26 14 30;
                3 19 7 23 11 27 15 31;
                4 20 8 24 12 28 16 32];
matrice_hexa=dec2hex(matrice_dec,2);
matrice_hexa_arrange=matrice_hexa(matrice_arrange);

return,

