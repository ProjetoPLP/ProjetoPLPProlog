:- consult('../../Utils/MatrixUtils.pl').
:- consult('../../Utils/UpdateUtils.pl').
:- consult('../../Models/Client/GetSetAttrsClient.pl').
:- consult('../../Models/Company/GetSetAttrsCompany.pl').
:- consult('../../Models/Clock/ClockUpdate.pl').


% Atualiza todas as informações no Main Menu
updateMainMenu(IdUser) :-
    FilePath = "./Menus/MainMenu/mainMenu.txt",
    resetMenu(FilePath, "./Sprites/MainMenu/mainMenu_base.txt"),
    getCash(IdUser, Cash),
    getCompanyJSON(Comps),

    updateMatrixClock(FilePath),
    updateMMCash(FilePath, Cash),
    updateAllMMCompanyCode(FilePath, Comps),
    updateAllMMCompanyPrice(FilePath, Comps),
    updateAllMMCompanyName(FilePath, Comps).


updateMMCash(FilePath, Cash) :-
    string_concat(Cash, "0", Temp),
    fillLeft(Temp, 9, StringR),
    string_length(StringR, Len),
    writeMatrixValue(FilePath, StringR, 3, (75 - Len)).


% Atualiza o código de todas as empresas no Main Menu
updateAllMMCompanyCode(_, []) :- !.
updateAllMMCompanyCode(FilePath, [H|T]) :-
    getCompIdent(H, IdComp),
    updateMMCompanyCode(FilePath, IdComp),
    updateAllMMCompanyCode(FilePath, T).


updateMMCompanyCode(FilePath, IdComp) :-
    getCode(IdComp, Code),
    getMMCompanyCodePosition(IdComp, [Row|Col]),
    writeMatrixValue(FilePath, Code, Row, Col).


% Atualiza o nome de todas as empresas no Main Menu
updateAllMMCompanyName(_, []) :- !.
updateAllMMCompanyName(FilePath, [H|T]) :-
    getCompIdent(H, IdComp),
    updateMMCompanyName(FilePath, IdComp),
    updateAllMMCompanyName(FilePath, T).


updateMMCompanyName(FilePath, IdComp) :-
    getCompName(IdComp, Name),
    getMMCompanyNamePosition(IdComp, [Row|Col]),
    getCompanyNameCol(Name, Col, NewCol),
    writeMatrixValue(FilePath, Name, Row, NewCol).


% Atualiza o preço de todas as empresas no Main Menu
updateAllMMCompanyPrice(_, []) :- !.
updateAllMMCompanyPrice(FilePath, [H|T]) :-
    getCompIdent(H, IdComp),
    updateMMCompanyPrice(FilePath, IdComp),
    updateAllMMCompanyPrice(FilePath, T).


updateMMCompanyPrice(FilePath, IdComp) :-
    getPrice(IdComp, Price),
    getTrendIndicator(IdComp, Trend),
    getMMCompanyPricePosition(IdComp, [Row|Col]),
    string_concat(Trend, Price, Temp1),
    string_concat(Temp1, "0", Temp2),
    fillLeft(Temp2, 7, NewPrice),
    string_length(NewPrice, Len),
    writeMatrixValue(FilePath, NewPrice, Row, Col - Len).


getMMCompanyCodePosition(1, [8, 24]).
getMMCompanyCodePosition(2, [13, 24]).
getMMCompanyCodePosition(3, [18, 24]).
getMMCompanyCodePosition(4, [23, 24]).
getMMCompanyCodePosition(5, [8, 49]).
getMMCompanyCodePosition(6, [13, 49]).
getMMCompanyCodePosition(7, [18, 49]).
getMMCompanyCodePosition(8, [23, 49]).
getMMCompanyCodePosition(9, [8, 74]).
getMMCompanyCodePosition(10, [13, 74]).
getMMCompanyCodePosition(11, [18, 74]).
getMMCompanyCodePosition(12, [23, 74]).


getMMCompanyNamePosition(1, [9, 31]).
getMMCompanyNamePosition(2, [14, 31]).
getMMCompanyNamePosition(3, [19, 31]).
getMMCompanyNamePosition(4, [24, 31]).
getMMCompanyNamePosition(5, [9, 56]).
getMMCompanyNamePosition(6, [14, 56]).
getMMCompanyNamePosition(7, [19, 56]).
getMMCompanyNamePosition(8, [24, 56]).
getMMCompanyNamePosition(9, [9, 81]).
getMMCompanyNamePosition(10, [14, 81]).
getMMCompanyNamePosition(11, [19, 81]).
getMMCompanyNamePosition(12, [24, 81]).


getMMCompanyPricePosition(1, [8, 39]).
getMMCompanyPricePosition(2, [13, 39]).
getMMCompanyPricePosition(3, [18, 39]).
getMMCompanyPricePosition(4, [23, 39]).
getMMCompanyPricePosition(5, [8, 64]).
getMMCompanyPricePosition(6, [13, 64]).
getMMCompanyPricePosition(7, [18, 64]).
getMMCompanyPricePosition(8, [23, 64]).
getMMCompanyPricePosition(9, [8, 89]).
getMMCompanyPricePosition(10, [13, 89]).
getMMCompanyPricePosition(11, [18, 89]).
getMMCompanyPricePosition(12, [23, 89]).