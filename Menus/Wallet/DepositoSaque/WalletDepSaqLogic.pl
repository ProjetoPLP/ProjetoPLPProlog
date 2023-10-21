:- consult('../../../Models/Client/GetSetAttrsClient.pl').


depositar(IdUser, CanDeposit) :-
    (CanDeposit = true ->
        addCash(IdUser, 100),
        setCanDeposit(IdUser, false)
    ; writeln("Depósito negado. O cliente não realizou um saque anteriormente.")
    ).


sacarTudo(IdUser) :-
    getCash(IdUser, Cash),
    (Cash >= 200 ->
        setCash(IdUser, 0),
        setCanDeposit(IdUser, true)
    ; writeln("Saque negado. O cliente não possui um saldo de 200 reais ou mais.")
    ).


sacar200(IdUser) :-
    getCash(IdUser, Cash),
    (Cash >= 200 ->
        addCash(IdUser, -200),
        setCanDeposit(IdUser, true)
    ; writeln("Saque negado. O cliente não possui um saldo de 200 reais ou mais.")
    ).


sacar500(IdUser) :-
    getCash(IdUser, Cash),
    (Cash >= 500 ->
        addCash(IdUser, -500),
        setCanDeposit(IdUser, true)
    ; writeln("Saque negado. O cliente não possui um saldo de 500 reais ou mais.")
    ).