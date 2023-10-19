:- consult('../../../Models/Company/GetSetAttrsCompany.pl').
:- consult('../../../Models/Client/GetSetAttrsClient.pl').
:- consult('../../../Models/Client/PostClient.pl').
:- consult('../../../Models/Company/SaveCompany.pl').
:- consult('../../../Models/Clock/ClockUpdate.pl').
:- consult('../../../Utils/Company/UpdateUtils.pl').
:- consult('../HomeBrokerUpdate.pl').


updateCompanyDown(IdUser, IdComp) :-
    resetMenu("./HomeBroker/CompanyDown/companyDown.txt", "../Sprites/HomeBroker/companyDown_base.txt"),
    getCash(IdUser, Cash),
    getCompName(IdComp, Name),
    getCode(IdComp, Code),

    updateMatrixClock("./HomeBroker/CompanyDown/companyDown.txt"),
    updateHBCash("./HomeBroker/CompanyDown/companyDown.txt", Cash),
    updateHBCompanyName("./HomeBroker/CompanyDown/companyDown.txt", Name),
    updateHBCompanyCode("./HomeBroker/CompanyDown/companyDown.txt", Code),
    removeCompanyFromExchange(IdComp).


removeCompanyFromExchange(IdComp) :-
    removeCompany(IdComp),
    removeAllClientsAsset(IdComp).


isDown(IdComp) :-
    getPrice(IdComp, Price),
    Price =< 0, !.