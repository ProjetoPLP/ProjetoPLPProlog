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


attCompanyTrendIndicator(JSONPath, IdComp, OldPrice, NewPrice) :-
    (   NewPrice > OldPrice ->
        setTrendIndicator(JSONPath, IdComp, "▲")
    ;   NewPrice < OldPrice ->
        setTrendIndicator(JSONPath, IdComp, "▼")
    ;   setTrendIndicator(JSONPath, IdComp, " ")
    ).


getNewMaxPrice(JSONPath, IdComp, NewPrice, Result) :-
    getMaxPrice(JSONPath, IdComp, MaxPrice),
    (   MaxPrice >= NewPrice ->
        Result = MaxPrice
    ;   setMaxPrice(JSONPath, IdComp, NewPrice),
        Result = NewPrice
    ).


getNewMinPrice(JSONPath, IdComp, NewPrice, Result) :-
    getMinPrice(JSONPath, IdComp, MinPrice),
    (   MinPrice =< NewPrice ->
        Result = MinPrice
    ;   setMinPrice(JSONPath, IdComp, NewPrice),
        Result = NewPrice
    ).


attAllCompanyPriceGraph(_, []) :- !.
attAllCompanyPriceGraph(JSONPath, IdComp, [Company|RestCompanies]) :-
    getCompIdent(JSONPath, Company, CompanyId),
    (CompanyId =:= IdComp ->
        attCurrentCompanyPriceGraph(JSONPath, IdComp),
        attAllCompanyPriceGraph(JSONPath, IdComp, RestCompanies)
    ; isDown(JSONPath, CompanyId) ->
        removeCompanyFromExchange(JSONPath, CompanyId),
        attAllCompanyPriceGraph(IdComp, RestCompanies)
    ;
        attCompanyPriceGraph(JSONPath, CompanyId),
        attAllCompanyPriceGraph(JSONPath, IdComp, RestCompanies)
    ).



attCurrentCompanyPriceGraph(JSONPath, IdComp) :-
    number_string(IdComp, IDString),
    string_concat("../Models/Company/HomeBrokers/homebroker", IDString, TempPath),
    string_concat(TempPath, ".txt", FilePath),
    attCompanyPriceGraph(JSONPath, IdComp),
    printMatrix(FilePath).


attCompanyPriceGraph(JSONPath, IdComp) :-
    number_string(IdComp, IDString),
    string_concat("../Models/Company/HomeBrokers/homebroker", IDString, TempPath),
    string_concat(TempPath, ".txt", FilePath),
    getPrice(JSONPath, IdComp, OldPrice),
    getNewPrice(OldPrice, NewPrice),
    getNewMaxPrice(JSONPath, IdComp, NewPrice, NewMaxPrice),
    getNewMinPrice(JSONPath, IdComp, NewPrice, NewMinPrice),
    getTrendIndicator(JSONPath, IdComp, TrendIndicator),
    getStartPrice(JSONPath, IdComp, StartPrice),
    getCompRow(JSONPath, IdComp, Row),
    getCompCol(JSONPath, IdComp, Col),

    setPrice(JSONPath, IdComp, NewPrice),
    attCompanyTrendIndicator(JSONPath, IdComp, OldPrice, NewPrice),
    attCompanyLineRow(JSONPath, IdComp, OldPrice, NewPrice),
    updateHBStockPrice(FilePath, NewPrice, TredIndicator),
    updateHBStockMaxPrice(FilePath, NewMaxPrice),
    updateHBStockMinPrice(FilePath, NewMinPrice),
    updateHBStockStartPrice(FilePath, StartPrice),
    updateHBGraphCandle(FilePath, Row, Col).

