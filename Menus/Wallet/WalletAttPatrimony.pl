:- consult('../../Utils/MatrixUtils.pl').
:- consult('../../Utils/UpdateUtils.pl').
:- consult('../../Utils/GraphUtilsWallet.pl').
:- consult('../../Models/Client/GetSetAttrsClient.pl').
:- consult('../../Models/Company/GetSetAttrsCompany.pl').
:- consult('../../Models/Clock/ClockUpdate.pl').


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
    number_string(IdUser, IdUserString),
    string_concat("../Models/Client/Wallets/wallet", IdUserString, Filepath1),
    string_concat(Filepath1, ".txt", Filepath),
    getUserCol(IdUser, Col),
    getUserRow(IdUser, Row),

    attClientLineRow(IdUser, OldPatri, NewPatri),
    updateWLGraphCandle(Filepath, Row, Col).