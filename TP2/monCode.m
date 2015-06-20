function monCode
% Afin de faciliter la gestion du chiffrement pour chaque
% algorithme, il est propose d'ecrire chacune des etape 
% dans une sous-fonction.
% De meme les sous-cles seront generees "a l'avance".

% Un petit code permet de demander à l'utilisateur de choisir
% l'algorithme de chiffrement.
fprintf('   ->1<- \t mon Super AES \n   ->2<- \t mon Super El Gamal \n');
choix_user = input('Choix de l algorithme :\n ');
if choix_user==2,
	super_ElGamal;
elseif choix_user==1,
	super_AES;
else
	error('Votre choix ne existe pas');
end

return,

%%%%% Fonction de lecture du texte à chiffrer %%%%%%%%%%%%%%%
function [ texte_clair_bin ] = lecture_texte_entre;

string = input('Entrez le nom de votre fichier\n', 's');
if exist(string)~=2,
	error('Le fichier demande est introuvable');
end

fid = fopen(string);
texte_clair = fread(fid);
fclose(fid);
texte_clair_bin = dec2bin(texte_clair,8);

bit_stuff = ceil(size(texte_clair_bin,1)/8)*8; % size(texte_clair_bin,1)
% de lay so hang trong ma tran texte_clair_bin
if bit_stuff > size(texte_clair_bin,1),
	nb_char = bit_stuff - size(texte_clair_bin,1);
	texte_clair_bin(end+1:bit_stuff,:) = texte_clair_bin(end-nb_char+1:end,:);
    % Tao mot ma tran co so hang bang bit_stuff neu
    % bit_stuff>size(texte_clair_bin,1)
end,

texte_clair_bin = uint8(reshape(texte_clair_bin',64,[])')-48;

return,

%%%%% Fonction SubBytes d'AES %%%%%%%%%%%%%%%
function [ texte_subBytes ] = subBytes(texte_clair_bin);
% Creer la matrice A
A = toeplitz([1 0 0 0 1 1 1 0 0 1 1 1 1 0 0 1] , [ 1 1 0 0 1 1 1 0 0 0 1 1 1 0 0 0])
% Comment trouver la matrice inverse de A   
Aprim = mod(int8(det(A)*inv(A)),2);
mod((num2str(conv(1111,1111))-48),2); % produit de convolution
return,

%%%%% Fonction ShiftRows d'AES %%%%%%%%%%%%%%%
function [ texte_shiftRows ] = shiftRows(texte_subBytes);
    fprintf('ShiftRows\n');
return,

%%%%% Fonction MixColumns d'AES %%%%%%%%%%%%%%%
function [ texte_mixColumns ] = mixColumns(texte_shiftRows);
    fprintf('MixColumns\n');
return,

%%%%% Fonction de chiffrement de l'algorithme ElGamal %%%%%%%%%%%%%%%
function super_ElGamal;
fprintf('*******************ElGamal*******************\n');
return,


