:- consult('UpdateUtils.pl').
:- consult('MatrixUtils.pl').
:- consult('../Models/Company/GetSetAttrsCompany.pl').


% Atualiza em uma empresa, a partir do seu ID, a nova linha e coluna baseado no novo preço
attCompanyLineRow(JSONPath, IdComp, OldPrice, NewPrice) :-
    checkCompanyColumn(JSONPath, IdComp),
    (   NewPrice > OldPrice ->
        addRow(JSONPath, IdComp, -1),
        checkCompanyRowOverflow(JSONPath, IdComp)
    ;   NewPrice < OldPrice ->
        addRow(JSONPath, IdComp, 1),
        checkCompanyRowUnderflow(JSONPath, IdComp)
    ;   addRow(JSONPath, IdComp, 0)
    ).


% Verifica se a coluna do gráfico chegou no limite
checkCompanyColumn(JSONPath, IdComp) :-
    getCol(JSONPath, IdComp, ColValue),
    (   ColValue > 74 ->
        number_string(IdComp, IDString),
        string_concat("../Models/Company/HomeBrokers/homebroker", IDString, TempPath),
        string_concat(TempPath, ".txt", Path),
        cleanHBGraph(Path, 6),
        setCol(JSONPath, IdComp, 3)
    ;   addCol(JSONPath, IdComp, 0)
    ).


% Verifica se a linha do gráfico chegou no limite superior
checkCompanyRowOverflow(JSONPath, IdComp) :-
    getRow(JSONPath, IdComp, RowValue),
    (   RowValue < 6 ->
        number_string(IdComp, IDString),
        string_concat("../Models/Company/HomeBrokers/homebroker", IDString, TempPath),
        string_concat(TempPath, ".txt", Path),
        cleanHBGraph(Path, 6),
        setRow(JSONPath, IdComp, 26)
    ;   addRow(JSONPath, IdComp, 0)
    ).


% Verifica se a linha do gráfico chegou no limite inferior
checkCompanyRowUnderflow(JSONPath, IdComp) :-
    getRow(JSONPath, IdComp, RowValue),
    (   RowValue > 26 ->
        number_string(IdComp, IDString),
        string_concat("../Models/Company/HomeBrokers/homebroker", IDString, TempPath),
        string_concat(TempPath, ".txt", Path),
        cleanHBGraph(Path, 6),
        setRow(JSONPath, IdComp, 6)
    ;   addRow(JSONPath, IdComp, 0)
    ).


% Atualiza a próxima coluna em todos os gráficos
attAllCompanyColumn(_, []) :- !.
attAllCompanyColumn(JSONPath, [X|Xs]) :-
    getIdent(JSONPath, X, IdComp),
    addCol(JSONPath, IdComp, 3),
    attAllCompanyColumn(JSONPath, Xs).


% Reinicia o gráfico do Home Broker sobrescrevendo todos os espaços com caracteres vazios
cleanHBGraph(JSONPath, 26) :-
    replicate("", 74, Spaces),
    writeMatrixValue(JSONPath, Spaces, 26, 2), !.
cleanHBGraph(JSONPath, Row) :-
    replicate("", 74, Spaces),
    writeMatrixValue(JSONPath, Spaces, Row, 2),
    NextRow is Row + 1,
    cleanHBGraph(JSONPath, NextRow).