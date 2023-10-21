:- consult('UpdateUtils.pl').
:- consult('MatrixUtils.pl').
:- consult('../Models/Client/GetSetAttrsClient.pl').


% Atualiza em uma carteira, a partir do seu ID, a nova linha e coluna baseado no novo patrimônio
attClientLineRow(IdUser, OldPatrimony, NewPatrimony) :-
    checkClientColumn(IdUser),
    (   NewPatrimony > OldPatrimony ->
        addUserRow(IdUser, -1),
        checkClientRowOverflow(IdUser)
    ;   NewPatrimony < OldPatrimony ->
        addUserRow(IdUser, 1),
        checkClientRowUnderflow(IdUser)
    ;   addUserRow(IdUser, 0)
    ).


% Verifica se a coluna do gráfico chegou no limite
checkClientColumn(IdUser) :-
    getUserCol(IdUser, ColValue),
    (   ColValue > 95 ->
        walletFilePath(IdUser, FilePath),
        cleanWLGraph(FilePath, 11),
        setUserCol(IdUser, 51)
    ;   addUserCol(IdUser, 0)
    ).


% Verifica se a linha do gráfico chegou no limite superior
checkClientRowOverflow(IdUser) :-
    getUserRow(IdUser, RowValue),
    (   RowValue < 11 ->
        walletFilePath(IdUser, FilePath),
        cleanWLGraph(FilePath, 11),
        setUserRow(IdUser, 20)
    ;   addUserRow(IdUser, 0)
    ).


% Verifica se a linha do gráfico chegou no limite inferior
checkClientRowUnderflow(IdUser) :-
    getUserRow(IdUser, RowValue),
    (   RowValue > 20 ->
        walletFilePath(IdUser, FilePath),
        cleanWLGraph(FilePath, 11),
        setUserRow(IdUser, 11)
    ;   addUserRow(IdUser, 0)
    ).


% Atualiza a próxima coluna em todos os gráficos
attAllClientColumn([]) :- !.
attAllClientColumn([H|T]) :-
    getUserIdent(H, IdUser),
    addUserCol(IdUser, 2),
    attAllClientColumn(T).


% Reinicia o gráfico da carteira sobrescrevendo todos os espaços com caracteres vazios
cleanWLGraph(FilePath, 20) :-
    replicate("", 47, Spaces),
    writeMatrixValue(FilePath, Spaces, 20, 50), !.
cleanWLGraph(FilePath, Row) :-
    replicate("", 47, Spaces),
    writeMatrixValue(FilePath, Spaces, Row, 50),
    NextRow is Row + 1,
    cleanWLGraph(FilePath, NextRow).


% Retorna o caminha da carteira do cliente a partir do seu ID
walletFilePath(IdUser, FilePath) :-
    string_concat("./Models/Client/Wallets/wallet", IdUser, Temp),
    string_concat(Temp, ".txt", FilePath).


updateWLGraphCandle(Filepath, Row, Col) :-
    writeMatrixValue(Filepath, "❚", Row, Col).