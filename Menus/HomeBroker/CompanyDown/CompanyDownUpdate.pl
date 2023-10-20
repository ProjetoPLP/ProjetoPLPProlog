:- consult('../../../Models/Company/GetSetAttrsCompany.pl').
:- consult('../../../Models/Client/GetSetAttrsClient.pl').
:- consult('../../../Models/Client/PostClient.pl').
:- consult('../../../Models/Company/SaveCompany.pl').
:- consult('../../../Models/Clock/ClockUpdate.pl').
:- consult('../../../Utils/UpdateUtils.pl').
:- consult('../HomeBrokerUpdate.pl').


updateCompanyDown(IdUser, IdComp) :-
    FilePath = "./HomeBroker/CompanyDown/companyDown.txt",
    resetMenu(FilePath, "../Sprites/HomeBroker/companyDown_base.txt"),
    getCash(IdUser, Cash),
    getCompName(IdComp, Name),
    getCode(IdComp, Code),

    updateMatrixClock(FilePath),
    updateHBCash(FilePath, Cash),
    updateHBCompanyName(FilePath, Name),
    updateHBCompanyCode(FilePath, Code),
    removeCompanyFromExchange(IdComp).


removeCompanyFromExchange(IdComp) :-
    removeCompany(IdComp),
    removeAllClientsAsset(IdComp).


isDown(IdComp) :-
    getPrice(IdComp, Price),
    Price =< 0, !.