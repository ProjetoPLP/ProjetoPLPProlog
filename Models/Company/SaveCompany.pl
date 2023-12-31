:- module(saveCompany, [getCompanyJSON/1, editCompanyJSON/1, saveCompanyJSON/1, removeCompany/1, getCompany/2, existCompanyByName/1, existCompanyByCode/1]).

:- use_module('./Utils/JsonUtils.pl').
:- use_module(library(http/json)).


exibirCompaniesAux([], []).
exibirCompaniesAux([H|T], [company(H.ident, H.name, H.age, H.cnpj, H.actuation, H.declaration, H.code, H.price, H.trendIndicator, H.minPrice, H.maxPrice, H.startPrice, H.row, H.col)|Rest]) :- 
    exibirCompaniesAux(T, Rest).


getCompanyJSON(Out) :-
	lerJSON("./Data/Companies.json", Companies),
	exibirCompaniesAux(Companies , Result),
    Out = Result.

editarCompanyJSON([], _, _, _, _, _, _, _, _, _, _, []).
editarCompanyJSON([H|T], H.ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, MaxPrice, StartPrice, Row, Col, [_{ident: H.ident, name: Name, age: Age, cnpj: Cnpj, actuation: Actuation, declaration: Declaration, code: Code, price: Price, trendIndicator: TrendIndicator, minPrice: MinPrice, maxPrice: MaxPrice, startPrice: StartPrice, row: Row, col: Col} | T]).
editarCompanyJSON([H|T], Ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, MaxPrice, StartPrice, Row, Col, [H|Out]) :- editarCompanyJSON(T, Ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, MaxPrice, StartPrice, Row, Col, Out).

editCompanyJSON(Company) :-
    Company = company(Ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, MaxPrice, StartPrice, Row, Col),
	lerJSON("./Data/Companies.json", File),
	editarCompanyJSON(File, Ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, MaxPrice, StartPrice, Row, Col, SaidaParcial),
	companiesToJSON(SaidaParcial, Saida),
	open("./Data/Companies.json", write, Stream), write(Stream, Saida), close(Stream).

companyToJSON(Ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, MaxPrice, StartPrice, Row, Col, Out) :-
	swritef(Out, '{"ident": %w, "name": "%w", "age": "%w", "cnpj": "%w", "actuation": "%w", "declaration": "%w", "code": "%w", "price": %w, "trendIndicator": "%w", "minPrice": %w, "maxPrice": %w, "startPrice": %w, "row": %w, "col": %w}', [Ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, MaxPrice, StartPrice, Row, Col]).

companiesToJSON([], []).
companiesToJSON([H|T], [X|Out]) :- 
	companyToJSON(H.ident, H.name, H.age, H.cnpj, H.actuation, H.declaration, H.code, H.price, H.trendIndicator, H.minPrice, H.maxPrice, H.startPrice, H.row, H.col, X), 
	companiesToJSON(T, Out).

writeFileTxt(FilePath, TextContents) :-
    open(FilePath, append, Stream),
    write(Stream, TextContents),
    close(Stream).

saveCompanyJSON(Company) :- 
    Company = company(_, Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, MaxPrice, StartPrice, Row, Col),
    lerJSON("./Data/Companies.json", File),
    companiesToJSON(File, ListaCompaniesJSON),
    identifyIDSequenceBreak([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], NewIdent),
    companyToJSON(NewIdent,  Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, MaxPrice, StartPrice, Row, Col, CompanyJSON),
    append(ListaCompaniesJSON, [CompanyJSON], Saida),
    open("./Data/Companies.json", write, Stream), write(Stream, Saida), close(Stream),
    readFileTxt('./Sprites/HomeBroker/homebroker_base.txt', TextContents),
    atom_concat('./Models/Company/HomeBrokers/homebroker', NewIdent, Temp),
    atom_concat(Temp, '.txt', WalletFileName),
    writeFileTxt(WalletFileName, TextContents).


identifyIDSequenceBreak([], 1).
identifyIDSequenceBreak([H|T], R) :-
    getCompanyJSON(Companies),
    getCompaniesIds(Companies, Ids),
    (\+ member(H, Ids) -> R is H ; identifyIDSequenceBreak(T, R)).

getCompaniesIds([], []) :- !.
getCompaniesIds([company(Ident, _, _, _, _, _, _, _, _, _, _, _, _, _)|T], [Ident|RestoIds]) :-
    getCompaniesIds(T, RestoIds).


removeCompanyAux([], _, []).
removeCompanyAux([H|T], H.ident, T).
removeCompanyAux([H|T], Ident, [H|Out]) :- removeCompanyAux(T, Ident, Out).

deleteFile(Id) :-
    atom_concat('./Models/Company/HomeBrokers/homebroker', Id, Temp),
    atom_concat(Temp, '.txt', DeleteFilePath),
    delete_file(DeleteFilePath).

removeCompany(Id) :-
    lerJSON("./Data/Companies.json", File),
    removeCompanyAux(File, Id, SaidaParcial),
    deleteFile(Id),
    companiesToJSON(SaidaParcial, Saida),
    open("./Data/Companies.json", write, Stream), write(Stream, Saida), close(Stream).


getCompany(Int, Company) :- 
    getCompanyJSON(Out), 
    buscarCompanyPorId(Int, Out, Company).

buscarCompanyPorId(_, [], _) :- fail.
buscarCompanyPorId(Ident, [company(Ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, MaxPrice, StartPrice, Row, Col)|_], company(Ident,  Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, MaxPrice, StartPrice, Row, Col)).
buscarCompanyPorId(Ident, [_|Resto], CompanyeEncontrado) :-
    buscarCompanyPorId(Ident, Resto, CompanyeEncontrado).


existCompanyByName(Name) :- 
    getCompanyJSON(Companies),
    verifyExistNameCompany(Name, Companies).

verifyExistNameCompany(_, []) :- !, false.
verifyExistNameCompany(NameComp, [company(_, Name, _, _, _, _, _, _, _, _, _, _, _, _) | Rest]) :-
    (NameComp == Name -> true ; verifyExistNameCompany(NameComp, Rest)).


existCompanyByCode(Code) :-
    getCompanyJSON(Companies),
    upcase_atom(Code, UpperCode),
    verifyExistCompanyCode(UpperCode, Companies).

verifyExistCompanyCode(_, []) :- !, false.
verifyExistCompanyCode(CodeComp, [company(_, _, _, _, _, _, Code, _, _, _, _, _, _, _) | Rest]) :-
    upcase_atom(Code, UpperCode),
    (CodeComp == UpperCode -> true ; verifyExistCompanyCode(CodeComp, Rest)).