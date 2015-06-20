function DES_dechiffrement_sample
% Fonction permettant le dechiffrement du fichier 'chiffrer.txt' crypte en utilisant DES
% Il est grandement recommande de n'ecrire ce script que apres avoir ecrit celui pour le chiffrement
% NB : compte-tenu du fonctionement des rondes de Feistel, je n'ai pas modifie le nom des variables, mais vous pouvez le faire !

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
	for k=16:-1:1,
		tmpLn = Ln; % On sauvegarde Rn car on aura ensuite Ln <-- Rn
		Ln = xor(Rn , Feistel_DES(Ln,cles(k,:)));
		Rn = tmpLn;
	end,
	line_chiffre_bin = [Ln Rn]
	texte_chiffre_bin(i,:) = line_chiffre_bin(1,PIinv);
end,

texte_chiffre_bin = reshape(texte_chiffre_bin',8,[])';
texte_dechiffre = char(bin2dec(num2str(uint8(texte_chiffre_bin))))',
fid = fopen('./dechiffrer.txt', 'w');
fwrite(fid,texte_dechiffre);

return,

%%%%% Fonction de lecture du texte %%%%%%%%%%%%%%%
function [ texte_clair_bin ] = lecture_texte_entre;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

string = './chiffrer.txt';

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
% Les S-box
S1 = [14	4	13	1	2	15	11	8	3	10	6	12	5	9	0	7; 0	15	7	4	14	2	13	1	10	6	12	11	9	5	3	8; 4	1	14	8	13	6	2	11	15	12	9	7	3	10	5	0; 15	12	8	2	4	9	1	7	5	11	3	14	10	0	6	13];
S2 = [15	1	8	14	6	11	3	4	9	7	2	13	12	0	5	10; 3	13	4	7	15	2	8	14	12	0	1	10	6	9	11	5; 0	14	7	11	10	4	13	1	5	8	12	6	9	3	2	15; 13	8	10	1	3	15	4	2	11	6	7	12	0	5	14	9];
S3 = [10	0	9	14	6	3	15	5	1	13	12	7	11	4	2	8; 13	7	0	9	3	4	6	10	2	8	5	14	12	11	15	1; 13	6	4	9	8	15	3	0	11	1	2	12	5	10	14	7; 1	10	13	0	6	9	8	7	4	15	14	3	11	5	2	12];
S4 = [7	13	14	3	0	6	9	10	1	2	8	5	11	12	4	15; 13	8	11	5	6	15	0	3	4	7	2	12	1	10	14	9; 10	6	9	0	12	11	7	13	15	1	3	14	5	2	8	4; 3	15	0	6	10	1	13	8	9	4	5	11	12	7	2	14];
S5 = [2	12	4	1	7	10	11	6	8	5	3	15	13	0	14	9; 14	11	2	12	4	7	13	1	5	0	15	10	3	9	8	6; 4	2	1	11	10	13	7	8	15	9	12	5	6	3	0	14; 11	8	12	7	1	14	2	13	6	15	0	9	10	4	5	3];
S6 = [12	1	10	15	9	2	6	8	0	13	3	4	14	7	5	11; 10	15	4	2	7	12	9	5	6	1	13	14	0	11	3	8; 9	14	15	5	2	8	12	3	7	0	4	10	1	13	11	6; 4	3	2	12	9	5	15	10	11	14	1	7	6	0	8	13];
S7 = [4	11	2	14	15	0	8	13	3	12	9	7	5	10	6	1; 13	0	11	7	4	9	1	10	14	3	5	12	2	15	8	6; 1	4	11	13	12	3	7	14	10	15	6	8	0	5	9	2; 6	11	13	8	1	4	10	7	9	5	0	15	14	2	3	12];
S8 = [13	2	8	4	6	15	11	1	10	9	3	14	5	0	12	7; 1	15	13	8	10	3	7	4	12	5	6	11	0	14	9	2; 7	11	4	1	9	12	14	2	0	6	10	13	15	3	5	8; 2	1	14	7	4	10	8	13	15	12	9	0	3	5	6	11];
Dprime = Droite(1,E);
cipher_bloc = xor(Dprime,cle);

% Le résultat cipher_bloc est découpé en 8 blocks de 6 bits B
B1=cipher_bloc(1,1:6);
B2=cipher_bloc(1,7:12);
B3=cipher_bloc(1,13:18);
B4=cipher_bloc(1,19:24);
B5=cipher_bloc(1,25:30);
B6=cipher_bloc(1,31:36);
B7=cipher_bloc(1,37:42);
B8=cipher_bloc(1,43:48);

%%%% Application des S-box pour les 8 blocks B pour creer les C blocks
ligne=[1,6];colonne=[2,3,4,5];

% C1
indiceLigne=bin2dec(num2str(B1(1,ligne)))+1; % Convertir le b1b6 en char
% et après en decimal
indiceColonne=bin2dec(num2str(B1(1,colonne)))+1;
C1=dec2bin(S1(indiceLigne,indiceColonne),4); % Convertir en binaire
% avec au moins 4 bits

% C2
indiceLigne=bin2dec(num2str(B2(1,ligne)))+1;
indiceColonne=bin2dec(num2str(B2(1,colonne)))+1;
C2=dec2bin(S2(indiceLigne,indiceColonne),4);

% C3
indiceLigne=bin2dec(num2str(B3(1,ligne)))+1;
indiceColonne=bin2dec(num2str(B3(1,colonne)))+1;
C3=dec2bin(S3(indiceLigne,indiceColonne),4);

% C4
indiceLigne=bin2dec(num2str(B4(1,ligne)))+1;
indiceColonne=bin2dec(num2str(B4(1,colonne)))+1;
C4=dec2bin(S4(indiceLigne,indiceColonne),4);

% C5
indiceLigne=bin2dec(num2str(B5(1,ligne)))+1;
indiceColonne=bin2dec(num2str(B5(1,colonne)))+1;
C5=dec2bin(S5(indiceLigne,indiceColonne),4);

% C6
indiceLigne=bin2dec(num2str(B6(1,ligne)))+1;
indiceColonne=bin2dec(num2str(B6(1,colonne)))+1;
C6=dec2bin(S6(indiceLigne,indiceColonne),4);

% C7
indiceLigne=bin2dec(num2str(B7(1,ligne)))+1;
indiceColonne=bin2dec(num2str(B7(1,colonne)))+1;
C7=dec2bin(S7(indiceLigne,indiceColonne),4);

% C8
indiceLigne=bin2dec(num2str(B8(1,ligne)))+1;
indiceColonne=bin2dec(num2str(B8(1,colonne)))+1;
C8=dec2bin(S8(indiceLigne,indiceColonne),4);

% Les Ci sont concaténées
C = [C1 C2 C3 C4 C5 C6 C7 C8];

% Application de la permutation PF en block C
PF = [ 16 7 20 21 29 12 28 17 1 15 23 26 5 18 31 10 2 8 24 14 32 27 3 9 19 13 30 6 22 11 4 25 ];
C = C(1,PF);
cipher_bloc = uint8(C)-48; % Convertir en uint8 pour effectuer xor dans
% la fonction DES_chiffrement_sample

%C est a partir de la que vous devez implementer les tournees de Feistel
%Pour les infos sur DES vous pouvez consulter :
% http://en.wikipedia.org/wiki/DES_supplementary_material
% http://fr.wikipedia.org/wiki/Constantes_du_DES
% La suite ci dessous est un exemple trivial qui ne correspond pas a DES
% Einv = [2 , 3 , 4 , 5 , 8 , 9 , 10 , 11 , 12 , 15 , 16 , 17 , 18 , 21 , 22 , 23 , 24 , 27 , 28 , 29 , 30 , 33 , 34 , 35 , 36 , 39 , 40 , 41 , 42 , 45 , 46 , 47];
% cipher_bloc = cipher_bloc(1,Einv);


return,
