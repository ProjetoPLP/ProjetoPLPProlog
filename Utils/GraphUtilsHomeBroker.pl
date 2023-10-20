:- consult('UpdateUtils.pl').
:- consult('MatrixUtils.pl').
:- consult('../Models/Company/GetSetAttrsCompany.pl').


% Atualiza em uma empresa, a partir do seu ID, a nova linha e coluna baseado no novo preço
attCompanyLineRow(IdComp, OldPrice, NewPrice) :-
    checkCompanyColumn(IdComp),
    (   NewPrice > OldPrice ->
        addCompRow(IdComp, -1),
        checkCompanyRowOverflow(IdComp)
    ;   NewPrice < OldPrice ->
        addCompRow(IdComp, 1),
        checkCompanyRowUnderflow(IdComp)
    ;   addCompRow(IdComp, 0)
    ).


% Verifica se a coluna do gráfico chegou no limite
checkCompanyColumn(IdComp) :-
    getCompCol(IdComp, ColValue),
    (   ColValue > 74 ->
        homeBrokerFilePath(IdComp, FilePath),
        cleanHBGraph(FilePath, 6),
        setCompCol(IdComp, 3)
    ;   addCompCol(IdComp, 0)
    ).


% Verifica se a linha do gráfico chegou no limite superior
checkCompanyRowOverflow(IdComp) :-
    getCompRow(IdComp, RowValue),
    (   RowValue < 6 ->
        homeBrokerFilePath(IdComp, FilePath),
        cleanHBGraph(FilePath, 6),
        setCompRow(IdComp, 26)
    ;   addCompRow(IdComp, 0)
    ).


% Verifica se a linha do gráfico chegou no limite inferior
checkCompanyRowUnderflow(IdComp) :-
    getCompRow(IdComp, RowValue),
    (   RowValue > 26 ->
        homeBrokerFilePath(IdComp, FilePath),
        cleanHBGraph(FilePath, 6),
        setCompRow(IdComp, 6)
    ;   addCompRow(IdComp, 0)
    ).


% Atualiza a próxima coluna em todos os gráficos
attAllCompanyColumn(_, []) :- !.
attAllCompanyColumn([H|T]) :-
    getCompIdent(H, IdComp),
    addCompCol(IdComp, 3),
    attAllCompanyColumn(T).


% Reinicia o gráfico do Home Broker sobrescrevendo todos os espaços com caracteres vazios
cleanHBGraph(FilePath, 26) :-
    replicate("", 74, Spaces),
    writeMatrixValue(FilePath, Spaces, 26, 2), !.
cleanHBGraph(FilePath, Row) :-
    replicate("", 74, Spaces),
    writeMatrixValue(FilePath, Spaces, Row, 2),
    NextRow is Row + 1,
    cleanHBGraph(FilePath, NextRow).


% Retorna o caminho para o Home Broker da empresa a partir do seu ID
homeBrokerFilePath(IdComp, FilePath) :-
    string_concat("../Models/Company/HomeBrokers/homebroker", IdComp, Temp),
    string_concat(Temp, ".txt", FilePath).