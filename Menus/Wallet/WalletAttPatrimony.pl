:- module(walletAttPatrimony, [attClientPatrimony/1, attAllClientsPatrimonyGraph/1]).

:- use_module('./Utils/UpdateUtils.pl').
:- use_module('./Utils/GraphUtilsWallet.pl').
:- use_module('./Models/Client/GetSetAttrsClient.pl').
:- use_module('./Models/Company/GetSetAttrsCompany.pl').


% Atualiza o patrimônio de um cliente
attClientPatrimony(IdUser) :-
    getAllAssets(IdUser, Assets),
    attClientPatrimonyAux(Assets, Patrimony),
    setPatrimony(IdUser, Patrimony).


attClientPatrimonyAux([], 0) :- !.
attClientPatrimonyAux([[IdComp, Qtd]|T], Patrimony) :-
    getPrice(IdComp, Price),
    Total0 is Price * Qtd,

    attClientPatrimonyAux(T, PatAux),
    Total is Total0 + PatAux,

    format(Total, Patrimony).


% Atualiza o gráfico da carteira de todos os clientes
attAllClientsPatrimonyGraph([]) :- !.
attAllClientsPatrimonyGraph([H|T]) :-
    getUserIdent(H, IdUser),
    getPatrimony(IdUser, OldPatrimony),
    getAllAssets(IdUser, Assets),
    attClientPatrimonyAux(Assets, NewPatrimony),

    attClientPatrimonyGraph(IdUser, OldPatrimony, NewPatrimony),
    attClientPatrimony(IdUser),
    attAllClientsPatrimonyGraph(T).


attClientPatrimonyGraph(IdUser, OldPatri, NewPatri) :-
    walletFilePath(IdUser, FilePath),
    attClientLineRow(IdUser, OldPatri, NewPatri),
    
    getUserCol(IdUser, Col),
    getUserRow(IdUser, Row),
    updateWLGraphCandle(FilePath, Row, Col).