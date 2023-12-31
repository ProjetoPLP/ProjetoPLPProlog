:- module(cadastrarCompany, [cadastrarCompany/2]).

:- use_module('./Models/Company/SaveCompany.pl').
:- use_module('./Models/Company/ModelCompany.pl').
:- use_module('./Models/Company/GetInfoForCreateCompany.pl').


cadastrarCompany(LimitCompanies, Success) :-
    (LimitCompanies < 12 ->
        getNewCompany(Company),
        saveCompanyJSON(Company),
        Success = true;
        Success = false
    ).


getNewCompany(Company) :-
    getCompanyName(CompanyName),
    getAgeFounded(CompanyAgeFounded),
    getCNPJ(CompanyCNPJ),
    getActuation(CompanyActuation),
    getDeclaration(CompanyDeclaration),
    getCode(CompanyCode),
    randomCompanyPrice(CompanyPrice),
    createCompany(10, CompanyName, CompanyAgeFounded, CompanyCNPJ, CompanyActuation, CompanyDeclaration, CompanyCode, CompanyPrice, " ", CompanyPrice, CompanyPrice, CompanyPrice, Company).


randomCompanyPrice(CompanyPrice) :-
    random_between(10, 30, RandomPrice),
    format(atom(CompanyPrice), '~1f', [RandomPrice]).