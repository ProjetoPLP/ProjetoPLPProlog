:- consult('SaveCompany.pl').
:- consult('ModelCompany.pl').
:- consult('GetInfoForCreateCompany.pl').


cadastrarCompany(LimitCompanies, Success) :-
    (LimitCompanies < 12 ->
        getNewCompany(Company),
        saveCompanyJSON(Company),
        Success = true;
        Success = false
    ).


getNewCompany(Company) :-
    getName(CompanyName),
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