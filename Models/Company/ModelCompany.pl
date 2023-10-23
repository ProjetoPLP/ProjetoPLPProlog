:- module(modelCompany, [createCompany/13]).


createCompany(Ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, MaxPrice, StartPrice, Company) :-
    Company = company(Ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, MaxPrice, StartPrice, 20, 3).