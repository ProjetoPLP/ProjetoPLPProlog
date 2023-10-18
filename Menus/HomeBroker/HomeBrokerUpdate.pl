:- consult('../../Utils/MatrixUtils.pl').
:- consult('../../Utils/UpdateUtils.pl').
:- consult('../../Models/Client/GetSetAttrsClient.pl').
:- consult('../../Models/Company/GetSetAttrsCompany.pl').


compFilePath(IdComp, FilePath) :-
    string_concat("../Models/Company/HomeBrokers/homebroker", IdComp, Temp),
    string_concat(Temp, ".txt", FilePath).


updateHomeBroker(IdUser, IdComp) :-
    compFilePath(IdComp, FilePath),
    %updateMatrixClock
    getCash("../Data/Clients.json", IdUser, Cash),
    updateHBCash(FilePath, Cash),
    getCompName("../Data/Companies.json", IdComp, Name),
    updateHBCompanyName(FilePath, Name),
    getCode("../Data/Companies.json", IdComp, Code),
    updateHBCompanyCode(FilePath, Code),
    getPrice("../Data/Companies.json", IdComp, Price), getTrendIndicator("../Data/Companies.json", IdComp, Trend),
    updateHBStockPrice(FilePath, Price, Trend),
    getStartPrice("../Data/Companies.json", IdComp, StartPrice),
    updateHBStockStartPrice(FilePath, StartPrice),
    getMaxPrice("../Data/Companies.json", IdComp, MaxPrice),
    updateHBStockMaxPrice(FilePath, MaxPrice),
    getMinPrice("../Data/Companies.json", IdComp, MinPrice),
    updateHBStockMinPrice(FilePath, MinPrice),
    getQtdAssetsInCompany("../Data/Clients.json", IdUser, IdComp, Stocks),
    updateHBOwnedStocks(FilePath, Stocks).


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
    fillLeft(Num, 5, StringR),
    string_length(StringR, Len),
    writeMatrixValue(FilePath, StringR, 21, (95 - Len)).


updateHBCompanyCode(FilePath, Name) :-
    writeMatrixValue(FilePath, Name, 3, 47).


updateHBCompanyName(FilePath, Name) :-
    getCompanyNameCol(Name, 86, Col),
    writeMatrixValue(FilePath, Name, 7, Col).