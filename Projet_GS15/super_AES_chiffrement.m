function [nb_char, choix_imp]=super_AES_chiffrement
fprintf('*******************Chiffrement-AES*******************\n');

nbreHexDansMot=5;

choix_imp = input('Voulez-vous une implémentation de : \n    ->1<- \t 320 bits \n    ->2<- \t 480 bits \n    ->3<- \t 640 bits \n', 's');

if choix_imp=='1'
    Nk=4;
    Nr=10;
elseif choix_imp=='2'
    Nk=6;
    Nr=12;
elseif choix_imp=='3'
    Nk=8;
    Nr=14;
end

% Lecture du texte (voir fonction ci-dessous) et conversion pour pouvoir utilisable sous Matlab
[nb_char, State_blocs] = lecture_texte_entre(choix_imp, Nk);

roundKeys=KeyExpansion(Nk, Nr);

fid = fopen('./chiffrer.txt', 'w');

for i=1:size(State_blocs,2)/(4*Nk)
    State=State_blocs(:,(i-1)*4*Nk+1:i*4*Nk);
    State_chiffre=AddRoundKey(State,RoundKeys(roundKeys,0,nbreHexDansMot,Nk),choix_imp);

    r=1;
    while r<Nr
        State_chiffre=SubBytes(State_chiffre);
        State_chiffre=ShiftRows(State_chiffre,choix_imp);
        State_chiffre=MixColumns(State_chiffre,Nk);
        State_chiffre=AddRoundKey(State_chiffre,RoundKeys(roundKeys,r,nbreHexDansMot,Nk),choix_imp);
        r=r+1;
    end

    State_chiffre=SubBytes(State_chiffre);
    State_chiffre=ShiftRows(State_chiffre,choix_imp);
    State_chiffre=AddRoundKey(State_chiffre,RoundKeys(roundKeys,r,nbreHexDansMot,Nk),choix_imp);
    State_chiffre_hexa=reshape(State_chiffre',2,[])';
    State_chiffre_bin=char(hex2dec(State_chiffre_hexa))';
    fwrite(fid,State_chiffre_bin);
end

return,

function [sous_cle]=RoundKeys(roundKeys,i,nbreHexDansMot,Nk)
    sous_cle=reshape(roundKeys(Nk*nbreHexDansMot*i+1:Nk*nbreHexDansMot*(i+1)),nbreHexDansMot,[]);
return,


