:- consult('../../Utils/MatrixUtils.pl').
:- consult('../../Utils/UpdateUtils.pl').
:- consult('../../Models/Client/GetSetAttrsClient.pl').
:- consult('../../Models/Company/GetSetAttrsCompany.pl').


% Atualiza todas as informações no Main Menu
updateMainMenu(IdUser) :-
    resetMenu("./MainMenu/mainMenu.txt", "../Sprites/MainMenu/mainMenu_base.txt"),
    % updateMatrixClock
    getCash("../Data/Clients.json", IdUser, Cash),
    updateMMCash("./MainMenu/mainMenu.txt", Cash),
    getCompanyJSON(Comps),
    updateAllMMCompanyCode("./MainMenu/mainMenu.txt", Comps),
    updateAllMMCompanyPrice("./MainMenu/mainMenu.txt", Comps),
    updateAllMMCompanyName("./MainMenu/mainMenu.txt", Comps).


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
    getCompanyCodePosition(IdComp, [Row|Col]),
    writeMatrixValue(FilePath, Code, Row, Col).


% Atualiza o nome de todas as empresas no Main Menu
updateAllMMCompanyName(_, []) :- !.
updateAllMMCompanyName(FilePath, [H|T]) :-
    getCompIdent(H, IdComp),
    updateMMCompanyName(FilePath, IdComp),
    updateAllMMCompanyName(FilePath, T).


updateMMCompanyName(FilePath, IdComp) :-
    getCompName(IdComp, Name),
    getCompanyNamePosition(IdComp, [Row|Col]),
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
    getCompanyPricePosition(IdComp, [Row|Col]),
    string_concat(Trend, Price, Temp1),
    string_concat(Temp1, "0", Temp2),
    fillLeft(Temp2, 7, NewPrice),
    string_length(NewPrice, Len),
    writeMatrixValue(FilePath, NewPrice, Row, Col - Len).


getCompanyCodePosition(1, [8, 24]).
getCompanyCodePosition(2, [13, 24]).
getCompanyCodePosition(3, [18, 24]).
getCompanyCodePosition(4, [23, 24]).
getCompanyCodePosition(5, [8, 49]).
getCompanyCodePosition(6, [13, 49]).
getCompanyCodePosition(7, [18, 49]).
getCompanyCodePosition(8, [23, 49]).
getCompanyCodePosition(9, [8, 74]).
getCompanyCodePosition(10, [13, 74]).
getCompanyCodePosition(11, [18, 74]).
getCompanyCodePosition(12, [23, 74]).


getCompanyNamePosition(1, [9, 31]).
getCompanyNamePosition(2, [14, 31]).
getCompanyNamePosition(3, [19, 31]).
getCompanyNamePosition(4, [24, 31]).
getCompanyNamePosition(5, [9, 56]).
getCompanyNamePosition(6, [14, 56]).
getCompanyNamePosition(7, [19, 56]).
getCompanyNamePosition(8, [24, 56]).
getCompanyNamePosition(9, [9, 81]).
getCompanyNamePosition(10, [14, 81]).
getCompanyNamePosition(11, [19, 81]).
getCompanyNamePosition(12, [24, 81]).


getCompanyPricePosition(1, [8, 39]).
getCompanyPricePosition(2, [13, 39]).
getCompanyPricePosition(3, [18, 39]).
getCompanyPricePosition(4, [23, 39]).
getCompanyPricePosition(5, [8, 64]).
getCompanyPricePosition(6, [13, 64]).
getCompanyPricePosition(7, [18, 64]).
getCompanyPricePosition(8, [23, 64]).
getCompanyPricePosition(9, [8, 89]).
getCompanyPricePosition(10, [13, 89]).
getCompanyPricePosition(11, [18, 89]).
getCompanyPricePosition(12, [23, 89]).