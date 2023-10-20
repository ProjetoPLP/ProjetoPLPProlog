:- consult('../../Utils/GraphUtilsHomeBroker.pl').
:- consult('../../Utils/GraphUtilsWallet.pl').
:- consult('./HomeBrokerAttPrice.pl').
:- consult('../Wallet/WalletAttPatrimony.pl').
:- consult('./CompanyDown/CompanyDownUpdate.pl').
:- consult('../../Models/Company/SaveCompany.pl').
:- consult('../../Models/Client/SaveClient.pl').
:- consult('../../Models/Clock/GetSetClock.pl').


% Define, a partir da entrada do usuário, por quanto tempo o preço e o gráfico deve variar
callLoop(IdComp, Seconds) :-
    get_time(StartTime),
    addClock(Seconds),
    homeBrokerFilePath(IdComp, FilePath),
    updateMatrixClock(FilePath),
    EndTime is StartTime + Seconds,
    loop(IdComp, EndTime).


% Atualiza o gráfico nas empresas e carteiras
loop(IdComp, EndTime) :-
    get_time(CurrentTime),
    (   (CurrentTime >= EndTime ; isDown(IdComp))
    ->  getClientJSON(Clients),
        getCompanyJSON(Companies),
        attAllCompanyColumn(Companies),
        attAllClientColumn(Clients),
        isDown(IdComp)
    ;   getClientJSON(Clients),
        getCompanyJSON(Companies),
        attAllCompanyPriceGraph(IdComp, Companies),
        attAllClientsPatrimonyGraph(Clients),
        sleep(0.5),
        loop(IdComp, EndTime)
    ).