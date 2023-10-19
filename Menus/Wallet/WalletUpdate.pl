:- consult('../../Utils/MatrixUtils.pl').
:- consult('../../Utils/UpdateUtils.pl').
:- consult('../../Models/Client/GetSetAttrsClient.pl').
:- consult('../../Models/Company/GetSetAttrsCompany.pl').
:- consult('../../Models/Clock/ClockUpdate.pl').
:- consult('WalletAttPatrimony.pl').


updateClientWallet(IdUser) :-
    getCash(IdUser, Cash),
    getPatrimony(IdUser, Patri),
    getUserName(IdUser, Name),
    getCPF(IdUser, Cpf),
    getAllAssets(IdUser, AllAssets),
    number_string(IdUser, IdUserString),
    string_concat("../Models/Client/Wallets/wallet", IdUserString, Filepath1),
    string_concat(Filepath1, ".txt", Filepath),

    resetStocks([1,2,3,4,5,6,7,8,9,10,11,12], IdUser),
    updateMatrixClock(Filepath),
    updateWLCash(Filepath, Cash),
    attClientPatrimony(IdUser),
    updateWLPatrimony(Filepath, Patri),
    updateWLUserName(Filepath, Name),
    updateWLUserCPF(Filepath, Cpf),
    updateAllWLCompanyCode(Filepath, AllAssets),
    updateAllWLCompanyPrice(Filepath, AllAssets),
    updateAllWLOwnedStocks(Filepath, AllAssets).


updateWalletDeposito(IdUser):-
    getCash(IdUser, Cash),
    getPatrimony(IdUser, Patri),
    getUserName(IdUser, Name),
    getCPF(IdUser, Cpf),
    
    resetMenu("Wallet/DepositoSaque/walletDeposito.txt", "../Sprites/Wallet/walletDeposito_base.txt"),
    updateMatrixClock("Wallet/DepositoSaque/walletDeposito.txt"),
    updateWLCash("Wallet/DepositoSaque/walletDeposito.txt", Cash),
    updateWLPatrimony("Wallet/DepositoSaque/walletDeposito.txt", Patri),
    updateWLUserName("Wallet/DepositoSaque/walletDeposito.txt", Name),
    updateWLUserCPF("Wallet/DepositoSaque/walletDeposito.txt", Cpf).


updateWalletSaque(IdUser):-
    getCash(IdUser, Cash),
    getPatrimony(IdUser, Patri),
    getUserName(IdUser, Name),
    getCPF(IdUser, Cpf),
    
    resetMenu("Wallet/DepositoSaque/walletSaque.txt", "../Sprites/Wallet/walletSaque_base.txt"),
    updateMatrixClock("Wallet/DepositoSaque/walletSaque.txt"),
    updateWLCash("Wallet/DepositoSaque/walletSaque.txt", Cash),
    updateWLPatrimony("Wallet/DepositoSaque/walletSaque.txt", Patri),
    updateWLUserName("Wallet/DepositoSaque/walletSaque.txt", Name),
    updateWLUserCPF("Wallet/DepositoSaque/walletSaque.txt", Cpf).


updateWLCash(Filepath, Cash) :-
    number_string(Cash, CashString),
    string_concat(CashString, "0", Val),
    fillLeft(Val, 9, R),
    length(R, Comp),
    Col is 22 - Comp,
    writeMatrixValue(Filepath, R, 13, Col).


updateWLPatrimony(Filepath, Patri) :-
    number_string(Patri, PatriString),
    string_concat(PatriString, "0", Val),
    fillLeft(Val, 10, R),
    length(R, Comp),
    Col is 24 - Comp,
    writeMatrixValue(Filepath, R, 6, Col).


updateWLGraphCandle(Filepath, Row, Col) :-
    writeMatrixValue(Filepath, "❚", Row, Col).


updateAllWLCompanyCode(_, []) :- !.
updateAllWLCompanyCode(Filepath, [[IdComp, Num]|T]) :-
    getCode(IdComp, Code),
    updateWLCompanyCode(Filepath, IdComp, Code),
    updateAllWLCompanyCode(Filepath, T).


updateWLCompanyCode(Filepath, Id, Code) :-
    getCompanyCodePosition(Id, [Row, Col]),
    writeMatrixValue(Filepath, Code, Row, Col).


