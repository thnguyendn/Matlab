function DES_chiffrement_sample
% Fonction permettant le chiffrement d'un fichier avec DES
% Afin de faciliter la gestion du chiffrement il est propose d'ecrire chacune des etape dans un sous-fonction
% De m?me les sous-cles seront generees "a l'avance"

% Lecture du texte (voir fonction ci-dessous) et conversion pour pouvoir utilisable sous Matlab
texte_clair_bin = lecture_texte_entre;

% Lecture de la cl? (voir fonction ci-dessous) et g?n?ration des 16 les sous-cl?s 
cles = lecture_cle_entre;

% D?finition de la permutation initiale
PI = [58 , 50 , 42 , 34 , 26 , 18 , 10 , 2 , 60 , 52 , 44 , 36 , 28 , 20 , 12 , 4 , 62 , 54 , 46 , 38 , 30 , 22 , 14 , 6 , 64 , 56 , 48 , 40 , 32 , 24 , 16 , 8 , 57 , 49 , 41 , 33 , 25 , 17 , 9 , 1 , 59 , 51 , 43 , 35 , 27 , 19 , 11 , 3 , 61 , 53 , 45 , 37 , 29 , 21 , 13 , 5 , 63 , 55 , 47 , 39 , 31 , 23 , 15 , 7 ];

% D?finition de la permutation finale
PIinv = [40 , 8 , 48 , 16 , 56 , 24 , 64 , 32 , 39 , 7 , 47 , 15 , 55 , 23 , 63 , 31 , 38 , 6 , 46 , 14 , 54 , 22 , 62 , 30 , 37 , 5 , 45 , 13 , 53 , 21 , 61 , 29 , 36 , 4 , 44 , 12 , 52 , 20 , 60 , 28 , 35 , 3 , 43 , 11 , 51 , 19 , 59 , 27 , 34 , 2 , 42 , 10 , 50 , 18 , 58 , 26 , 33 , 1 , 41 , 9 , 49 , 17 , 57 , 25 ];


texte_chiffre_bin = texte_clair_bin;

%On boucle sur les blocs du message a coder
for i=1:size(texte_clair_bin,1),
	line_clair_bin = texte_clair_bin(i,PI);
	Ln = line_clair_bin(1,1:32);
	Rn = line_clair_bin(1,33:end);
	%C'est ici que doivent commencer les 16 roundes de Feistel
	for k=1:16,
		tmpRn = Rn; % On sauvegarde Rn car on aura ensuite Ln <-- Rn
		Rn = xor(Ln , Feistel_DES(Rn,cles(k,:)));
		Ln = tmpRn;
	end,
	line_chiffre_bin = [Ln Rn];
	texte_chiffre_bin(i,:) = line_chiffre_bin(1,PIinv);
end,

