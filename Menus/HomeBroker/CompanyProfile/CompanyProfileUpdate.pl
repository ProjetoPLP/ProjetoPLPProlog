:- consult('../../../Utils/MatrixUtils.pl').
:- consult('../../../Utils/UpdateUtils.pl').
:- consult('../../../Models/Client/GetSetAttrsClient.pl').
:- consult('../../../Models/Company/GetSetAttrsCompany.pl').


% Atualiza todas as informações de uma empresa em Company Description
updateCompanyProfile(IdUser, IdComp) :-
    resetMenu("./HomeBroker/CompanyProfile/companyProfile.txt", "../Sprites/HomeBroker/companyProfile_base.txt"),
    % updateMatrixClock
    getCash("../Data/Clients.json", IdUser, Cash),
    updateCPCash("./HomeBroker/CompanyProfile/companyProfile.txt", Cash),
    getCode("../Data/Companies.json", IdComp, Code),
    updateCPCompanyCode("./HomeBroker/CompanyProfile/companyProfile.txt",Code),
    getCompName("../Data/Companies.json", IdComp, Name),
    updateCPCompanyName("./HomeBroker/CompanyProfile/companyProfile.txt", Name),
    getActuation("../Data/Companies.json", IdComp, Actuation),
    updateCPCompanyActuation("./HomeBroker/CompanyProfile/companyProfile.txt", Actuation),
    getPrice("../Data/Companies.json", IdComp, Price), getTrendIndicator("../Data/Companies.json", IdComp, Trend),
    updateCPCompanyPrice("./HomeBroker/CompanyProfile/companyProfile.txt", Price, Trend),
    getDeclaration("../Data/Companies.json", IdComp, Declaration),
    updateCPCompanyDeclaration("./HomeBroker/CompanyProfile/companyProfile.txt", Declaration),
    getAge("../Data/Companies.json", IdComp, Age),
    updateCPCompanyAge("./HomeBroker/CompanyProfile/companyProfile.txt", Age),
    getCNPJ("../Data/Companies.json", IdComp, CNPJ),
    updateCPCompanyCNPJ("./HomeBroker/CompanyProfile/companyProfile.txt", CNPJ).


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