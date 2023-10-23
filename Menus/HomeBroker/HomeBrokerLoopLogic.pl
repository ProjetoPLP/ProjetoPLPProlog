:- module(homeBrokerLoopLogic, [callLoop/2]).

:- use_module('./Utils/GraphUtilsHomeBroker.pl').
:- use_module('./Utils/GraphUtilsWallet.pl').
:- use_module('./Menus/HomeBroker/HomeBrokerAttPrice.pl').
:- use_module('./Menus/Wallet/WalletAttPatrimony.pl').
:- use_module('./Menus/HomeBroker/CompanyDown/CompanyDownUpdate.pl').
:- use_module('./Models/Company/SaveCompany.pl').
:- use_module('./Models/Client/SaveClient.pl').
:- use_module('./Models/Clock/GetSetClock.pl').
:- use_module('./Models/Clock/ClockUpdate.pl').


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