:- consult('../../../Utils/MatrixUtils.pl').
:- consult('../../../Utils/UpdateUtils.pl').
:- consult('../../../Models/Client/GetSetAttrsClient.pl').
:- consult('../../../Models/Company/GetSetAttrsCompany.pl').
:- consult('../../../Models/Company/SaveCompany.pl').


% Atualiza todas as informações no menu de fechamento do pregão
updateTrendingClose(IdUser) :-
    resetMenu("./HomeBroker/TrendingClose/trendingClose.txt", "../Sprites/HomeBroker/trendingClose_base.txt"),
    % updateMatrixClock
    getCash(IdUser, Cash),
    updateTCCash("./HomeBroker/TrendingClose/trendingClose.txt", Cash),
    getPatrimony(IdUser, Patrimony),
    updateTCPatrimony("./HomeBroker/TrendingClose/trendingClose.txt", Patrimony),
    getCompanyJSON(Comps),
    updateAllTCCompanyCode("./HomeBroker/TrendingClose/trendingClose.txt", Comps),
    updateAllTCCompanyVar("./HomeBroker/TrendingClose/trendingClose.txt", Comps),
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
    getCompanyCodePosition(IdComp, [Row|Col]),
    getCode(IdComp, Code),
    writeMatrixValue(FilePath, Code, Row, Col).


updateAllTCCompanyVar(_, []) :- !.
updateAllTCCompanyVar(FilePath, [H|T]) :-
    getCompIdent(H, IdComp),
    updateTCCompanyVar(FilePath, IdComp),
    updateAllTCCompanyVar(FilePath, T).


updateTCCompanyVar(FilePath, IdComp) :-
    getCompanyVarPosition(IdComp, [Row|Col]),
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


getCompanyCodePosition(1, [14, 12]).
getCompanyCodePosition(2, [17, 12]).
getCompanyCodePosition(3, [20, 12]).
getCompanyCodePosition(4, [23, 12]).
getCompanyCodePosition(5, [14, 43]).
getCompanyCodePosition(6, [17, 43]).
getCompanyCodePosition(7, [20, 43]).
getCompanyCodePosition(8, [23, 43]).
getCompanyCodePosition(9, [14, 74]).
getCompanyCodePosition(10, [17, 74]).
getCompanyCodePosition(11, [20, 74]).
getCompanyCodePosition(12, [23, 74]).


getCompanyVarPosition(1, [14, 27]).
getCompanyVarPosition(2, [17, 27]).
getCompanyVarPosition(3, [20, 27]).
getCompanyVarPosition(4, [23, 27]).
getCompanyVarPosition(5, [14, 58]).
getCompanyVarPosition(6, [17, 58]).
getCompanyVarPosition(7, [20, 58]).
getCompanyVarPosition(8, [23, 58]).
getCompanyVarPosition(9, [14, 89]).
getCompanyVarPosition(10, [17, 89]).
getCompanyVarPosition(11, [20, 89]).
getCompanyVarPosition(12, [23, 89]).