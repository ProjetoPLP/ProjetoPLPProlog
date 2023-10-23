:- module(companyDownUpdate, [updateCompanyDown/2, removeCompanyFromExchange/1, isDown/1]).

:- use_module('./Models/Company/GetSetAttrsCompany.pl').
:- use_module('./Models/Client/GetSetAttrsClient.pl').
:- use_module('./Models/Client/PostClient.pl').
:- use_module('./Models/Company/SaveCompany.pl').
:- use_module('./Models/Clock/ClockUpdate.pl').
:- use_module('./Utils/UpdateUtils.pl').
:- use_module('./Menus/HomeBroker/HomeBrokerUpdate.pl').


updateCompanyDown(IdUser, IdComp) :-
    FilePath = "./Menus/HomeBroker/CompanyDown/companyDown.txt",
    resetMenu(FilePath, "./Sprites/HomeBroker/companyDown_base.txt"),
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