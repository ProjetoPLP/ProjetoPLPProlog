:- consult('LoginClient.pl').
:- consult('SaveClient.pl').

getLoggedUserID(ID) :- 
    getLoggedClient(Client),
    Client = client(ID, _, _, _, _, _, _, _, _, _, _, _).

getUserName(ID, Name) :- 
    getClient(ID, Client),
    Client = client(_, Name, _, _, _, _, _, _, _, _, _, _).

getCPF(ID, CPF) :-
    getClient(ID, Client),
    Client = client(_, _, _, CPF, _, _, _, _, _, _, _, _).

getCash(ID, Cash) :- 
    getClient(ID, Client),
    Client = client(_, _, _, _, _, _, Cash, _, _, _, _, _).

getPatrimony(ID, Patrimony) :- 
    getClient(ID, Client),
    Client = client(_, _, _, _, _, _, _, Patrimony, _, _, _, _).

getCanDeposit(ID, CanDeposit) :-
    getClient(ID, Client),
    Client = client(_, _, _, _, _, _, _, _, CanDeposit, _, _, _).

getUserRow(ID, Row) :- 
    getClient(ID, Client),
    Client = client(_, _, _, _, _, _, _, _, _, Row, _, _).

getUserCol(ID, Col) :- 
    getClient(ID, Client),
    Client = client(_, _, _, _, _, _, _, _, _, _, Col, _).

getUserIdent(Client, Ident) :-
    Client = client(Ident, _, _, _, _, _, _, _, _, _, _, _).

getAllAssets(ID, AllAssets) :- 
    getClient(ID, Client),
    Client = client(_, _, _, _, _, _, _, _, _, _, _, AllAssets).

getQtdAssetsInCompany(ID, IDCompany, Acoes) :- 
    getClient(ID, Client),
    Client = client(_, _, _, _, _, _, _, _, _, _, _, AllAssets),
    searchAcoes(AllAssets, IDCompany,  Acoes).
    
setCash(ID, NewCash) :- 
    getClient(ID, Client),
    Client = client(Ident, Name, Age, Cpf, Email, Password, _, Patrimony, CanDeposit, Row, Col, AllAssets),
    NewClient = client(Ident, Name, Age, Cpf, Email, Password, NewCash, Patrimony, CanDeposit, Row, Col, AllAssets),
    editClientJSON(NewClient).

setPatrimony(ID, NewPatrimony) :- 
    getClient(ID, Client),
    Client = client(Ident, Name, Age, Cpf, Email, Password, Cash, _, CanDeposit, Row, Col, AllAssets),
    NewClient = client(Ident, Name, Age, Cpf, Email, Password, Cash, NewPatrimony, CanDeposit, Row, Col, AllAssets),
    editClientJSON(NewClient).

setCanDeposit(ID, NewCanDeposit) :- 
    getClient(ID, Client),
    Client = client(Ident, Name, Age, Cpf, Email, Password, Cash, Patrimony, _, Row, Col, AllAssets),
    NewClient = client(Ident, Name, Age, Cpf, Email, Password, Cash, Patrimony, NewCanDeposit, Row, Col, AllAssets),
    editClientJSON(NewClient).

setAllAssets(ID, NewAllAssets) :- 
    getClient(ID, Client),
    Client = client(Ident, Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, Row, Col, _),
    NewClient = client(Ident, Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, Row, Col, NewAllAssets),
    editClientJSON(NewClient).

setUserRow(ID, NewRow) :- 
    getClient(ID, Client),
    Client = client(Ident, Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, _, Col, AllAssets),
    NewClient = client(Ident, Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, NewRow, Col, AllAssets),
    editClientJSON(NewClient).
    
setUserCol(ID, NewCol) :- 
    getClient(ID, Client),
    Client = client(Ident, Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, Row, _, AllAssets),
    NewClient = client(Ident, Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, Row, NewCol, AllAssets),
    editClientJSON(NewClient).

addCash(ID, AddCash) :- 
    getClient(ID, Client),
    Client = client(Ident, Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, Row, Col, AllAssets),
    NewCash is (Cash + AddCash),
    NewClient = client(Ident, Name, Age, Cpf, Email, Password, NewCash, Patrimony, CanDeposit, Row, Col, AllAssets),
    editClientJSON(NewClient).

addUserRow(ID, AddRow) :- 
    getClient(ID, Client),
    Client = client(Ident, Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, Row, Col, AllAssets),
    NewRow is (Row + AddRow),
    NewClient = client(Ident, Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, NewRow, Col, AllAssets),
    editClientJSON(NewClient).

addUserCol(ID, AddCol) :- 
    getClient(ID, Client),
    Client = client(Ident, Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, Row, Col, AllAssets),
    NewCol is (Col + AddCol),
    NewClient = client(Ident, Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, Row, NewCol, AllAssets),
    editClientJSON(NewClient).

searchAcoes(AllAssets, IDCompany, Acoes) :-
    buscarAcoes(AllAssets, IDCompany, Acoes).
    buscarAcoes([], _, 0).
    buscarAcoes([[IDCompany, Acoes]|_], IDCompany, Acoes).
    buscarAcoes([_|Rest], IDCompany, Acoes) :-
    buscarAcoes(Rest, IDCompany, Acoes).