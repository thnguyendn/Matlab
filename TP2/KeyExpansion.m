function [ RoundKeys ] = KeyExpansion;

% k=lecture_cle_entre(cle_entre);
Nk=4;
Nr=10;
Nb=4;
nbreDeBits=8;
nbreOctDansMot=4;

k=[43 40 171 9;
   126 174 247 207;
   21 210 21 79;
   22 166 136 60]; % cle au debut de 4 mots
% Recopie directe des Nk premiere colonnes

for i=1:Nk, 
    RoundKeys(:,i) = k(:,i);
end
% Nb*(Nr+1)
for i=Nk+1:Nb*(Nr+1),
    tmp = uint8(dec2bin(RoundKeys(:,i-1),nbreDeBits))-48;
    if (mod(i-1,Nk) == 0)
        tmp = dec2hex(bin2dec(num2str(tmp)),2);% Convertir en hexadecimal pour appliquer la fonction SubBytes
        rcon = [Rcon((i-1)/Nk-1);repmat(zeros(1,nbreDeBits),nbreOctDansMot-1,1)];
        tmp = xor(uint8(dec2bin(hex2dec(SubBytes(RotBytes(tmp))),nbreDeBits))-48, rcon);
               
%     elseif ((Nk > 6) && (mod(i,Nk) == 4)) % Cas Nk > 6
%         tmp = SubBytes(tmp);
    end
%     p=RoundKeys(:,i-Nk)
%     q=RoundKeys(:,i-1)
    RoundKeys(:,i) = bin2dec(num2str(double(xor(uint8(dec2bin(RoundKeys(:,i-Nk),nbreDeBits))-48==1,tmp==1))));
end
return,


function [reponse] = RotBytes(mot);
    A=[2 6; 3 7; 4 8; 1 5];
    reponse=mot(A);
return,

function [reponse] = Rcon(puissance);
    
    if puissance==14, reponse=[1 0 0 1 1 0 1 0]; end
    if puissance==13, reponse=[0 1 0 0 1 1 0 1]; end
    if puissance==12, reponse=[1 0 1 0 1 0 1 1]; end
    if puissance==11, reponse=[1 1 0 1 1 0 0 0]; end
    if puissance==10, reponse=[0 1 1 0 1 1 0 0]; end
    if puissance==9,  reponse=[0 0 1 1 0 1 1 0]; end
    if puissance==8,  reponse=[0 0 0 1 1 0 1 1]; end
    if puissance==7,  reponse=[1 0 0 0 0 0 0 0]; end
    if puissance==6,  reponse=[0 1 0 0 0 0 0 0]; end
    if puissance==5,  reponse=[0 0 1 0 0 0 0 0]; end
    if puissance==4,  reponse=[0 0 0 1 0 0 0 0]; end
    if puissance==3,  reponse=[0 0 0 0 1 0 0 0]; end
    if puissance==2,  reponse=[0 0 0 0 0 1 0 0]; end
    if puissance==1,  reponse=[0 0 0 0 0 0 1 0]; end
    if puissance==0,  reponse=[0 0 0 0 0 0 0 1]; end

return,

function [ keys_bin ] = lecture_cle_entre(cle_entre);

rand('twister', cle_entre);

K0 = randi(256,5,6);

return,
