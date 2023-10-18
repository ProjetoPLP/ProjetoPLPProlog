:- consult('../../../Models/Client/GetSetAttrsClient.pl').
:- consult('../../../Models/Client/PostClient.pl').
:- consult('../../../Models/Company/GetSetAttrsCompany.pl').


buy(_, _, Num) :- Num =< 0, !.
buy(IdUser, IdComp, Num) :- 
    getCash("../Data/Clients.json", IdUser, Cash),
    getPrice("../Data/Companies.json", IdComp, Price),
    TotalPrice is Price * Num,
    (TotalPrice > Cash -> ! ; buyDeposit(IdUser, IdComp, TotalPrice, Num)).

buyDeposit(IdUser, IdComp, TotalPrice, Num) :-
    addCash("../Data/Clients.json", IdUser, -TotalPrice),
    addAsset("../Data/Clients.json", IdUser, IdComp, Num).


sell(_, _, Num) :- Num =< 0, !.
sell(IdUser, IdComp, Num) :-
    getCash("../Data/Clients.json", IdUser, Cash),
    getPrice("../Data/Companies.json", IdComp, Price),
    getQtdAssetsInCompany("../Data/Clients.json", IdUser, IdComp, Assets),
    TotalPrice is Price * Num,
    (Num > Assets -> ! ; sellDeposit(IdUser, IdComp, TotalPrice, Num)).

sellDeposit(IdUser, IdComp, TotalPrice, Num) :-
    addCash("../Data/Clients.json", IdUser, TotalPrice),
    addAsset("../Data/Clients.json", IdUser, IdComp, -Num).