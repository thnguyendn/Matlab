function [tabInvSubBytes]=TabInvSubBytes(nbreDeBits)

[generateur, arrayRes]=calculerGenerator(nbreDeBits); % Trouver generateur et array des valeurs de corps GF

% Matrice A
A_chiffre = toeplitz([1 0 0 0 1 1 1 0 0 1 1 1 1 0 0 1] , [ 1 1 0 0 1 1 1 0 0 0 1 1 1 0 0 0]);
% Comment trouver la matrice inverse de A_chiffre
A = mod(int8(det(A_chiffre)*inv(A_chiffre)),2);
C=[1 1 0 0 0 1 1 0 0 0 1 1 1 1 1 1]';

for p=0:(2^(nbreDeBits/2)-1)
    for q=0:(2^(nbreDeBits/2)-1)
        element_bin=[dec2bin(p,nbreDeBits/2),dec2bin(q,nbreDeBits/2)];
        
        % Changer ordre des elements de l inverse
        for i=1:size(element_bin,2)
            element_bin_contraire(i)=element_bin(size(element_bin,2)+1-i);
        end
        b_contraire=mod(double(A)*double(element_bin_contraire')+C,2);
        b_contraire=b_contraire';

        % Rechanger ordre des elements de l inverse
        for i=1:size(b_contraire,2)
            b(i)=b_contraire(size(b_contraire,2)+1-i);
        end
        b_string=num2str(b);
        inverse=Inverse(b_string, arrayRes, nbreDeBits); % Trouver l'inverse de element

        reponse=bin2dec(num2str(inverse));
        tabInvSubBytes(p+1,q+1)=reponse; % Cette matrice tabInvSubBytes contient les valeurs de la transformation SubBytes en decimal
        % Il faut convertir en hexadecimal si on chiffre des donnees
    end
end

csvwrite('InvSubBytes.csv',tabInvSubBytes);

return,

