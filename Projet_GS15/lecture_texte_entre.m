function [ nb_char, texte_blocs_hex ] = lecture_texte_entre(choix_imp, Nk)

nbreHexDansMot=5;

% Lire le fichier d'entree
string = input('Entrez le nom de votre fichier\n', 's');
if exist(string)~=2,
	error('Le fichier demande est introuvable');
end
fid = fopen(string);
texte_clair = fread(fid);
fclose(fid);
texte_clair_bin = dec2bin(texte_clair,8);

if choix_imp=='1'
    matrice_arrange=[1 41 2 42 3 43 4 44 5 45 6 46 7 47 8 48;
                     9 49 10 50 11 51 12 52 13 53 14 54 15 55 16 56;
                     17 57 18 58 19 59 20 60 21 61 22 62 23 63 24 64;
                     25 65 26 66 27 67 28 68 29 69 30 70 31 71 32 72;
                     33 73 34 74 35 75 36 76 37 77 38 78 39 79 40 80];
elseif choix_imp=='2'
    matrice_arrange=[1 61 2 62 3 63 4 64 5 65 6 66 7 67 8 68 9 69 10 70 11 71 12 72;
                     13 73 14 74 15 75 16 76 17 77 18 78 19 79 20 80 21 81 22 82 23 83 24 84;
                     25 85 26 86 27 87 28 88 29 89 30 90 31 91 32 92 33 93 34 94 35 95 36 96;
                     37 97 38 98 39 99 40 100 41 101 42 102 43 103 44 104 45 105 46 106 47 107 48 108;
                     49 109 50 110 51 111 52 112 53 113 54 114 55 115 56 116 57 117 58 118 59 119 60 120];
elseif choix_imp=='3'
    matrice_arrange=[1 81 2 82 3 83 4 84 5 85 6 86 7 87 8 88 9 89 10 90 11 91 12 92 13 93 14 94 15 95 16 96;
                     17 97 18 98 19 99 20 100 21 101 22 102 23 103 24 104 25 105 26 106 27 107 28 108 29 109 30 110 31 111 32 112;
                     33 113 34 114 35 115 36 116 37 117 38 118 39 119 40 120 41 121 42 122 43 123 44 124 45 125 46 126 47 127 48 128;
                     49 129 50 130 51 131 52 132 53 133 54 134 55 135 56 136 57 137 58 138 59 139 60 140 61 141 62 142 63 143 64 144;
                     65 145 66 146 67 147 68 148 69 149 70 150 71 151 72 152 73 153 74 154 75 155 76 156 77 157 78 158 79 159 80 160];
end

bit_stuff = ceil(size(texte_clair_bin,1)/(2*nbreHexDansMot*Nk))*(2*nbreHexDansMot*Nk);
nb_char = bit_stuff - size(texte_clair_bin,1);
if bit_stuff > size(texte_clair_bin,1),
    for i=size(texte_clair_bin,1)+1:bit_stuff
        texte_clair_bin(i,:)=texte_clair_bin(mod(i,size(texte_clair_bin,1))+1,:);
    end
    % Tao mot ma tran co so hang bang bit_stuff neu
    % bit_stuff>size(texte_clair_bin,1)
end,
texte_blocs=zeros(5,1);
for i=1:bit_stuff/(2*nbreHexDansMot*Nk)
    bloc=texte_clair_bin((i-1)*(2*nbreHexDansMot*Nk)+1:i*(2*nbreHexDansMot*Nk),:);
    bloc=dec2hex(bin2dec(bloc));
    bloc=bloc(matrice_arrange);
    texte_blocs=[texte_blocs bloc];
end

texte_blocs_hex = texte_blocs(:,2:end);

return,