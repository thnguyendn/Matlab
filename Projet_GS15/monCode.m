function monCode
% Afin de faciliter la gestion du chiffrement pour chaque
% algorithme, il est propose d'ecrire chacune des etape 
% dans une sous-fonction.

% Un petit code permet de demander à l'utilisateur de choisir
% l'algorithme de chiffrement.
fprintf('   ->1<- \t mon Super AES \n   ->2<- \t mon Super El Gamal \n');
choix_chif = input('Choix de l algorithme :\n ');
if choix_chif==2,
	super_ElGamal;
elseif choix_chif==1,
	[nb_char, choix_imp]=super_AES_chiffrement;
    choix_dechif = input('Voulez-vous faire un déchiffrement ? \n', 's');
    if strcmp(choix_dechif, 'Oui'),
        super_AES_dechiffrement(nb_char, choix_imp);
    end
else
	error('Votre choix ne existe pas');
end

return,


