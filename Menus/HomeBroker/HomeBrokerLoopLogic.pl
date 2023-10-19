:- use_module(library(time)).
:- use_module(library(timeout)).
:- use_module(library(random)).
:- consult('../../Utils/GraphUtilsHomeBroker.pl').
:- consult('../../Utils/GraphUtilsWallet.pl').
:- consult('HomeBrokerAttPrice.pl').
:- consult('../Wallet/WalletAttPatrimony.pl').
:- consult('CompanyDown/CompanyDownUpdate.pl').
:- consult('../../Models/Company/SaveCompany.pl').
:- consult('../../Models/Client/SaveClient.pl').
:- consult('../../Models/Clock/GetSetClock.pl').


callLoop(IdComp, Seconds) :-
    get_time(StartTime),
    addClock(Seconds),
    number_string(IdComp, IdString),
    string_concat("./Models/Company/HomeBrokers/homebroker", IdString, Path0),
    string_concat(Path0, ".txt", Path)
    updateMatrixClock(Path),
    add_seconds_to_time(StartTime, Seconds, EndTime),
    loop(IdComp, EndTime).


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
        sleep(0.5),  % Aguarda meio segundo (500 milissegundos)
        loop(IdComp, EndTime)
    ).


add_seconds_to_time(StartTime, Seconds, EndTime) :-
    call_with_timeout(add_seconds(StartTime, Seconds), EndTime, 1000). % Timeout set to 1000 ms.

add_seconds(StartTime, Seconds, EndTime) :-
    EndTime is StartTime + Seconds.