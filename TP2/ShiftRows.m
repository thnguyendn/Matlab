function [ matrice_hexa_arrange ] = ShiftRows(State);

matrice_arrange=[1 5 9 13 17 21 25 29;
                10 14 18 22 26 30 2 6;
                19 23 27 31 3 7 11 15;
                28 32 4 8 12 16 20 24];
matrice_hexa_arrange=State(matrice_arrange);

return,