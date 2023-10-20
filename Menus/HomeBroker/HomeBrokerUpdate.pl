:- consult('../../Utils/MatrixUtils.pl').
:- consult('../../Utils/UpdateUtils.pl').
:- consult('../../Utils/GraphUtilsHomeBroker.pl').
:- consult('../../Models/Client/GetSetAttrsClient.pl').
:- consult('../../Models/Company/GetSetAttrsCompany.pl').
:- consult('../../Models/Clock/ClockUpdate.pl').


% Atualiza todas as informações do Home Broker de uma determinada empresa
updateHomeBroker(IdUser, IdComp) :-
    homeBrokerFilePath(IdComp, FilePath),
    getCash(IdUser, Cash),
    getCompName(IdComp, Name),
    getCode(IdComp, Code),
    getPrice(IdComp, Price), getTrendIndicator(IdComp, Trend),
    getStartPrice(IdComp, StartPrice),
    getMaxPrice(IdComp, MaxPrice),
    getMinPrice(IdComp, MinPrice),
    getQtdAssetsInCompany(IdUser, IdComp, Stocks),

    updateMatrixClock(FilePath),
    updateHBCash(FilePath, Cash),
    updateHBCompanyName(FilePath, Name),
    updateHBCompanyCode(FilePath, Code),
    updateHBStockPrice(FilePath, Price, Trend),
    updateHBStockStartPrice(FilePath, StartPrice),
    updateHBStockMaxPrice(FilePath, MaxPrice),
    updateHBStockMinPrice(FilePath, MinPrice),
    updateHBOwnedStocks(FilePath, Stocks).


% Atualiza todas as informações do menu de compras em um Home Broker de uma determinada empresa
updateHomeBrokerBuy(IdUser, IdComp) :-
    FilePath = "./HomeBroker/BuySell/homebrokerBuy.txt",
    resetMenu(FilePath, "../Sprites/HomeBroker/homebrokerBuy_base.txt"),
    getCash(IdUser, Cash),
    getCompName(IdComp, Name),
    getCode(IdComp, Code),
    getPrice(IdComp, Price), getTrendIndicator(IdComp, Trend),
    getQtdAssetsInCompany(IdUser, IdComp, Stocks),

    updateMatrixClock(FilePath),
    updateHBCash(FilePath, Cash),
    updateHBCompanyName(FilePath, Name),
    updateHBCompanyCode(FilePath, Code),
    updateHBStockPrice(FilePath, Price, Trend),
    updateHBOwnedStocks(FilePath, Stocks).


% Atualiza todas as informações do menu de vendas em um Home Broker de uma determinada empresa
updateHomeBrokerSell(IdUser, IdComp) :-
    FilePath = "./HomeBroker/BuySell/homebrokerSell.txt",
    resetMenu(FilePath, "../Sprites/HomeBroker/homebrokerSell_base.txt"),
    getCash(IdUser, Cash),
    getCompName(IdComp, Name),
    getCode(IdComp, Code),
    getPrice(IdComp, Price), getTrendIndicator(IdComp, Trend),
    getQtdAssetsInCompany(IdUser, IdComp, Stocks),

    updateMatrixClock(FilePath),
    updateHBCash(FilePath, Cash),
    updateHBCompanyName(FilePath, Name),
    updateHBCompanyCode(FilePath, Code),
    updateHBStockPrice(FilePath, Price, Trend),
    updateHBOwnedStocks(FilePath, Stocks).


updateHBStockPrice(FilePath, Price, TrendInd) :-
    string_concat(TrendInd, Price, Temp1),
    string_concat(Temp1, "0", Temp2),
    fillLeft(Temp2, 7, StringR),
    string_length(StringR, Len),
    writeMatrixValue(FilePath, StringR, 11, (95 - Len)).


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