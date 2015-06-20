function [State_res]=InvMixColumns(State, Nk)

nbreDeBits=16;
nbreHexDansMot=5;

trans=[58896 51432 12360 61804 61405;
       61405 58896 51432 12360 61804;
       61804 61405 58896 51432 12360;
       12360 61804 61405 58896 51432;
       51432 12360 61804 61405 58896];

% Les matrices servent à rearranger les colonnes de State
arrange_mot=[1 6 11 16; 2 7 12 17; 3 8 13 18; 4 9 14 19; 5 10 15 20];
arrange_mot_res=[1 2 3 4; 5 6 7 8; 9 10 11 12; 13 14 15 16; 17 18 19 20];
State_res=[];

% Creer le mot a partir de State
for p=1:Nk
    mot=State(4*nbreHexDansMot*(p-1)+1:4*nbreHexDansMot*p);
    mot=mot(arrange_mot);
    mot_res=[];
    
    for i=1:size(trans,1)
        res=zeros(1,nbreDeBits);
        for j=1:size(trans,2)
            B=[j,j+nbreHexDansMot,j+2*nbreHexDansMot,j+3*nbreHexDansMot];
            E=double(dec2bin(trans(i,j),nbreDeBits))-48;
            F=double(dec2bin(hex2dec(mot(B)),nbreDeBits))-48;
            res=xor(res,PolyMulti(E,F,nbreDeBits));
            dec2hex(bin2dec(num2str(double(res))));
        end
        mot_res=[mot_res dec2hex(bin2dec(num2str(double(res))),4)];
    end
    
    mot_res=mot_res(arrange_mot_res);
    State_res=[State_res mot_res];
end

return,
