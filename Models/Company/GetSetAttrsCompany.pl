:- consult('../../Utils/UpdateUtils.pl').
:- consult('./SaveCompany.pl').
:- consult('./ModelCompany.pl').


getCompName(ID, Name) :- 
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

getCompRow(ID, Row) :-
    getCompany(ID, Company),
    Company = company(_, _, _, _, _, _, _, _, _, _, _, _, Row, _).

getCompCol(ID, Col) :-
    getCompany(ID, Company),
    Company = company(_, _, _, _, _, _, _, _, _, _, _, _, _, Col).

getCompIdent(Company, Ident) :- 
    Company = company(Ident, _, _, _, _, _, _, _, _, _, _, _, _, _).

setPrice(ID, NewPrice):-
    format(NewPrice, FormattedPrice),
    getCompany(ID, Company),
    Company = company(Ident, Name, Age, Cnpj, Actuation, Declaration, Code, _, TrendIndicator, MinPrice, MaxPrice, StartPrice, Row, Col),
    NewCompany = company(Ident, Name, Age, Cnpj, Actuation, Declaration, Code, FormattedPrice, TrendIndicator, MinPrice, MaxPrice, StartPrice, Row, Col),
    editCompanyJSON(NewCompany).

setTrendIndicator(ID, NewTrendIndicator):-
    getCompany(ID, Company),
    Company = company(Ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, _, MinPrice, MaxPrice, StartPrice, Row, Col),
    NewCompany = company(Ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, NewTrendIndicator, MinPrice, MaxPrice, StartPrice, Row, Col),
    editCompanyJSON(NewCompany).

setMinPrice(ID, NewMinPrice):-
    format(NewMinPrice, FormattedMinPrice),
    getCompany(ID, Company),
    Company = company(Ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, _, MaxPrice, StartPrice, Row, Col),
    NewCompany = company(Ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, FormattedMinPrice, MaxPrice, StartPrice, Row, Col),
    editCompanyJSON(NewCompany).

setMaxPrice(ID, NewMaxPrice):-
    format(NewMaxPrice, FormattedMaxPrice),
    getCompany(ID, Company),
    Company = company(Ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, _, StartPrice, Row, Col),
    NewCompany = company(Ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, FormattedMaxPrice, StartPrice, Row, Col),
    editCompanyJSON(NewCompany).

setStartPrice(ID, NewStartPrice):-
    format(NewStartPrice, FormattedStartPrice),
    getCompany(ID, Company),
    Company = company(Ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, MaxPrice, _, Row, Col),
    NewCompany = company(Ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, MaxPrice, FormattedStartPrice, Row, Col),
    editCompanyJSON(NewCompany).

setCompRow(ID, NewRow):-
    getCompany(ID, Company),
    Company = company(Ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, MaxPrice, StartPrice, _, Col),
    NewCompany = company(Ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, MaxPrice, StartPrice, NewRow, Col),
    editCompanyJSON(NewCompany).

setCompCol(ID, NewCol):-
    getCompany(ID, Company),
    Company = company(Ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, MaxPrice, StartPrice, Row, _),
    NewCompany = company(Ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, MaxPrice, StartPrice, Row, NewCol),
    editCompanyJSON(NewCompany).

addCompRow(ID, AddRow):-
    getCompany(ID, Company),
    Company = company(Ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, MaxPrice, StartPrice, Row, Col),
    NewRow is Row + AddRow,
    NewCompany = company(Ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, MaxPrice, StartPrice, NewRow, Col),
    editCompanyJSON(NewCompany).

addCompCol(ID, AddCol):-
    getCompany(ID, Company),
    Company = company(Ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, MaxPrice, StartPrice, Row, Col),
    NewCol is Col + AddCol,
    NewCompany = company(Ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, MaxPrice, StartPrice, Row, NewCol),
    editCompanyJSON(NewCompany).