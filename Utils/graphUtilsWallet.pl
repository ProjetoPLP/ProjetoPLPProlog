:- consult('updateUtils.pl').
:- consult('matrixUtils.pl').
:- consult('../Models/Client/GetSetAttrsClient.pl').


% Atualiza em uma carteira, a partir do seu ID, a nova linha e coluna baseado no novo patrimônio
attClientLineRow(JSONPath, IdUser, OldPatrimony, NewPatrimony) :-
    checkClientColumn(JSONPath, IdUser),
    (   NewPatrimony > OldPatrimony ->
        addRow(JSONPath, IdUser, -1),
        checkClientRowOverflow(JSONPath, IdUser)
    ;   NewPatrimony < OldPatrimony ->
        addRow(JSONPath, IdUser, 1),
        checkClientRowUnderflow(JSONPath, IdUser)
    ;   addRow(JSONPath, IdUser, 0)
    ).


% Verifica se a coluna do gráfico chegou no limite
checkClientColumn(JSONPath, IdUser) :-
    getCol(JSONPath, IdUser, ColValue),
    (   ColValue > 95 ->
        number_string(IdUser, IDString),
        string_concat("../Models/Client/Wallets/wallet", IDString, TempPath),
        string_concat(TempPath, ".txt", Path),
        cleanWLGraph(Path, 11),
        setCol(JSONPath, IDComp, 51)
    ;   addCol(JSONPath, IdUser, 0)
    ).


% Verifica se a linha do gráfico chegou no limite superior
checkClientRowOverflow(JSONPath, IdUser) :-
    getRow(JSONPath, IdUser, RowValue),
    (   RowValue < 11 ->
        number_string(IdUser, IDString),
        string_concat("../Models/Client/Wallets/wallet", IDString, TempPath),
        string_concat(TempPath, ".txt", Path),
        cleanWLGraph(Path, 11),
        setRow(JSONPath, IdUser, 20)
    ;   addRow(JSONPath, IdUser, 0)
    ).


% Verifica se a linha do gráfico chegou no limite inferior
checkClientRowUnderflow(JSONPath, IdUser) :-
    getRow(JSONPath, IdUser, RowValue),
    (   RowValue > 20 ->
        number_string(IdUser, IDString),
        string_concat("../Models/Client/Wallets/wallet", IDString, TempPath),
        string_concat(TempPath, ".txt", Path),
        cleanWLGraph(Path, 11),
        setRow(JSONPath, IdUser, 11)
    ;   addRow(JSONPath, IdUser, 0)
    ).


% Atualiza a próxima coluna em todos os gráficos
attAllClientColumn(_, []) :- !.
attAllClientColumn(JSONPath, [H|T]) :-
    getIdent(JSONPath, H, IdUser),
    addCol(JSONPath, IdUser, 2),
    attAllClientColumn(JSONPath, T).


% Reinicia o gráfico da carteira sobrescrevendo todos os espaços com caracteres vazios
cleanWLGraph(FilePath, 20) :-
    replicate("", 47, Spaces),
    writeMatrixValue(FilePath, Spaces, 20, 50), !.
cleanWLGraph(FilePath, Row) :-
    replicate("", 47, Spaces),
    writeMatrixValue(FilePath, Spaces, Row, 50),
    NextRow is Row + 1,
    cleanWLGraph(FilePath, NextRow).