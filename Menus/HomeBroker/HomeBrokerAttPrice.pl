:- consult('../Utils/UpdateUtils.pl').
:- consult('../../Models/Company/GetSetAttrsCompany.pl').
:- consult('../../Utils/GraphUtilsHomeBroker.pl').
:- consult('../../Utils/MatrixUtils.pl').
:- consult('HomeBrokerUpdate.pl').
:- consult('CompanyDown/CompanyDownUpdate.pl').
:- use_module(library(random)).


getNewPrice(OldPrice, NewPrice) :-
    PossibleChanges = [-1.0, -0.9, -0.8, -0.7, -0.6, -0.5, -0.4, -0.3, -0.2, -0.1, 0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0],
    random_member(RandomChange, PossibleChanges),
    New is OldPrice + RandomChange,
    format(New, NewPrice).


attCompanyTrendIndicator(IdComp, OldPrice, NewPrice) :-
    (   NewPrice > OldPrice ->
        setTrendIndicator(IdComp, "▲")
    ;   NewPrice < OldPrice ->
        setTrendIndicator(IdComp, "▼")
    ;   setTrendIndicator(IdComp, " ")
    ).


getNewMaxPrice(IdComp, NewPrice, Result) :-
    getMaxPrice(IdComp, MaxPrice),
    (   MaxPrice >= NewPrice ->
        Result = MaxPrice
    ;   setMaxPrice(IdComp, NewPrice),
        Result = NewPrice
    ).


getNewMinPrice(IdComp, NewPrice, Result) :-
    getMinPrice(IdComp, MinPrice),
    (   MinPrice =< NewPrice ->
        Result = MinPrice
    ;   setMinPrice(IdComp, NewPrice),
        Result = NewPrice
    ).


attAllCompanyPriceGraph(_, []) :- !.
attAllCompanyPriceGraph(IdComp, [Company|RestCompanies]) :-
    getCompIdent(Company, CompanyId),
    (CompanyId =:= IdComp ->
        attCurrentCompanyPriceGraph(IdComp),
        attAllCompanyPriceGraph(IdComp, RestCompanies)
    ; isDown(CompanyId) ->
        removeCompanyFromExchange(CompanyId),
        attAllCompanyPriceGraph(IdComp, RestCompanies)
    ;
        attCompanyPriceGraph(CompanyId),
        attAllCompanyPriceGraph(IdComp, RestCompanies)
    ).



attCurrentCompanyPriceGraph(IdComp) :-
    number_string(IdComp, IDString),
    string_concat("../Models/Company/HomeBrokers/homebroker", IDString, TempPath),
    string_concat(TempPath, ".txt", FilePath),
    attCompanyPriceGraph(IdComp),
    printMatrix(FilePath).


attCompanyPriceGraph(IdComp) :-
    number_string(IdComp, IDString),
    string_concat("../Models/Company/HomeBrokers/homebroker", IDString, TempPath),
    string_concat(TempPath, ".txt", FilePath),
    getPrice(IdComp, OldPrice),
    getNewPrice(OldPrice, NewPrice),
    getNewMaxPrice(IdComp, NewPrice, NewMaxPrice),
    getNewMinPrice(IdComp, NewPrice, NewMinPrice),
    getTrendIndicator(IdComp, TrendIndicator),
    getStartPrice(IdComp, StartPrice),
    getCompRow(IdComp, Row),
    getCompCol(IdComp, Col),

    setPrice(IdComp, NewPrice),
    attCompanyTrendIndicator(IdComp, OldPrice, NewPrice),
    attCompanyLineRow(IdComp, OldPrice, NewPrice),
    updateHBStockPrice(FilePath, NewPrice, TredIndicator),
    updateHBStockMaxPrice(FilePath, NewMaxPrice),
    updateHBStockMinPrice(FilePath, NewMinPrice),
    updateHBStockStartPrice(FilePath, StartPrice),
    updateHBGraphCandle(FilePath, Row, Col).