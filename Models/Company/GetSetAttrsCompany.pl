:- consult('SaveCompany.pl').
:- consult('ModelCompany.pl').

getName(ID, Name) :- 
    getCompany(ID, Company),
    Company = company(_, Name, _, _, _, _, _, _, _, _, _, _, _, _).

getAge(ID, Age) :- 
    getCompany(ID, Company),
    Company = company(_, _, Age, _, _, _, _, _, _, _, _, _, _, _).

getCNPJ(ID, CNPJ) :- 
    getCompany(ID, Company),
    Company = company(_, _, _, CNPJ, _, _, _, _, _, _, _, _, _, _).

getActuation(ID, Actuation) :- 
    getCompany(ID, Company),
    Company = company(_, _, _, _, Actuation, _, _, _, _, _, _, _, _, _).

getDeclaration(ID, Declaration) :- 
    getCompany(ID, Company),
    Company = company(_, _, _, _, _, Declaration, _, _, _, _, _, _, _, _).

getCode(ID, Code) :-
    getCompany(ID, Company),
    Company = company(_, _, _, _, _, _, Code, _, _, _, _, _, _, _).

getPrice(ID, Price) :-
    getCompany(ID, Company),
    Company = company(_, _, _, _, _, _, _, Price, _, _, _, _, _, _).

getTrendIndicator(ID, TrendIndicator) :-
    getCompany(ID, Company),
    Company = company(_, _, _, _, _, _, _, _, TrendIndicator, _, _, _, _, _).

getMinPrice(ID, MinPrice) :-
    getCompany(ID, Company),
    Company = company(_, _, _, _, _, _, _, _, _, MinPrice, _, _, _, _).

getMaxPrice(ID, MaxPrice) :-
    getCompany(ID, Company),
    Company = company(_, _, _, _, _, _, _, _, _, _, MaxPrice, _, _, _).

getStartPrice(ID, StartPrice) :-
    getCompany(ID, Company),
    Company = company(_, _, _, _, _, _, _, _, _, _, _, StartPrice, _, _).

getRow(ID, Row) :-
    getCompany(ID, Company),
    Company = company(_, _, _, _, _, _, _, _, _, _, _, _, Row, _).

getCol(ID, Col) :-
    getCompany(ID, Company),
    Company = company(_, _, _, _, _, _, _, _, _, _, _, _, _, Col).

getIdent(Company, Ident) :- 
    Company = company(Ident, _, _, _, _, _, _, _, _, _, _, _, _, _).

setPrice(ID, NewPrice):-
    getCompany(ID, Company),
    Company = company(Ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, MaxPrice, StartPrice, Row, Col),
    NewCompany = company(Ident, Name, Age, Cnpj, Actuation, Declaration, Code, NewPrice, TrendIndicator, MinPrice, MaxPrice, StartPrice, Row, Col),
    editCompanyJSON(NewCompany).

setTrendIndicator(ID, NewTrendIndicator):-
    getCompany(ID, Company),
    Company = company(Ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, MaxPrice, StartPrice, Row, Col),
    NewCompany = company(Ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, NewTrendIndicator, MinPrice, MaxPrice, StartPrice, Row, Col),
    editCompanyJSON(NewCompany).

setMinPrice(ID, NewMinPrice):-
    getCompany(ID, Company),
    Company = company(Ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, MaxPrice, StartPrice, Row, Col),
    NewCompany = company(Ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, NewMinPrice, MaxPrice, StartPrice, Row, Col),
    editCompanyJSON(NewCompany).

setMaxPrice(ID, NewMaxPrice):-
    getCompany(ID, Company),
    Company = company(Ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, MaxPrice, StartPrice, Row, Col),
    NewCompany = company(Ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, NewMaxPrice, StartPrice, Row, Col),
    editCompanyJSON(NewCompany).

setStartPrice(ID, NewStartPrice):-
    getCompany(ID, Company),
    Company = company(Ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, MaxPrice, StartPrice, Row, Col),
    NewCompany = company(Ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, MaxPrice, NewStartPrice, Row, Col),
    editCompanyJSON(NewCompany).

setRow(ID, NewRow):-
    getCompany(ID, Company),
    Company = company(Ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, MaxPrice, StartPrice, Row, Col),
    NewCompany = company(Ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, MaxPrice, StartPrice, NewRow, Col),
    editCompanyJSON(NewCompany).

setCol(ID, NewCol):-
    getCompany(ID, Company),
    Company = company(Ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, MaxPrice, StartPrice, Row, Col),
    NewCompany = company(Ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, MaxPrice, StartPrice, Row, NewCol),
    editCompanyJSON(NewCompany).

addRow(ID, AddRow):-
    getCompany(ID, Company),
    Company = company(Ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, MaxPrice, StartPrice, Row, Col),
    NewRow is Row + AddRow,
    NewCompany = company(Ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, MaxPrice, StartPrice, NewRow, Col),
    editCompanyJSON(NewCompany).

addCol(ID, AddCol):-
    getCompany(ID, Company),
    Company = company(Ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, MaxPrice, StartPrice, Row, Col),
    NewCol is Col + AddCol,
    NewCompany = company(Ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, MaxPrice, StartPrice, Row, NewCol),
    editCompanyJSON(NewCompany).
