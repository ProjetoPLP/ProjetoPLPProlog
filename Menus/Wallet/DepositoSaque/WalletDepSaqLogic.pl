:- consult('../../../Models/Client/GetSetAttrsClient.pl').


depositar(IdClient, CanDeposit) :-
    (CanDeposit = true ->
        addCash(IdClient, 100),
        setCanDeposit(IdClient, false)
    ; writeln("Depósito negado. O cliente não realizou um saque anteriormente.")
    ).


sacarTudo(IdClient) :-
    getCash(IdClient, Cash),
    (Cash >= 200 ->
        setCash(IdClient, 0),
        setCanDeposit(IdClient, true)
    ; writeln("Saque negado. O cliente não possui um saldo de 200 reais ou mais.")
    ).


sacar200(IdClient) :-
    getCash(IdClient, Cash),
    (Cash >= 200 ->
        addCash(IdClient, -200),
        setCanDeposit(IdClient, true)
    ; writeln("Saque negado. O cliente não possui um saldo de 200 reais ou mais.")
    ).


sacar500(IdClient) :-
    getCash(IdClient, Cash),
    (Cash >= 500 ->
        addCash(IdClient, -500),
        setCanDeposit(IdClient, true)
    ; writeln("Saque negado. O cliente não possui um saldo de 500 reais ou mais.")
    ).