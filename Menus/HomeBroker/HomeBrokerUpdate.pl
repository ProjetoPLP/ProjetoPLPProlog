:- consult('../../Utils/MatrixUtils.pl').
:- consult('../../Utils/UpdateUtils').


updateHBStockPrice(FilePath, Price, TrendInd) :-
    string_concat(TrendInd, Price, Temp1),
    string_concat(Temp1, "0", Temp2),
    fillLeft(Temp2, 7, StringR),
    string_length(StringR, Len),
    writeMatrixValue(FilePath, StringR, 11, (95 - Len)).


updateHBGraphCandle(FilePath, Row, Col) :-
    writeMatrixValue(FilePath, "❚", Row, Col).


updateHBStockMaxPrice(FilePath, Price) :-
    string_concat(Price, "0", Temp),
    fillLeft(Temp, 6, StringR),
    string_length(StringR, Len),
    writeMatrixValue(FilePath, StringR, 16, (95 - Len)).


updateHBStockMinPrice(FilePath, Price) :-
    string_concat(Price, "0", Temp),
    fillLeft(Temp, 6, StringR),
    string_length(StringR, Len),
    writeMatrixValue(FilePath, StringR, 18, (95 - Len)).


updateHBStockStartPrice(FilePath, Price) :-
    string_concat(Price, "0", Temp),
    fillLeft(Temp, 6, StringR),
    string_length(StringR, Len),
    writeMatrixValue(FilePath, StringR, 14, (95 - Len)).


updateHBCash(FilePath, Cash) :-
    string_concat(Cash, "0", Temp),
    fillLeft(Temp, 9, StringR),
    string_length(StringR, Len),
    writeMatrixValue(FilePath, StringR, 3, (77 - Len)).


updateHBOwnedStocks(FilePath, Num) :-
    string_concat(Num, "0", Temp),
    fillLeft(Temp, 5, StringR),
    string_length(StringR, Len),
    writeMatrixValue(FilePath, StringR, 21, (95 - Len)).


updateHBCompanyCode(FilePath, Name) :-
    writeMatrixValue(FilePath, Name, 3, 47).


updateHBCompanyName(FilePath, Name) :-
    getCompanyNameCol(Name, 86, Col),
    writeMatrixValue(FilePath, Name, 7, Col).