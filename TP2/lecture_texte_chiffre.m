function [ texte_blocs_hex ] = lecture_texte_chiffre;

matrice_arrange=[1 6 11 16 21 26 31 36 41 46 51 56 61 66 71 76;
                 2 7 12 17 22 27 32 37 42 47 52 57 62 67 72 77;
                 3 8 13 18 23 28 33 38 43 48 53 58 63 68 73 78;
                 4 9 14 19 24 29 34 39 44 49 54 59 64 69 74 79;
                 5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80];

string = './chiffrer.txt';
fid = fopen(string);
texte_clair = fread(fid);
fclose(fid);

texte_blocs_hex = texte_clair(matrice_arrange);


return,