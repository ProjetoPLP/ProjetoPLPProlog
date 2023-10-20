:- use_module(library(http/json)).

lerJSON(JSONPath, File) :-
	open(JSONPath, read, Stream),
	json_read_dict(Stream, File),
    close(Stream).

exibirCompaniesAux([], []).
exibirCompaniesAux([H|T], [company(H.ident, H.name, H.age, H.cnpj, H.actuation, H.declaration, H.code, H.price, H.trendIndicator, H.minPrice, H.maxPrice, H.startPrice, H.row, H.col)|Rest]) :- 
    exibirCompaniesAux(T, Rest).

% ok
getCompanyJSON(Out) :-
	lerJSON("../Data/Companies.json", Companies),
	exibirCompaniesAux(Companies , Result),
    Out = Result.

editarCompanyJSON([], _, _, _, _, _, _, _, _, _, _, []).
editarCompanyJSON([H|T], H.ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, MaxPrice, StartPrice, Row, Col, [_{ident: H.ident, name: Name, age: Age, cnpj: Cnpj, actuation: Actuation, declaration: Declaration, code: Code, price: Price, trendIndicator: TrendIndicator, minPrice: MinPrice, maxPrice: MaxPrice, startPrice: StartPrice, row: Row, col: Col} | T]).
editarCompanyJSON([H|T], Ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, MaxPrice, StartPrice, Row, Col, [H|Out]) :- editarCompanyJSON(T, Ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, MaxPrice, StartPrice, Row, Col, Out).

editCompanyJSON(Company) :-
    Company = company(Ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, MaxPrice, StartPrice, Row, Col),
	lerJSON("../Data/Companies.json", File),
	editarCompanyJSON(File, Ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, MaxPrice, StartPrice, Row, Col, SaidaParcial),
	companiesToJSON(SaidaParcial, Saida),
	open("../Data/Companies.json", write, Stream), write(Stream, Saida), close(Stream).

companyToJSON(Ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, MaxPrice, StartPrice, Row, Col, Out) :-
	swritef(Out, '{"ident": %w, "name": "%w", "age": "%w", "cnpj": "%w", "actuation": "%w", "declaration": "%w", "code": "%w", "price": %w, "trendIndicator": "%w", "minPrice": %w, "maxPrice": %w, "startPrice": %w, "row": %w, "col": %w}', [Ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, MaxPrice, StartPrice, Row, Col]).

companiesToJSON([], []).
companiesToJSON([H|T], [X|Out]) :- 
	companyToJSON(H.ident, H.name, H.age, H.cnpj, H.actuation, H.declaration, H.code, H.price, H.trendIndicator, H.minPrice, H.maxPrice, H.startPrice, H.row, H.col, X), 
	companiesToJSON(T, Out).

readFileTxt(FilePath, Text) :-
    open(FilePath, read, Stream),
    read_stream_to_codes(Stream, TextCodes),
    close(Stream),
    string_codes(Text, TextCodes).

writeFileTxt(FilePath, TextContents) :-
    open(FilePath, append, Stream),
    write(Stream, TextContents),
    close(Stream).

saveCompanyJSON(Company) :- 
    Company = company(Ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, MaxPrice, StartPrice, Row, Col),
    lerJSON("../Data/Companies.json", File),
    companiesToJSON(File, ListaCompaniesJSON),
    identifyIDSequenceBreak([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], NewIdent),
    companyToJSON(NewIdent,  Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, MaxPrice, StartPrice, Row, Col, CompanyJSON),
    append(ListaCompaniesJSON, [CompanyJSON], Saida),
    open("../Data/Companies.json", write, Stream), write(Stream, Saida), close(Stream),
    readFileTxt('../Sprites/HomeBroker/homebroker_base.txt', TextContents),
    atom_concat('../Models/Company/HomeBrokers/homebroker', NewIdent, Temp),
    atom_concat(Temp, '.txt', WalletFileName),
    writeFileTxt(WalletFileName, TextContents).


identifyIDSequenceBreak([], 1).
identifyIDSequenceBreak([H|T], R) :-
    getCompanyJSON(Companies),
    getCompaniesIds(Companies, Ids),
    sort(Ids, Sorted),
    (\+ member(H, Sorted) -> R is H ; identifyIDSequenceBreak(T, R)).

getCompaniesIds([], []) :- !.
getCompaniesIds([company(Ident, _, _, _, _, _, _, _, _, _, _, _, _, _)|T], [Ident|RestoIds]) :-
    getCompaniesIds(T, RestoIds).


removeCompany([], _, []).
removeCompany([H|T], H.ident, T).
removeCompany([H|T], Ident, [H|Out]) :- removeCompany(T, Ident, Out).

deleteFile(Id) :-
    atom_concat('../Models/Company/HomeBrokers/homebroker', Id, Temp),
    atom_concat(Temp, '.txt', DeleteFilePath),
    delete_file(DeleteFilePath).

removeCompany(Id) :-
    lerJSON("../Data/Companies.json", File),
    removeCompany(File, Id, SaidaParcial),
    deleteFile(Id),
    companiesToJSON(SaidaParcial, Saida),
    open("../Data/Companies.json", write, Stream), write(Stream, Saida), close(Stream).

% ok
getCompany(Int, Company) :- 
    getCompanyJSON(Out), 
    buscarCompanyPorId(Int, Out, Company).

buscarCompanyPorId(_, [], _) :- fail.
buscarCompanyPorId(Ident, [company(Ident, Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, MaxPrice, StartPrice, Row, Col)|_], company(Ident,  Name, Age, Cnpj, Actuation, Declaration, Code, Price, TrendIndicator, MinPrice, MaxPrice, StartPrice, Row, Col)).
buscarCompanyPorId(Ident, [_|Resto], CompanyeEncontrado) :-
    buscarCompanyPorId(Ident, Resto, CompanyeEncontrado).
