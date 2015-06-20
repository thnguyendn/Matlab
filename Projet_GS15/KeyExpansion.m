function [ RoundKeys ] = KeyExpansion(Nk, Nr)

nbreDeBits=16;
nbreHexDansMot=5;

k=lecture_cle_entre(Nk);

% Recopie directe des Nk premiere colonnes
for i=1:Nk,
    RoundKeys(:,i) = k(:,i);
end

for i=Nk+1:Nk*(Nr+1),
    tmp = uint8(dec2bin(RoundKeys(:,i-1),nbreDeBits))-48;
    if (mod(i-1,Nk) == 0)
        tmp = dec2hex(bin2dec(num2str(tmp)),4);% Convertir le tmp en hexadecimal pour appliquer la fonction SubBytes
        rcon = [Rcon((i-1)/Nk-1);repmat(zeros(1,nbreDeBits),nbreHexDansMot-1,1)];
        tmp = xor(uint8(dec2bin(hex2dec(SubBytes(RotBytes(tmp))),nbreDeBits))-48, rcon);
               
%     elseif ((Nk > 6) && (mod(i,Nk) == 4)) % Cas Nk > 6
%         tmp = SubBytes(tmp);
    end
    RoundKeys(:,i) = bin2dec(num2str(double(xor(uint8(dec2bin(RoundKeys(:,i-Nk),nbreDeBits))-48==1,tmp==1))));
end
return,


function [reponse] = RotBytes(mot)
    A=[2 7 12 17; 3 8 13 18; 4 9 14 19; 5 10 15 20; 1 6 11 16];
    reponse=mot(A);
return,

function [reponse] = Rcon(puissance)
    if puissance==14, reponse=[0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0]; end
    if puissance==13, reponse=[0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0]; end
    if puissance==12, reponse=[0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0]; end
    if puissance==11, reponse=[0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0]; end
    if puissance==10, reponse=[0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0]; end
    if puissance==9,  reponse=[0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0]; end
    if puissance==8,  reponse=[0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0]; end
    if puissance==7,  reponse=[0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0]; end
    if puissance==6,  reponse=[0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0]; end
    if puissance==5,  reponse=[0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0]; end
    if puissance==4,  reponse=[0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0]; end
    if puissance==3,  reponse=[0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0]; end
    if puissance==2,  reponse=[0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0]; end
    if puissance==1,  reponse=[0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0]; end
    if puissance==0,  reponse=[0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1]; end

return,

function [ keys_bin ] = lecture_cle_entre(Nk)

cle_entre = input('Entrez votre cle de chiffrement (utilise comme graine) \n', 's');
cle_entre = str2num(cle_entre);
rand('twister', cle_entre);
keys_bin = ceil(rand(5,Nk)*255^2);

return,