updateAllWLCompanyPrice(_, []) :- !.
updateAllWLCompanyPrice(Filepath, [[IdComp, Num]|T]) :-
    getPrice(IdComp, Price),
    getTrendIndicator(IdComp, TrendInd),
    number_string(Price, PriceString),
    string_concat(PriceString, "0", Str),

    updateWLCompanyPrice(Filepath, IdComp, Str, TrendInd),
    updateAllWLCompanyPrice(Filepath, T).


updateWLCompanyPrice(Filepath, Id, Price, TrendInd) :-
    getCompanyPricePosition(Id, [Row, Col]),
    number_string(Price, PriceString),
    string_concat(TrendInd, PriceString, Str),
    fillLeft(Str, 7, Val),
    length(Val, Comp),
    Col1 is Col - Comp,
    writeMatrixValue(Filepath, Val, Row, Col1).


updateAllWLOwnedStocks(_, []) :- !.
updateAllWLOwnedStocks(Filepath, [[IdComp, Num]|T]) :-
    number_string(Num, NumString),
    updateWLOwnedStocks(Filepath, IdComp, NumString),
    updateAllWLOwnedStocks(Filepath, T).


updateWLOwnedStocks(Filepath, Id, Num) :-
    getOwnedStocksPosition(Id, [Row, Col]),
    fillLeft(Num, 5, R),
    length(R, Comp),
    Col1 is Col - Comp,
    writeMatrixValue(Filepath, R, Row, Col1).


updateWLUserName(Filepath, Name) :-
    writeMatrixValue(Filepath, Name, 10, 6).


updateWLUserCPF(FilePath, Cpf) :-
    writeMatrixValue(FilePath, Cpf, 11, 6).


resetStocks([], _) :- !.
resetStocks([H|T], IdUser) :-
    number_string(IdUser, IdUserString),
    string_concat("../Models/Client/Wallets/wallet", IdUserString, Filepath1),
    string_concat(Filepath1, ".txt", Filepath),

    updateWLCompanyCode(Filepath, H, "-----"),
    updateWLCompanyPrice(Filepath, H, "     ", " "),
    updateWLOwnedStocks(Filepath, H, "-----"),
    resetStocks(T, IdUser).


getCompanyCodePosition(ID, Position) :-
(   ID =:= 1 -> Position = [22, 3]
;   ID =:= 2 -> Position = [24, 3]
;   ID =:= 3 -> Position = [26, 3]
;   ID =:= 4 -> Position = [22, 27]
;   ID =:= 5 -> Position = [24, 27]
;   ID =:= 6 -> Position = [26, 27]
;   ID =:= 7 -> Position = [22, 51]
;   ID =:= 8 -> Position = [24, 51]
;   ID =:= 9 -> Position = [26, 51]
;   ID =:= 10 -> Position = [22, 75]
;   ID =:= 11 -> Position = [24, 75]
;   ID =:= 12 -> Position = [26, 75]
).


getCompanyPricePosition(ID, Position) :-
(   ID =:= 1 -> Position = [22, 16]
;   ID =:= 2 -> Position = [24, 16]
;   ID =:= 3 -> Position = [26, 16]
;   ID =:= 4 -> Position = [22, 40]
;   ID =:= 5 -> Position = [24, 40]
;   ID =:= 6 -> Position = [26, 40]
;   ID =:= 7 -> Position = [22, 64]
;   ID =:= 8 -> Position = [24, 64]
;   ID =:= 9 -> Position = [26, 64]
;   ID =:= 10 -> Position = [22, 88]
;   ID =:= 11 -> Position = [24, 88]
;   ID =:= 12 -> Position = [26, 88]
).


getOwnedStocksPosition(ID, Position) :-
(   ID =:= 1 -> Position = [22, 23]
;   ID =:= 2 -> Position = [24, 23]
;   ID =:= 3 -> Position = [26, 23]
;   ID =:= 4 -> Position = [22, 47]
;   ID =:= 5 -> Position = [24, 47]
;   ID =:= 6 -> Position = [26, 47]
;   ID =:= 7 -> Position = [22, 71]
;   ID =:= 8 -> Position = [24, 71]
;   ID =:= 9 -> Position = [26, 71]
;   ID =:= 10 -> Position = [22, 95]
;   ID =:= 11 -> Position = [24, 95]
;   ID =:= 12 -> Position = [26, 95]
).
