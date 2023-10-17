:- consult('../../Utils/matrixUtils.pl').

updateHBGraphCandle(Arquivo, Linha, Coluna):-
    writeMatrixValue(Arquivo, "❚", Linha, Coluna).