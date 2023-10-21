:- consult('../../../Utils/MatrixUtils.pl').
:- consult('../../../Utils/UpdateUtils.pl').
:- consult('../../../Models/Client/GetSetAttrsClient.pl').
:- consult('../../../Models/Company/GetSetAttrsCompany.pl').
:- consult('../../../Models/Company/SaveCompany.pl').
:- consult('../../../Models/Clock/ClockUpdate.pl').


% Atualiza todas as informações no menu de fechamento do pregão
updateTrendingClose(IdUser) :-
    FilePath = "./Menus/HomeBroker/TrendingClose/trendingClose.txt",
    resetMenu(FilePath, "./Sprites/HomeBroker/trendingClose_base.txt"),
    getCash(IdUser, Cash),
    getPatrimony(IdUser, Patrimony),
    getCompanyJSON(Comps),

    updateMatrixClock(FilePath),
    updateTCCash(FilePath, Cash),
    updateTCPatrimony(FilePath, Patrimony),
    updateAllTCCompanyCode(FilePath, Comps),
    updateAllTCCompanyVar(FilePath, Comps),
    updateAllCompaniesStartMaxMinPrice(Comps).


updateTCCash(FilePath, Cash) :-
    string_concat(Cash, "0", Temp),
    fillLeft(Temp, 9, StringR),
    string_length(StringR, Len),
    writeMatrixValue(FilePath, StringR, 3, (75 - Len)).


updateTCPatrimony(FilePath, Patrimony) :-
    string_concat(Patrimony, "0", Temp),
    fillLeft(Temp, 9, StringR),
    string_length(StringR, Len),
    writeMatrixValue(FilePath, StringR, 3, (40 - Len)).


updateAllTCCompanyCode(_, []) :- !.
updateAllTCCompanyCode(FilePath, [H|T]) :-
    getCompIdent(H, IdComp),
    updateTCCompanyCode(FilePath, IdComp),
    updateAllTCCompanyCode(FilePath, T).


updateTCCompanyCode(FilePath, IdComp) :-
    getTCCompanyCodePosition(IdComp, [Row|Col]),
    getCode(IdComp, Code),
    writeMatrixValue(FilePath, Code, Row, Col).


updateAllTCCompanyVar(_, []) :- !.
updateAllTCCompanyVar(FilePath, [H|T]) :-
    getCompIdent(H, IdComp),
    updateTCCompanyVar(FilePath, IdComp),
    updateAllTCCompanyVar(FilePath, T).


updateTCCompanyVar(FilePath, IdComp) :-
    getTCCompanyVarPosition(IdComp, [Row|Col]),
    getVar(IdComp, Temp),
    fillLeft(Temp, 8, Var),
    string_length(Var, Len),
    writeMatrixValue(FilePath, Var, Row, Col - Len).


updateAllCompaniesStartMaxMinPrice([]).
updateAllCompaniesStartMaxMinPrice([H|T]) :-
    getCompIdent(H, IdComp),
    getPrice(IdComp, Price),
    setStartPrice(IdComp, Price),
    setMaxPrice(IdComp, Price),
    setMinPrice(IdComp, Price),
    updateAllCompaniesStartMaxMinPrice(T).


getVar(IdComp, R) :-
    getPrice(IdComp, Price),
    getStartPrice(IdComp, StartPrice),
    Var is ((Price - StartPrice) / StartPrice) * 100,
    formatVar(Var, R).

formatVar(Var, R) :-
    Var > 0,
    format(Var, VarF),
    string_concat("▲", VarF, Temp1),
    string_concat(Temp1, "0%", R), !.
    
formatVar(Var, R) :-
    Var < 0,
    format(Var * -1, VarF),
    string_concat("▼", VarF, Temp1),
    string_concat(Temp1, "0%", R), !.
        
formatVar(_, "0.0%").


getTCCompanyCodePosition(1, [14, 12]).
getTCCompanyCodePosition(2, [17, 12]).
getTCCompanyCodePosition(3, [20, 12]).
getTCCompanyCodePosition(4, [23, 12]).
getTCCompanyCodePosition(5, [14, 43]).
getTCCompanyCodePosition(6, [17, 43]).
getTCCompanyCodePosition(7, [20, 43]).
getTCCompanyCodePosition(8, [23, 43]).
getTCCompanyCodePosition(9, [14, 74]).
getTCCompanyCodePosition(10, [17, 74]).
getTCCompanyCodePosition(11, [20, 74]).
getTCCompanyCodePosition(12, [23, 74]).


getTCCompanyVarPosition(1, [14, 27]).
getTCCompanyVarPosition(2, [17, 27]).
getTCCompanyVarPosition(3, [20, 27]).
getTCCompanyVarPosition(4, [23, 27]).
getTCCompanyVarPosition(5, [14, 58]).
getTCCompanyVarPosition(6, [17, 58]).
getTCCompanyVarPosition(7, [20, 58]).
getTCCompanyVarPosition(8, [23, 58]).
getTCCompanyVarPosition(9, [14, 89]).
getTCCompanyVarPosition(10, [17, 89]).
getTCCompanyVarPosition(11, [20, 89]).
getTCCompanyVarPosition(12, [23, 89]).