:- module(walletUpdate, [updateClientWallet/1, updateWalletDeposito/1, updateWalletSaque/1]).

:- use_module('./Utils/MatrixUtils.pl').
:- use_module('./Utils/UpdateUtils.pl').
:- use_module('./Utils/GraphUtilsWallet.pl').
:- use_module('./Models/Client/GetSetAttrsClient.pl').
:- use_module('./Models/Company/GetSetAttrsCompany.pl').
:- use_module('./Models/Clock/ClockUpdate.pl').
:- use_module('./Menus/Wallet/WalletAttPatrimony.pl').


% Aualiza todas as informações da carteira do cliente
updateClientWallet(IdUser) :-
    walletFilePath(IdUser, FilePath),
    getCash(IdUser, Cash),
    attClientPatrimony(IdUser),
    getPatrimony(IdUser, Patri),
    getUserName(IdUser, Name),
    getCPF(IdUser,CPF),
    getAllAssets(IdUser, AllAssets),

    resetStocks([1,2,3,4,5,6,7,8,9,10,11,12], FilePath),
    updateMatrixClock(FilePath),
    updateWLCash(FilePath, Cash),
    updateWLPatrimony(FilePath, Patri),
    updateWLUserName(FilePath, Name),
    updateWLUserCPF(FilePath, CPF),
    updateAllWLCompanyCode(FilePath, AllAssets),
    updateAllWLCompanyPrice(FilePath, AllAssets),
    updateAllWLOwnedStocks(FilePath, AllAssets).


% Aualiza todas as informações do menu de depósito
updateWalletDeposito(IdUser):-
    FilePath = "./Menus/Wallet/DepositoSaque/walletDeposito.txt",
    resetMenu(FilePath, "./Sprites/Wallet/walletDeposito_base.txt"),
    getCash(IdUser, Cash),
    getPatrimony(IdUser, Patri),
    getUserName(IdUser, Name),
    getCPF(IdUser, CPF),
    
    updateMatrixClock(FilePath),
    updateWLCash(FilePath, Cash),
    updateWLPatrimony(FilePath, Patri),
    updateWLUserName(FilePath, Name),
    updateWLUserCPF(FilePath, CPF).


% Aualiza todas as informações do menu de saque
updateWalletSaque(IdUser):-
    FilePath = "./Menus/Wallet/DepositoSaque/walletSaque.txt",
    resetMenu(FilePath, "./Sprites/Wallet/walletSaque_base.txt"),
    getCash(IdUser, Cash),
    getPatrimony(IdUser, Patri),
    getUserName(IdUser, Name),
    getCPF(IdUser, CPF),
    
    updateMatrixClock(FilePath),
    updateWLCash(FilePath, Cash),
    updateWLPatrimony(FilePath, Patri),
    updateWLUserName(FilePath, Name),
    updateWLUserCPF(FilePath, CPF).


updateWLCash(FilePath, Cash) :-
    string_concat(Cash, "0", Temp),
    fillLeft(Temp, 9, StringR),
    string_length(StringR, Len),
    writeMatrixValue(FilePath, StringR, 13, (22 - Len)).


updateWLPatrimony(FilePath, Patrimony) :-
    string_concat(Patrimony, "0", Temp),
    fillLeft(Temp, 10, StringR),
    string_length(StringR, Len),
    writeMatrixValue(FilePath, StringR, 6, (24 - Len)).


% Atualiza o código de todas as empresas no carteira do usuário
updateAllWLCompanyCode(_, []) :- !.
updateAllWLCompanyCode(FilePath, [[IdComp, _]|T]) :-
    getCode(IdComp, Code),
    updateWLCompanyCode(FilePath, IdComp, Code),
    updateAllWLCompanyCode(FilePath, T).


updateWLCompanyCode(FilePath, IdComp, Code) :-
    getWLCompanyCodePosition(IdComp, [Row, Col]),
    writeMatrixValue(FilePath, Code, Row, Col).


