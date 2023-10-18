:- consult('SaveCompany.pl').
:- consult('ModelCompany.pl').

getCompName(JSONPath, ID, Name) :- 
    getCompany(JSONPath, ID, Company),
    Company = company(_, Name, _, _, _, _, _, _, _, _, _, _, _, _).

getAge(JSONPath, ID, Age) :- 
    getCompany(JSONPath, ID, Company),
    Company = company(_, _, Age, _, _, _, _, _, _, _, _, _, _, _).

getCNPJ(JSONPath, ID, CNPJ) :- 
    getCompany(JSONPath, ID, Company),
    Company = company(_, _, _, CNPJ, _, _, _, _, _, _, _, _, _, _).

getActuation(JSONPath, ID, Actuation) :- 
    getCompany(JSONPath, ID, Company),
    Company = company(_, _, _, _, Actuation, _, _, _, _, _, _, _, _, _).

getDeclaration(JSONPath, ID, Declaration) :- 
    getCompany(JSONPath, ID, Company),
    Company = company(_, _, _, _, _, Declaration, _, _, _, _, _, _, _, _).

getCode(JSONPath, ID, Code) :-
    getCompany(JSONPath, ID, Company),
    Company = company(_, _, _, _, _, _, Code, _, _, _, _, _, _, _).

getPrice(JSONPath, ID, Price) :-
    getCompany(JSONPath, ID, Company),
    Company = company(_, _, _, _, _, _, _, Price, _, _, _, _, _, _).

getTrendIndicator(JSONPath, ID, TrendIndicator) :-
    getCompany(JSONPath, ID, Company),
    Company = company(_, _, _, _, _, _, _, _, TrendIndicator, _, _, _, _, _).

getMinPrice(JSONPath, ID, MinPrice) :-
    getCompany(JSONPath, ID, Company),
    Company = company(_, _, _, _, _, _, _, _, _, MinPrice, _, _, _, _).

getMaxPrice(JSONPath, ID, MaxPrice) :-
    getCompany(JSONPath, ID, Company),
    Company = company(_, _, _, _, _, _, _, _, _, _, MaxPrice, _, _, _).

getStartPrice(JSONPath, ID, StartPrice) :-
    getCompany(JSONPath, ID, Company),
    Company = company(_, _, _, _, _, _, _, _, _, _, _, StartPrice, _, _).

getCompRow(JSONPath, ID, Row) :-
    getCompany(JSONPath, ID, Company),
    Company = company(_, _, _, _, _, _, _, _, _, _, _, _, Row, _).

getCompCol(JSONPath, ID, Col) :-
    getCompany(JSONPath, ID, Company),
    Company = company(_, _, _, _, _, _, _, _, _, _, _, _, _, Col).

getCompIdent(JSONPath, Company, Ident) :- 
    Company = company(Ident, _, _, _, _, _, _, _, _, _, _, _, _, _).

setPrice(JSONPath, ID, NewPrice):-
    getCompany(JSONPath, ID, Company),
    Company = company(Ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, MaxPrice, StartPrice, Row, Col),
    NewCompany = company(Ident, Name, Age, Cnpj, Actuation, Declaration, Code, NewPrice, TrendIndicator, MinPrice, MaxPrice, StartPrice, Row, Col),
    editCompanyJSON(JSONPath, NewCompany).

setTrendIndicator(JSONPath, ID, NewTrendIndicator):-
    getCompany(JSONPath, ID, Company),
    Company = company(Ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, MaxPrice, StartPrice, Row, Col),
    NewCompany = company(Ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, NewTrendIndicator, MinPrice, MaxPrice, StartPrice, Row, Col),
    editCompanyJSON(JSONPath, NewCompany).

setMinPrice(JSONPath, ID, NewMinPrice):-
    getCompany(JSONPath, ID, Company),
    Company = company(Ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, MaxPrice, StartPrice, Row, Col),
    NewCompany = company(Ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, NewMinPrice, MaxPrice, StartPrice, Row, Col),
    editCompanyJSON(JSONPath, NewCompany).

setMaxPrice(JSONPath, ID, NewMaxPrice):-
    getCompany(JSONPath, ID, Company),
    Company = company(Ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, MaxPrice, StartPrice, Row, Col),
    NewCompany = company(Ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, NewMaxPrice, StartPrice, Row, Col),
    editCompanyJSON(JSONPath, NewCompany).

setStartPrice(JSONPath, ID, NewStartPrice):-
    getCompany(JSONPath, ID, Company),
    Company = company(Ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, MaxPrice, StartPrice, Row, Col),
    NewCompany = company(Ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, MaxPrice, NewStartPrice, Row, Col),
    editCompanyJSON(JSONPath, NewCompany).

setCompRow(JSONPath, ID, NewRow):-
    getCompany(JSONPath, ID, Company),
    Company = company(Ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, MaxPrice, StartPrice, Row, Col),
    NewCompany = company(Ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, MaxPrice, StartPrice, NewRow, Col),
    editCompanyJSON(JSONPath, NewCompany).

setCompCol(JSONPath, ID, NewCol):-
    getCompany(JSONPath, ID, Company),
    Company = company(Ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, MaxPrice, StartPrice, Row, Col),
    NewCompany = company(Ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, MaxPrice, StartPrice, Row, NewCol),
    editCompanyJSON(JSONPath, NewCompany).

addCompRow(JSONPath, ID, AddRow):-
    getCompany(JSONPath, ID, Company),
    Company = company(Ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, MaxPrice, StartPrice, Row, Col),
    NewRow is Row + AddRow,
    NewCompany = company(Ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, MaxPrice, StartPrice, NewRow, Col),
    editCompanyJSON(JSONPath, NewCompany).

addCompCol(JSONPath, ID, AddCol):-
    getCompany(JSONPath, ID, Company),
    Company = company(Ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, MaxPrice, StartPrice, Row, Col),
    NewCol is Col + AddCol,
    NewCompany = company(Ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, MaxPrice, StartPrice, Row, NewCol),
    editCompanyJSON(JSONPath, NewCompany).