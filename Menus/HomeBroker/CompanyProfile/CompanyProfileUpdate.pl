:- consult('../../../Utils/MatrixUtils.pl').
:- consult('../../../Utils/UpdateUtils.pl').
:- consult('../../../Models/Client/GetSetAttrsClient.pl').
:- consult('../../../Models/Company/GetSetAttrsCompany.pl').
:- consult('../../../Models/Clock/ClockUpdate.pl').


% Atualiza todas as informações de uma empresa em Company Description
updateCompanyProfile(IdUser, IdComp) :-
    resetMenu("./HomeBroker/CompanyProfile/companyProfile.txt", "../Sprites/HomeBroker/companyProfile_base.txt"),
    getCash(IdUser, Cash),
    getCode(IdComp, Code),
    getCompName(IdComp, Name),
    getActuation(IdComp, Actuation),
    getPrice(IdComp, Price), getTrendIndicator(IdComp, Trend),
    getDeclaration(IdComp, Declaration),
    getAge(IdComp, Age),
    getCNPJ(IdComp, CNPJ),

    updateMatrixClock("./HomeBroker/CompanyProfile/companyProfile.txt"),
    updateCPCash("./HomeBroker/CompanyProfile/companyProfile.txt", Cash),
    updateCPCompanyCode("./HomeBroker/CompanyProfile/companyProfile.txt",Code),
    updateCPCompanyName("./HomeBroker/CompanyProfile/companyProfile.txt", Name),
    updateCPCompanyActuation("./HomeBroker/CompanyProfile/companyProfile.txt", Actuation),
    updateCPCompanyPrice("./HomeBroker/CompanyProfile/companyProfile.txt", Price, Trend),
    updateCPCompanyDeclaration("./HomeBroker/CompanyProfile/companyProfile.txt", Declaration),
    updateCPCompanyAge("./HomeBroker/CompanyProfile/companyProfile.txt", Age),
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