% Atualiza o preço de todas as empresas no carteira do usuário
updateAllWLCompanyPrice(_, []) :- !.
updateAllWLCompanyPrice(FilePath, [[IdComp, _]|T]) :-
    getPrice(IdComp, Price),
    getTrendIndicator(IdComp, Trend),
    string_concat(Price, "0", NewPrice),
    updateWLCompanyPrice(FilePath, IdComp, NewPrice, Trend),
    updateAllWLCompanyPrice(FilePath, T).


updateWLCompanyPrice(FilePath, IdComp, Price, Trend) :-
    getWLCompanyPricePosition(IdComp, [Row|Col]),
    string_concat(Trend, Price, Temp),
    fillLeft(Temp, 7, NewPrice),
    string_length(NewPrice, Len),
    writeMatrixValue(FilePath, NewPrice, Row, Col - Len).


% Atualiza a quantidade de ações que o usuário possui de cada empresa na sua carteira
updateAllWLOwnedStocks(_, []) :- !.
updateAllWLOwnedStocks(FilePath, [[IdComp, Qtd]|T]) :-
    updateWLOwnedStocks(FilePath, IdComp, Qtd),
    updateAllWLOwnedStocks(FilePath, T).


updateWLOwnedStocks(FilePath, IdComp, Qtd) :-
    getWLOwnedStocksPosition(IdComp, [Row, Col]),
    fillLeft(Qtd, 5, StringR),
    string_length(StringR, Len),
    writeMatrixValue(FilePath, StringR, Row, (Col - Len)).


updateWLUserName(FilePath, Name) :-
    writeMatrixValue(FilePath, Name, 10, 6).


updateWLUserCPF(FilePath, CPF) :-
    writeMatrixValue(FilePath, CPF, 11, 6).


% Reseta todas as informações de ações do usuário
resetStocks([], _) :- !.
resetStocks([H|T], FilePath) :-
    updateWLCompanyCode(FilePath, H, "-----"),
    updateWLCompanyPrice(FilePath, H, "     ", " "),
    updateWLOwnedStocks(FilePath, H, "-----"),
    resetStocks(T, FilePath).


getWLCompanyCodePosition(1, [22, 3]).
getWLCompanyCodePosition(2, [24, 3]).
getWLCompanyCodePosition(3, [26, 3]).
getWLCompanyCodePosition(4, [22, 27]).
getWLCompanyCodePosition(5, [24, 27]).
getWLCompanyCodePosition(6, [26, 27]).
getWLCompanyCodePosition(7, [22, 51]).
getWLCompanyCodePosition(8, [24, 51]).
getWLCompanyCodePosition(9, [26, 51]).
getWLCompanyCodePosition(10, [22, 75]).
getWLCompanyCodePosition(11, [24, 75]).
getWLCompanyCodePosition(12, [26, 75]).


getWLCompanyPricePosition(1, [22, 16]).
getWLCompanyPricePosition(2, [24, 16]).
getWLCompanyPricePosition(3, [26, 16]).
getWLCompanyPricePosition(4, [22, 40]).
getWLCompanyPricePosition(5, [24, 40]).
getWLCompanyPricePosition(6, [26, 40]).
getWLCompanyPricePosition(7, [22, 64]).
getWLCompanyPricePosition(8, [24, 64]).
getWLCompanyPricePosition(9, [26, 64]).
getWLCompanyPricePosition(10, [22, 88]).
getWLCompanyPricePosition(11, [24, 88]).
getWLCompanyPricePosition(12, [26, 88]).


getWLOwnedStocksPosition(1, [22, 23]).
getWLOwnedStocksPosition(2, [24, 23]).
getWLOwnedStocksPosition(3, [26, 23]).
getWLOwnedStocksPosition(4, [22, 47]).
getWLOwnedStocksPosition(5, [24, 47]).
getWLOwnedStocksPosition(6, [26, 47]).
getWLOwnedStocksPosition(7, [22, 71]).
getWLOwnedStocksPosition(8, [24, 71]).
getWLOwnedStocksPosition(9, [26, 71]).
getWLOwnedStocksPosition(10, [22, 95]).
getWLOwnedStocksPosition(11, [24, 95]).
getWLOwnedStocksPosition(12, [26, 95]).