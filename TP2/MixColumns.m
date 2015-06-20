function [State_res]=MixColumns(State);

nbreOctDansMot=4;
nbreDeBits=8;
nbreMotsDansState=4;
trans=[2 3 1 1;
       1 2 3 1;
       1 1 2 3;
       3 1 1 2];

% Les matrices servent à rearranger les colonnes de State
arrange_mot=[1 5; 2 6; 3 7; 4 8];
arrange_mot_res=[1 2; 3 4; 5 6; 7 8];
State_res=[];

% Creer le mot a partir de State
for p=1:nbreMotsDansState
    mot=State(8*(p-1)+1:8*p);
    mot=mot(arrange_mot);
    mot_res=[];
    
    for i=1:size(trans,1)
        res=zeros(1,nbreDeBits);
        for j=1:size(trans,2)
            B=[j,j+nbreOctDansMot];
            E=toDouble(double(dec2bin(trans(i,j),nbreDeBits))-48);
            F=toDouble(double(dec2bin(hex2dec(mot(B))))-48);
            res=xor(res,PolyMulti(E,F,nbreDeBits));
            dec2hex(bin2dec(num2str(double(res))));
        end
        mot_res=[mot_res dec2hex(bin2dec(num2str(double(res))),2)];
    end
    
    mot_res=mot_res(arrange_mot_res);
    State_res=[State_res mot_res];
end

% Transformer matrice hexa en matrice decimal
% for i=1:size(State_res,1)
%     for j=1:(size(State_res,2)/2)
%         element_hexa=State_res(i,2*j-1:2*j);
%         element_dec=hex2dec((element_hexa));
%         
%         State_dec(i,j)=element_dec;
%     end
% end

return,

function [res]=toDouble(alpha_bin)
res=0;
    for i=1:size(alpha_bin,2)
        res=res+alpha_bin(i)*10^(size(alpha_bin,2)-i);
    end
return,