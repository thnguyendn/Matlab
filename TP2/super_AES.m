function [State]=super_AES;
fprintf('*******************AES*******************\n');

Nr=10;

State=[50 136 49 224;
       67 90 49 55;
       246 48 152 7;
       168 141 162 52];
matrice_arrange=[1 17 5 21 9 25 13 29;
                2 18 6 22 10 26 14 30;
                3 19 7 23 11 27 15 31;
                4 20 8 24 12 28 16 32];
State=dec2hex(State);
State=State(matrice_arrange);

roundKeys=KeyExpansion;

State=AddRoundKey(State,RoundKeys(roundKeys,0));

r=1;
while r<Nr
    State=SubBytes(State);
    State=ShiftRows(State);
    State=MixColumns(State);
    State=AddRoundKey(State,RoundKeys(roundKeys,r));
    r=r+1;
end

State=SubBytes(State);
State=ShiftRows(State);
State=AddRoundKey(State,RoundKeys(roundKeys,r));

return,

function [sous_cle]=RoundKeys(roundKeys,i);
    nbreOctDansMot=4;
    sous_cle=reshape(roundKeys(16*i+1:16*(i+1)),nbreOctDansMot,[]);
return,


