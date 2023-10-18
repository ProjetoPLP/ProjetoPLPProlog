:- consult('../../../Models/Company/GetSetAttrsCompany.pl').
:- consult('../../../Models/Client/GetSetAttrsClient.pl').
:- consult('../../../Models/Company/SaveCompany.pl').
:- consult('../../../Utils/Company/UpdateUtils.pl').
:- consult('../HomeBrokerUpdate.pl').


updateCompanyDown(JSONPathCom, JSONPathUser, IdUser, IdComp) :-
    getCash(JSONPathUser, IdUser, Cash),
    getCompName(JSONPathCom, IdComp, Name),
    getCode(JSONPathCom, IdComp, Code),

    resetMenu("HomeBroker/CompanyDown/companyDown.txt", "../Sprites/HomeBroker/companyDown_base.txt"),
    %updateMatrixClock("HomeBroker/CompanyDown/companyDown.txt")
    updateHBCash("HomeBroker/CompanyDown/companyDown.txt", Cash),
    updateHBCompanyName("HomeBroker/CompanyDown/companyDown.txt", Name),
    updateHBCompanyCode("HomeBroker/CompanyDown/companyDown.txt", Code),
    removeCompanyFromExchange(JSONPathCom, IdComp).


removeCompanyFromExchange(JSONPath, IdComp) :-
    removeCompany(JSONPath, IdComp).
    %removeAllClientAsset(JSONPath, IdComp).

isDown(JSONPath, IdComp) :-
    getPrice(JSONPath, IdComp, Price),
    Price =< 0.