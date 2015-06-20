function [generateur, arrayRes]=calculerGenerator(nbreDeBits)

for alpha=2:2^nbreDeBits-1
    alpha_bin=toDouble(double(dec2bin(alpha,nbreDeBits))-48);
    poly_bin_1=toDouble(double(dec2bin(1,nbreDeBits))-48);
    arrayRes=[];
    arrayRes(1)=0; arrayRes(2)=1; % Deux restes par default
    for i=1:(2^nbreDeBits-2)
        res=PolyMulti(poly_bin_1, alpha_bin,nbreDeBits);
        reponse=0;
        for j=1:size(res,2)
            reponse=reponse+res(j)*(2^(size(res,2)-j));
        end
        
        % test xem res da co trong arrayRes hay chua????
        for k=1:size(arrayRes,2)
            if arrayRes(k)~=reponse
                resInArrayRes=1; % voir si res n'est pas dans l'array des res
            else
                resInArrayRes=0; % voir si res est dans l'array des res, dans ce cas la, on sort de la boucle for
                break;
            end
        end
        
        if resInArrayRes==1 % ajoute res dans l'array des res s'il n'est pas dans cet array
            arrayRes(i+2)=reponse;
        else
            break;
        end
        poly_bin_1=toDouble(PolyMulti(poly_bin_1, alpha_bin, nbreDeBits));
    end
    
    if size(arrayRes,2)==2^nbreDeBits,
        generateur=dec2bin(alpha,nbreDeBits);
        % disp('Generateur : '); disp(dec2bin(alpha,nbreDeBits));
        break;
    end
end

return,

function [res]=toDouble(alpha_bin)
res=0;
    for i=1:size(alpha_bin,2)
        res=res+alpha_bin(i)*10^(size(alpha_bin,2)-i);
    end
return,
