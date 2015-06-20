function h = Bin2Hex(binary)
switch binary
    case {'0', '00', '000', '0000'}
        h = '0';
    case {'1', '01', '001', '0001'}
        h = '1';
    case {'10', '010', '0010'}
        h = '2';
    case {'11', '011', '0011'}
        h = '3';
    case {'100', '0100'}
        h = '4';
    case {'101', '0101'}
        h = '5';
    case {'110', '0110'}
        h = '6';
    case {'111', '0111'}
        h = '7';
    case '1000'
        h = '8';
    case '1001'
        h = '9';
    case '1010'
        h = 'A';
    case '1011'
        h = 'B';
    case '1100'
        h = 'C';
    case '1101'
        h = 'D';
    case '1110'
        h = 'E';
    case '1111'
        h = 'F';
        
        i = length(bin_str);
n = ceil(i/4); 

for g = n : -1 : 1
    if i > 4
        hex_str(g) = b2h(bin_str(i-3 : i));
        i = i - 4;
    else
        hex_str(g) = b2h(bin_str(1 : i));
    end
end
hex_str
end
return,