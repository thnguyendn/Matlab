function [tabSubBytes]=TabSubBytes(nbreDeBits)

[generateur, arrayRes]=calculerGenerator(nbreDeBits); % Trouver generateur et array des valeurs de corps GF

% Matrice A
A=[1 0 0 0 1 1 1 1;
   1 1 0 0 0 1 1 1;
   1 1 1 0 0 0 1 1;
   1 1 1 1 0 0 0 1;
   1 1 1 1 1 0 0 0;
   0 1 1 1 1 1 0 0;
   0 0 1 1 1 1 1 0;
   0 0 0 1 1 1 1 1];
C=[1 1 0 0 0 1 1 0]';

for p=0:(2^(nbreDeBits/2)-1)
    for q=0:(2^(nbreDeBits/2)-1)
        element_bin=[dec2bin(p,4),dec2bin(q,4)];
        inverse=Inverse(element_bin, arrayRes, nbreDeBits); % Trouver l'inverse de element
        
        % Changer ordre des elements de l inverse
        for i=1:size(inverse,2)
            inverse_contraire(i)=inverse(size(inverse,2)+1-i);
        end
        b_contraire=mod(A*inverse_contraire'+C,2);
        b_contraire=b_contraire';

        % Rechanger ordre des elements de l inverse
        for i=1:size(b_contraire,2)
            b(i)=b_contraire(size(b_contraire,2)+1-i);
        end
        b_string=num2str(b);
        reponse=bin2dec(b_string);
        tabSubBytes(p+1,q+1)=reponse; % Cette matrice tabSubBytes contient les valeurs de la transformation SubBytes en decimal
        % Il faut convertir en hexadecimal si on chiffre des donnees
    end
end

csvwrite('SubBytes.csv',tabSubBytes);

return,

