function [inverse]=Inverse(element, arrayRes, nbreDeBits)

element_dec=bin2dec(element);

for i=1:size(arrayRes,2)
    if element_dec==arrayRes(i)
        if i==1,
            index_inverse=1;
        elseif i==2,
            index_inverse=2;
        else
            index_inverse=2^nbreDeBits+3-i;
        end
        break;
    end
end

inverse=dec2bin(arrayRes(index_inverse),nbreDeBits);% inverse en char
inverse=double(inverse)-48;

return,