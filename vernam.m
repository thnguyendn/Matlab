function chiffre = vernam(clair,cle)
clairDec = uint8(clair);
clairBin = dec2bin(clairDec)
size(clairBin)
clairBin = uint8(clairBin)-48 % Vi sao phai tru 48, minh ko hieu?
size(clairBin)

cleDec = uint8(cle);
cleBin = dec2bin(cle);
cleBin = uint8(cleBin)-48

[lignes, colonnes] = size(clairBin);
[lignes, colonnes] = size(cleBin);

% Chiffrer le texte entree
res = xor(cleBin, clairBin);
chiffre = bin2dec(num2str(uint8(res)))';
chiffre = char(chiffre)

% Déchiffrer le texte chiffré
dechiffrer = xor(cleBin, res);
dechiffre = char(bin2dec(num2str(uint8(dechiffrer))))'

