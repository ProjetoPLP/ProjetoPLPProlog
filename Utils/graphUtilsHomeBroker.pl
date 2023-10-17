:- consult('updateUtils.pl').
:- consult('matrixUtils.pl').
:- consult('../Models/Company/GetSetAttrsCompany.pl').


attCompanyLineRow(IdComp, OldPrice, NewPrice) :-
    checkCompanyColumn(IdComp),
    (   NewPrice > OldPrice ->
        addRow(IdComp, -1),
        checkCompanyRowOverflow(IdComp)
    ;   NewPrice < OldPrice ->
        addRow(IdComp, 1),
        checkCompanyRowUnderflow(IdComp)
    ;   addRow(IdComp, 0)
    ).


cleanHBGraph(FilePath, 26) :-
    replicate("", 74, Spaces),
    writeMatrixValue(FilePath, 26, 2, Spaces), !.
cleanHBGraph(FilePath, Row) :-
    replicate("", 74, Spaces),
    writeMatrixValue(FilePath, Row, 2, Spaces),
    NextRow is Row + 1,
    cleanHBGraph(FilePath, NextRow).


checkCompanyColumn(idComp) :-
    getCol(idComp, ColValue),
    (   ColValue > 74 ->
        number_string(idComp, IDString),
        string_concat('../Model/Company/HomeBrokers/homebroker', IDString, Path0),
        string_concat(Path0, '.txt', Path),
        cleanHBGraph(Path, 6),
        setCol(ID, 3)
    ;   addCol(IdComp, 0)
    ).


checkCompanyRowOverflow(IdComp) :-
    getRow(IdComp, RowValue),
    (   RowValue < 6 ->
        number_string(idComp, IDString),
        string_concat('../Model/Company/HomeBrokers/homebroker', IDString, Path0),
        string_concat(Path0, '.txt', Path),
        cleanHBGraph(Path, 6),
        setRow(IdComp, 26)
    ;   addRow(IdComp, 0)
    ).


checkCompanyRowUnderflow(IdComp) :-
    getRow(IdComp, RowValue),
    (   RowValue > 26 ->
        number_string(idComp, IDString),
        string_concat('../Model/Company/HomeBrokers/homebroker', IDString, Path0),
        string_concat(Path0, '.txt', Path),
        cleanHBGraph(Path, 6),
        setRow(IdComp, 6)
    ;   addRow(IdComp, 0)
    ).


attAllCompanyColumn([], _).
attAllCompanyColumn([X|Xs]) :-
    getIdent(X, IdComp),
    addCol(IdComp, 3),
    attAllCompanyColumn(Xs).