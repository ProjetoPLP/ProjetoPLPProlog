:- consult('../../Utils/MatrixUtils.pl').

updateHBGraphCandle(Arquivo, Linha, Coluna):-
    writeMatrixValue(Arquivo, "❚", Linha, Coluna).