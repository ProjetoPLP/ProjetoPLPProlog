:- consult('../../../Models/Client/GetSetAttrsClient.pl').

depositar(JSONPath, IdClient, CanDeposit) :-
    (CanDeposit = true ->
        addCash(JSONPath, IdClient, 100),
        setCanDeposit(JSONPath, IdClient, false)
    ; writeln("Depósito negado. O cliente não realizou um saque anteriormente.")
    ).


sacarTudo(JSONPath, IdClient) :-
    getCash(JSONPath, IdClient, Cash),
    (Cash >= 200 ->
        setCash(JSONPath, IdClient, 0),
        setCanDeposit(JSONPath, IdClient, true)
    ; writeln("Saque negado. O cliente não possui um saldo de 200 reais ou mais.")
    ).


sacar200(JSONPath, IdClient) :-
    getCash(JSONPath, IdClient, Cash),
    (Cash >= 200 ->
        addCash(JSONPath, IdClient, -200),
        setCanDeposit(JSONPath, IdClient, true)
    ; writeln("Saque negado. O cliente não possui um saldo de 200 reais ou mais.")
    ).


sacar500(JSONPath, IdClient) :-
    getCash(JSONPath, IdClient, Cash),
    (Cash >= 500 ->
        addCash(JSONPath, IdClient, -500),
        setCanDeposit(JSONPath, IdClient, true)
    ; writeln("Saque negado. O cliente não possui um saldo de 500 reais ou mais.")
    ).