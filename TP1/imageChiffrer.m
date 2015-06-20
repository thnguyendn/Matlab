function chiffre = imageChiffrer(path)

imgClair = imread(path);
imgClairBin = dec2bin(imgClair(:)); % Il faut changer en vecteur 
% afin de convertir en binaire
size(imgClairBin)
imgClairBin = uint8(imgClairBin)-48;
% créer un clé
cle = rand(length(imgClair)*length(imgClair) , 8) > 0.5;
size(cle)

% Partie à chiffrer
res = xor(imgClairBin, cle);
res2= uint8(bin2dec(num2str(uint8(res))));
imshow(reshape(res2 , 512 , 512))

% Partie à déchiffrer
dechiffrer = xor(cle, res);
dechiffrer2= uint8(bin2dec(num2str(uint8(dechiffrer))));
figure,
imshow(reshape(dechiffrer2 , 512 , 512))
