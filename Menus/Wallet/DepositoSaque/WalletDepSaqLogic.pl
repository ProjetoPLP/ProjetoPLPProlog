:- module(walletDepSaqLogic, [depositar/2, sacarTudo/1, sacar200/1, sacar500/1]).

:- use_module('./Models/Client/GetSetAttrsClient.pl').


depositar(IdUser, CanDeposit) :-
    (CanDeposit = true ->
        addCash(IdUser, 100),
        setCanDeposit(IdUser, false)
    ; writeln("\nDepósito negado. O cliente não realizou um saque anteriormente."), sleep(1.5)
    ).


sacarTudo(IdUser) :-
    getCash(IdUser, Cash),
    (Cash >= 200 ->
        setCash(IdUser, 0),
        setCanDeposit(IdUser, true)
    ; writeln("\nSaque negado. O cliente não possui um saldo de 200 reais ou mais."), sleep(1.5)
    ).


sacar200(IdUser) :-
    getCash(IdUser, Cash),
    (Cash >= 200 ->
        addCash(IdUser, -200),
        setCanDeposit(IdUser, true)
    ; writeln("\nSaque negado. O cliente não possui um saldo de 200 reais ou mais."), sleep(1.5)
    ).


sacar500(IdUser) :-
    getCash(IdUser, Cash),
    (Cash >= 500 ->
        addCash(IdUser, -500),
        setCanDeposit(IdUser, true)
    ; writeln("\nSaque negado. O cliente não possui um saldo de 500 reais ou mais."), sleep(1.5)
    ).