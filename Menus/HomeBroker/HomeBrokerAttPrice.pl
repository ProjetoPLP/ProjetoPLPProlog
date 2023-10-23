:- module(homeBrokerAttPrice, [getNewPrice/2, attCompanyTrendIndicator/3, getNewMaxPrice/3, getNewMinPrice/3, attAllCompanyPriceGraph/2]).

:- use_module('./Utils/UpdateUtils.pl').
:- use_module('./Models/Company/GetSetAttrsCompany.pl').
:- use_module('./Utils/GraphUtilsHomeBroker.pl').
:- use_module('./Utils/MatrixUtils.pl').
:- use_module('./Menus/HomeBroker/HomeBrokerUpdate.pl').
:- use_module('./Menus/HomeBroker/CompanyDown/CompanyDownUpdate.pl').
:- use_module(library(random)).


% Retorna um novo preço
getNewPrice(OldPrice, NewPrice) :-
    PossibleChanges = [-1.0, -0.9, -0.8, -0.7, -0.6, -0.5, -0.4, -0.3, -0.2, -0.1, 0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0],
    random_member(RandomChange, PossibleChanges),
    New is OldPrice + RandomChange,
    format(New, NewPrice).


% Atualiza em uma empresa, a partir do seu ID, o novo trendIndicator
attCompanyTrendIndicator(IdComp, OldPrice, NewPrice) :-
    (   NewPrice > OldPrice ->
        setTrendIndicator(IdComp, "▲")
    ;   NewPrice < OldPrice ->
        setTrendIndicator(IdComp, "▼")
    ;   setTrendIndicator(IdComp, " ")
    ).


% Retorna o novo preço máximo baseado no novo preço
getNewMaxPrice(IdComp, NewPrice, Result) :-
    getMaxPrice(IdComp, MaxPrice),
    (   MaxPrice >= NewPrice ->
        Result = MaxPrice
    ;   setMaxPrice(IdComp, NewPrice),
        Result = NewPrice
    ).


% Retorna o novo preço mínimo baseado no novo preço
getNewMinPrice(IdComp, NewPrice, Result) :-
    getMinPrice(IdComp, MinPrice),
    (   MinPrice =< NewPrice ->
        Result = MinPrice
    ;   setMinPrice(IdComp, NewPrice),
        Result = NewPrice
    ).


% Atualiza o preço e o gráfico de todas as empresas
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
    ), !.


% Atualiza o preço e o gráfico na empresa que está sendo exibida
attCurrentCompanyPriceGraph(IdComp) :-
    homeBrokerFilePath(IdComp, FilePath),
    attCompanyPriceGraph(IdComp),
    printMatrix(FilePath).


% Atualiza em uma empresa qualquer, a partir do seu ID, o preço e o gráfico
attCompanyPriceGraph(IdComp) :-
    homeBrokerFilePath(IdComp, FilePath),
    getPrice(IdComp, OldPrice),
    getNewPrice(OldPrice, NewPrice),
    getNewMaxPrice(IdComp, NewPrice, NewMaxPrice),
    getNewMinPrice(IdComp, NewPrice, NewMinPrice),
    getStartPrice(IdComp, StartPrice),

    attCompanyTrendIndicator(IdComp, OldPrice, NewPrice),
    getTrendIndicator(IdComp, TrendIndicator),

    attCompanyLineRow(IdComp, OldPrice, NewPrice),
    getCompRow(IdComp, Row),
    getCompCol(IdComp, Col),

    setPrice(IdComp, NewPrice),
    updateHBStockPrice(FilePath, NewPrice, TrendIndicator),
    updateHBStockMaxPrice(FilePath, NewMaxPrice),
    updateHBStockMinPrice(FilePath, NewMinPrice),
    updateHBStockStartPrice(FilePath, StartPrice),
    updateHBGraphCandle(FilePath, Row, Col).