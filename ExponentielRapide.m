function res = ExponentielRapide(a,exp,m)
res=1;

while (exp>0)
    if (mod(exp,2)==1)
        res=mod(res*a,m);
    end
    exp=floor(exp/2);
    a=mod(a*a,m);
end

return,