:- consult('LoginClient.pl').
:- consult('SaveClient.pl').

getLoggedUserID(ID) :- 
    getLoggedClient(Client),
    Client = client(ID, _, _, _, _, _, _, _, _, _, _, _).

getName(ID, Name) :- 
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

getRow(ID, Row) :- 
    getClient(ID, Client),
    Client = client(_, _, _, _, _, _, _, _, _, Row, _, _).

getCol(ID, Col) :- 
    getClient(ID, Client),
    Client = client(_, _, _, _, _, _, _, _, _, _, Col, _).

getAllAssets(ID, AllAssets) :- 
    getClient(ID, Client),
    Client = client(_, _, _, _, _, _, _, _, _, _, _, AllAssets).

getQtdAssetsInCompany(ID, IDCompany, Acoes) :- 
    getClient(ID, Client),
    Client = client(_, _, _, _, _, _, _, _, _, _, _, AllAssets),
    searchAcoes(AllAssets, IDCompany,  Acoes).
    
setCash(ID, NewCash, Result) :- 
    getClient(ID, Client),
    Client = client(Ident, Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, Row, Col, AllAssets),
    NewClient = client(Ident, Name, Age, Cpf, Email, Password, NewCash, Patrimony, CanDeposit, Row, Col, AllAssets),
    editClientJSON(NewClient),
    Result = true.

setPatrimony(ID, NewPatrimony, Result) :- 
    getClient(ID, Client),
    Client = client(Ident, Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, Row, Col, AllAssets),
    NewClient = client(Ident, Name, Age, Cpf, Email, Password, Cash, NewPatrimony, CanDeposit, Row, Col, AllAssets),
    editClientJSON(NewClient),
    Result = true.

setCanDeposit(ID, NewCanDeposit, Result) :- 
    getClient(ID, Client),
    Client = client(Ident, Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, Row, Col, AllAssets),
    NewClient = client(Ident, Name, Age, Cpf, Email, Password, Cash, Patrimony, NewCanDeposit, Row, Col, AllAssets),
    editClientJSON(NewClient),
    Result = true.

setAllAssets(ID, NewAllAssets, Result) :- 
    getClient(ID, Client),
    Client = client(Ident, Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, Row, Col, AllAssets),
    NewClient = client(Ident, Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, Row, Col, NewAllAssets),
    editClientJSON(NewClient),
    Result = true.

setRow(ID, NewRow, Result) :- 
    getClient(ID, Client),
    Client = client(Ident, Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, Row, Col, AllAssets),
    NewClient = client(Ident, Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, NewRow, Col, AllAssets),
    editClientJSON(NewClient),
    Result = true.
    
setCol(ID, NewCol, Result) :- 
    getClient(ID, Client),
    Client = client(Ident, Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, Row, Col, AllAssets),
    NewClient = client(Ident, Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, Row, NewCol, AllAssets),
    editClientJSON(NewClient),
    Result = true.

addCash(ID, AddCash, Result) :- 
    getClient(ID, Client),
    Client = client(Ident, Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, Row, Col, AllAssets),
    NewCash is (Cash + AddCash),
    NewClient = client(Ident, Name, Age, Cpf, Email, Password, NewCash, Patrimony, CanDeposit, Row, Col, AllAssets),
    editClientJSON(NewClient),
    Result = true.

addRow(ID, AddRow, Result) :- 
    getClient(ID, Client),
    Client = client(Ident, Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, Row, Col, AllAssets),
    NewRow is (Row + AddRow),
    NewClient = client(Ident, Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, NewRow, Col, AllAssets),
    editClientJSON(NewClient),
    Result = true.

addCol(ID, AddCol, Result) :- 
    getClient(ID, Client),
    Client = client(Ident, Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, Row, Col, AllAssets),
    NewCol is (Col + AddCol),
    NewClient = client(Ident, Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, Row, NewCol, AllAssets),
    editClientJSON(NewClient),
    Result = true.

searchAcoes(AllAssets, IDCompany, Acoes) :-
    buscarAcoes(AllAssets, IDCompany, Acoes).
buscarAcoes([], _, 0).
buscarAcoes([[IDCompany, Acoes]|_], IDCompany, Acoes).
buscarAcoes([_|Rest], IDCompany, Acoes) :-
    buscarAcoes(Rest, IDCompany, Acoes).