texte_chiffre_bin = reshape(texte_chiffre_bin',8,[])';
texte_chiffre = char(bin2dec(num2str(uint8(texte_chiffre_bin))))',
fid = fopen('./chiffrer.txt', 'w');
fwrite(fid,texte_chiffre);

return,

%%%%% Fonction de lecture du texte %%%%%%%%%%%%%%%
function [ texte_clair_bin ] = lecture_texte_entre;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

string = input('Entrez le nom de votre fichier\n', 's');
if exist(string)~=2,
	error('Le fichier demande est introuvable');
end

fid = fopen(string);
texte_clair = fread(fid);
fclose(fid);
texte_clair_bin = dec2bin(texte_clair,8);

bit_stuff = ceil(size(texte_clair_bin,1)/8)*8;
if bit_stuff > size(texte_clair_bin,1),
	nb_char = bit_stuff - size(texte_clair_bin,1),
	texte_clair_bin(end+1:bit_stuff,:) = texte_clair_bin(end-nb_char+1:end,:);
end,

texte_clair_bin = uint8(reshape(texte_clair_bin',64,[])')-48;

return,

%%%%% Fonction de lecture du texte %%%%%%%%%%%%%%%
function [ keys_bin ] = lecture_cle_entre;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cle_entre = input('Entrez votre cle de chiffrement\n Soit un char de 64 ou 56 (\"01\"), soit un numerique (utilise comme graine) \n', 's');
if strcmp(cle_entre, '"'),
	if size(cle_entre,2) == 58 || size(cle_entre,2) == 66,
		K0_texte = cle_entre(2:end-1);
		K0 = double(K0_texte)-48;
	else
		error('La cle doit faire 56 ou 64 bits');
	end
else
	cle_entre = str2num(cle_entre);
	rand('twister', cle_entre);
	K0 = rand(1,64)>0.5;
end,

if size(K0,2) == 64,
	for i=1:8,
		K0(i*8) = 1-mod(sum(K0((i-1)*8+1:i*8-1)),2);
	end,
else,
	for i=1:8,
		K0(i*8+1:end+1) = K0(i*8:end);
		K0(i*8) = 1-mod(sum(K0((i-1)*8+1:i*8-1)),2);
	end,
end,

% Generation des cles K1, ... , K16
PC1g = [ 57 , 49 , 41 , 33 , 25 , 17 , 9 , 1 , 58 , 50 , 42 , 34 , 26 , 18 , 10 , 2 , 59 , 51 , 43 , 35 , 27 , 19 , 11 , 3 , 60 , 52 , 44 , 36 ];
PC1d = [ 63 , 55 , 47 , 39 , 31 , 23 , 15 , 7 , 62 , 54 , 46 , 38 , 30 , 22 , 14 , 6 , 61 , 53 , 45 , 37 , 29 , 21 , 13 , 5 , 28 , 20 , 12 , 4 ];
L0 = K0(1,PC1g);
R0 = K0(1,PC1d);

PC2 = [ 14 , 17 , 11 , 24 , 1 , 5 , 3 , 28 , 15 , 6 , 21 , 10 , 23 , 19 , 12 , 4 , 26 , 8 , 16 , 7 , 27 , 20 , 13 , 2 , 41 , 52 , 31 , 37 , 47 , 55 , 30 , 40 , 51 , 45 , 33 , 48 , 44 , 49 , 39 , 56 , 34 , 53 , 46 , 42 , 50 , 36 , 29 , 32 ] ;
keys_bin = zeros(16,48);

for i=1:16,
	vi = 2;
	if i==1 || i==2 || i==9 || i==16, vi=1; end
	%Permutation circulaire
	tmp = L0(1:vi);
	L0(1:end-vi) = L0(vi+1:end);
	L0(end-vi+1:end) = tmp;

	tmp = R0(1:vi);
	R0(1:end-vi) = R0(vi+1:end);
	R0(end-vi+1:end) = tmp;

	%Application de la fonction PC2
	S0 = [L0 R0];
	keys_bin(i,:) = S0(PC2);
	
end,

return,


%%%%% Fonction de la ronde de Feistel du DES %%%%%%%%%%%%%%%
function [ cipher_bloc ] = Feistel_DES(Droite, cle);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

E = [ 32 , 1 , 2 , 3 , 4 , 5 , 4 , 5 , 6 , 7 , 8 , 9 , 8 , 9 , 10 , 11 , 12 , 13 , 12 , 13 , 14 , 15 , 16 , 17 , 16 , 17 , 18 , 19 , 20 , 21 , 20 , 21 , 22 , 23 , 24 , 25 , 24 , 25 , 26 , 27 , 28 , 29 , 28 , 29 , 30 , 31 , 32 , 1 ];
Dprime = Droite(1,E);
cipher_bloc = xor(Dprime,cle);
%C est a partir de la que vous devez implementer les tournees de Feistel
%Pour les infos sur DES vous pouvez consulter :
% http://en.wikipedia.org/wiki/DES_supplementary_material
% http://fr.wikipedia.org/wiki/Constantes_du_DES
% La suite ci dessous est un exemple trivial qui ne correspond pas a DES
Einv = [2 , 3 , 4 , 5 , 8 , 9 , 10 , 11 , 12 , 15 , 16 , 17 , 18 , 21 , 22 , 23 , 24 , 27 , 28 , 29 , 30 , 33 , 34 , 35 , 36 , 39 , 40 , 41 , 42 , 45 , 46 , 47];
cipher_bloc = cipher_bloc(1,Einv);


return,