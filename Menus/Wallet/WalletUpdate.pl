:- consult('../../Utils/MatrixUtils.pl').
:- consult('../../Utils/UpdateUtils.pl').
:- consult('../../Models/Client/GetSetAttrsClient.pl').
:- consult('../../Models/Company/GetSetAttrsCompany.pl').
:- consult('../../Models/Clock/ClockUpdate.pl').
:- consult('./WalletAttPatrimony.pl').


% Aualiza todas as informações da carteira do cliente
updateClientWallet(IdUser) :-
    walletFilePath(IdUser, FilePath),
    getCash(IdUser, Cash),
    getPatrimony(IdUser, Patri),
    getUserName(IdUser, Name),
    getCPF(IdUser,CPF),
    getAllAssets(IdUser, AllAssets),

    resetStocks([1,2,3,4,5,6,7,8,9,10,11,12], FilePath),
    updateMatrixClock(FilePath),
    updateWLCash(FilePath, Cash),
    attClientPatrimony(IdUser),
    updateWLPatrimony(FilePath, Patri),
    updateWLUserName(FilePath, Name),
    updateWLUserCPF(FilePath, CPF),
    updateAllWLCompanyCode(FilePath, AllAssets),
    updateAllWLCompanyPrice(FilePath, AllAssets),
    updateAllWLOwnedStocks(FilePath, AllAssets).

walletFilePath(IdUser, FilePath) :-
    string_concat("../Models/Client/Wallets/wallet", IdUser, Temp),
    string_concat(Temp, ".txt", FilePath).


% Aualiza todas as informações do menu de depósito
updateWalletDeposito(IdUser):-
    resetMenu("./Wallet/DepositoSaque/walletDeposito.txt", "../Sprites/Wallet/walletDeposito_base.txt"),
    getCash(IdUser, Cash),
    getPatrimony(IdUser, Patri),
    getUserName(IdUser, Name),
    getCPF(IdUser, CPF),
    
    updateMatrixClock("./Wallet/DepositoSaque/walletDeposito.txt"),
    updateWLCash("./Wallet/DepositoSaque/walletDeposito.txt", Cash),
    updateWLPatrimony("./Wallet/DepositoSaque/walletDeposito.txt", Patri),
    updateWLUserName("./Wallet/DepositoSaque/walletDeposito.txt", Name),
    updateWLUserCPF("./Wallet/DepositoSaque/walletDeposito.txt", CPF).


% Aualiza todas as informações do menu de saque
updateWalletSaque(IdUser):-
    resetMenu("./Wallet/DepositoSaque/walletSaque.txt", "../Sprites/Wallet/walletSaque_base.txt"),
    getCash(IdUser, Cash),
    getPatrimony(IdUser, Patri),
    getUserName(IdUser, Name),
    getCPF(IdUser, CPF),
    
    updateMatrixClock("./Wallet/DepositoSaque/walletSaque.txt"),
    updateWLCash("./Wallet/DepositoSaque/walletSaque.txt", Cash),
    updateWLPatrimony("./Wallet/DepositoSaque/walletSaque.txt", Patri),
    updateWLUserName("./Wallet/DepositoSaque/walletSaque.txt", Name),
    updateWLUserCPF("./Wallet/DepositoSaque/walletSaque.txt", CPF).


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
    getCompanyCodePosition(IdComp, [Row, Col]),
    writeMatrixValue(FilePath, Code, Row, Col).


% Atualiza o preço de todas as empresas no carteira do usuário
updateAllWLCompanyPrice(_, []) :- !.
updateAllWLCompanyPrice(FilePath, [[IdComp, _]|T]) :-
    getPrice(IdComp, Price),
    getTrendIndicator(IdComp, Trend),
    updateWLCompanyPrice(FilePath, IdComp, Price, Trend),
    updateAllWLCompanyPrice(FilePath, T).


updateWLCompanyPrice(FilePath, IdComp, Price, Trend) :-
    getCompanyPricePosition(IdComp, [Row|Col]),
    string_concat(Trend, Price, Temp1),
    string_concat(Temp1, "0", Temp2),
    fillLeft(Temp2, 7, NewPrice),
    string_length(NewPrice, Len),
    writeMatrixValue(FilePath, NewPrice, Row, Col - Len).


% Atualiza a quantidade de ações que o usuário possui de cada empresa na sua carteira
updateAllWLOwnedStocks(_, []) :- !.
updateAllWLOwnedStocks(FilePath, [[IdComp, Qtd]|T]) :-
    updateWLOwnedStocks(FilePath, IdComp, Qtd),
    updateAllWLOwnedStocks(FilePath, T).


updateWLOwnedStocks(FilePath, IdComp, Qtd) :-
    getOwnedStocksPosition(IdComp, [Row, Col]),
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


getCompanyCodePosition(1, [22, 3]).
getCompanyCodePosition(2, [24, 3]).
getCompanyCodePosition(3, [26, 3]).
getCompanyCodePosition(4, [22, 27]).
getCompanyCodePosition(5, [24, 27]).
getCompanyCodePosition(6, [26, 27]).
getCompanyCodePosition(7, [22, 51]).
getCompanyCodePosition(8, [24, 51]).
getCompanyCodePosition(9, [26, 51]).
getCompanyCodePosition(10, [22, 75]).
getCompanyCodePosition(11, [24, 75]).
getCompanyCodePosition(12, [26, 75]).


getCompanyPricePosition(1, [22, 16]).
getCompanyPricePosition(2, [24, 16]).
getCompanyPricePosition(3, [26, 16]).
getCompanyPricePosition(4, [22, 40]).
getCompanyPricePosition(5, [24, 40]).
getCompanyPricePosition(6, [26, 40]).
getCompanyPricePosition(7, [22, 64]).
getCompanyPricePosition(8, [24, 64]).
getCompanyPricePosition(9, [26, 64]).
getCompanyPricePosition(10, [22, 88]).
getCompanyPricePosition(11, [24, 88]).
getCompanyPricePosition(12, [26, 88]).


getOwnedStocksPosition(1, [22, 23]).
getOwnedStocksPosition(2, [24, 23]).
getOwnedStocksPosition(3, [26, 23]).
getOwnedStocksPosition(4, [22, 47]).
getOwnedStocksPosition(5, [24, 47]).
getOwnedStocksPosition(6, [26, 47]).
getOwnedStocksPosition(7, [22, 71]).
getOwnedStocksPosition(8, [24, 71]).
getOwnedStocksPosition(9, [26, 71]).
getOwnedStocksPosition(10, [22, 95]).
getOwnedStocksPosition(11, [24, 95]).
getOwnedStocksPosition(12, [26, 95]).