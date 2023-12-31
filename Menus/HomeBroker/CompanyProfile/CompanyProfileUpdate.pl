:- module(companyProfileUpdate, [updateCompanyProfile/2]).

:- use_module('./Utils/MatrixUtils.pl').
:- use_module('./Utils/UpdateUtils.pl').
:- use_module('./Models/Client/GetSetAttrsClient.pl').
:- use_module('./Models/Company/GetSetAttrsCompany.pl').
:- use_module('./Models/Clock/ClockUpdate.pl').


% Atualiza todas as informações de uma empresa em Company Description
updateCompanyProfile(IdUser, IdComp) :-
    FilePath = "./Menus/HomeBroker/CompanyProfile/companyProfile.txt",
    resetMenu(FilePath, "./Sprites/HomeBroker/companyProfile_base.txt"),
    getCash(IdUser, Cash),
    getCode(IdComp, Code),
    getCompName(IdComp, Name),
    getActuation(IdComp, Actuation),
    getPrice(IdComp, Price), getTrendIndicator(IdComp, Trend),
    getDeclaration(IdComp, Declaration),
    getAge(IdComp, Age),
    getCNPJ(IdComp, CNPJ),

    updateMatrixClock(FilePath),
    updateCPCash(FilePath, Cash),
    updateCPCompanyCode(FilePath,Code),
    updateCPCompanyName(FilePath, Name),
    updateCPCompanyActuation(FilePath, Actuation),
    updateCPCompanyPrice(FilePath, Price, Trend),
    updateCPCompanyDeclaration(FilePath, Declaration),
    updateCPCompanyAge(FilePath, Age),
    updateCPCompanyCNPJ(FilePath, CNPJ).


updateCPCash(FilePath, Cash) :-
    string_concat(Cash, "0", Temp),
    fillLeft(Temp, 9, StringR),
    string_length(StringR, Len),
    writeMatrixValue(FilePath, StringR, 3, (75 - Len)).


updateCPCompanyCode(FilePath, Code) :-
    writeMatrixValue(FilePath, Code, 9, 6).


updateCPCompanyName(FilePath, Name) :-
    writeMatrixValue(FilePath, Name, 9, 14).


updateCPCompanyActuation(FilePath, Actuation) :-
    writeMatrixValue(FilePath, Actuation, 9, 46).


updateCPCompanyPrice(FilePath, Price, TrendInd) :-
    string_concat(TrendInd, Price, Temp1),
    string_concat(Temp1, "0", Temp2),
    fillLeft(Temp2, 7, StringR),
    string_length(StringR, Len),
    writeMatrixValue(FilePath, StringR, 9, (93 - Len)).


updateCPCompanyDeclaration(FilePath, Declaration) :-
    writeMatrixValue(FilePath, Declaration, 17, 8).


updateCPCompanyAge(FilePath, Age) :-
    writeMatrixValue(FilePath, Age, 20, 23).


updateCPCompanyCNPJ(FilePath, CNPJ) :-
    writeMatrixValue(FilePath, CNPJ, 23, 12).