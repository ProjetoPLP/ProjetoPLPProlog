:- use_module(library(http/json)).

lerJSON(JSONPath, File) :-
	open(JSONPath, read, F),
	json_read_dict(F, File).

listClientsJSON([], []).
listClientsJSON([H|T], [client(H.ident, H.name, H.age, H.cpf, H.email, H.password, H.cash, H.patrimony, H.canDeposit, H.row, H.col, H.allAssets)|Rest]) :- 
    listClientsJSON(T, Rest).

getClientJSON(JSONPath, Out) :-
	lerJSON(JSONPath, Clientes),
	listClientsJSON(Clientes , Out).

editarClienteJSON([], _, _, _, _, _, _, _, _, _, _, []).
editarClienteJSON([H|T], H.ident, Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, Row, Col, AllAssets, [_{ident: H.ident, name: Name, age: Age, cpf: Cpf, email: Email, password: Password, cash: Cash, patrimony: Patrimony, canDeposit: CanDeposit, row: Row, col: Col, allAssets: AllAssets} | T]).
editarClienteJSON([H|T], Ident, Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, Row, Col, AllAssets, [H|Out]) :- editarClienteJSON(T, Ident, Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, Row, Col, AllAssets, Out).

editClientJSON(JSONPath, Client) :-
    Client = client(Ident, Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, Row, Col, AllAssets),
	lerJSON(JSONPath, File),
	editarClienteJSON(File, Ident, Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, Row, Col, AllAssets, SaidaParcial),
	clientesToJSON(SaidaParcial, Saida),
	open(JSONPath, write, Stream), write(Stream, Saida), close(Stream).

clienteToJSON(Ident,  Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, Row, Col, AllAssets, Out) :-
	swritef(Out, '{"ident": %w, "name":"%w", "age": "%w", "cpf": "%w", "email": "%w", "password": "%w", "cash": %w,"patrimony": %w,"canDeposit": %w, "row": %w,"col": %w,"allAssets": %w}', [Ident,  Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, Row, Col, AllAssets]).

clientesToJSON([], []).
clientesToJSON([H|T], [X|Out]) :- 
	clienteToJSON(H.ident, H.name, H.age, H.cpf, H.email, H.password, H.cash, H.patrimony, H.canDeposit, H.row, H.col, H.allAssets, X), 
	clientesToJSON(T, Out).

readFileTxt(FilePath, Text) :-
    open(FilePath, read, Stream),
    read_stream_to_codes(Stream, TextCodes),
    close(Stream),
    string_codes(Text, TextCodes).

writeFileText(FilePath, TextContents) :-
    open(FilePath, write, St),
    open(FilePath, append, Stream),
    write(Stream, TextContents),
    close(Stream).

saveClientJSON(FilePath, Client) :- 
    Client = client(Ident, Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, Row, Col, AllAssets),
    lerJSON(JSONPath, File),
    clientesToJSON(File, ListaCompaniesJSON),
    getClientJSON(JSONPath, Out), length(Out, Length), NewIdent is Length + 1,
    clienteToJSON(NewIdent, Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, Row, Col, AllAssets, ClienteJSON),
    append(ListaCompaniesJSON, [ClienteJSON], Saida),
    open(JSONPath, write, Stream), write(Stream, Saida), close(Stream),
    readFileTxt('../../Sprites/Wallet/wallet_base.txt', TextContents),
    atom_concat('./Wallets/wallet', NewIdent, Temp),
    atom_concat(Temp, '.txt', WalletFileName),
    writeFileText(WalletFileName, TextContents).

removerClientJSON([], _, []).
removerClientJSON([H|T], H.ident, T).
removerClientJSON([H|T], Ident, [H|Out]) :- removerClientJSON(T, Ident, Out).

removeClientJSON(JSONPath, Id) :-
    lerJSON(JSONPath, File),
    removerClientJSON(File, Id, SaidaParcial),
    clientesToJSON(SaidaParcial, Saida),
    open(JSONPath, write, Stream), write(Stream, Saida), close(Stream).

getClient(JSONPath, Int, Clients) :- 
    getClientJSON(JSONPath, Out),
    getClientsByID(Int, Out, Clients).

getClientsByID(_, [], _) :- fail.
getClientsByID(Ident, [client(Ident, Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, Row, Col, AllAssets)|_], client(Ident, Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, Row, Col, AllAssets)).
getClientsByID(Ident, [_|Resto], ClienteEncontrado) :-
    getClientsByID(Ident, Resto, ClienteEncontrado).

existClientByEmail(JSONPath, Email, Result) :- 
    getClientJSON(JSONPath, Out),
    searchClientByEmail(Email, Out, Result).

searchClientByEmail(_, [], false).
searchClientByEmail(Email, [client(_, _, _, _, ClientEmail, _, _, _, _, _, _, _)|Rest], Result) :-
    string_lower(Email, LowerEmail), string_lower(ClientEmail, LowerClientEmail),
    LowerEmail = LowerClientEmail,
    Result = true;
    searchClientByEmail(Email, Rest, Result).
