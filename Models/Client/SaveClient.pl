:- use_module(library(http/json)).

% ok
lerJSON(FilePath, File) :-
	open(FilePath, read, F),
	json_read_dict(F, File).

% ok
listClientsJSON([], []).
listClientsJSON([H|T], [client(H.ident, H.name, H.age, H.cpf, H.email, H.password, H.cash, H.patrimony, H.canDeposit, H.row, H.col, H.allAssets)|Rest]) :- 
    listClientsJSON(T, Rest).

% ok
getClientJSON(Out) :-
	lerJSON("../../Data/Clients.json", Clientes),
	listClientsJSON(Clientes , Out).

% ok
editarClienteJSON([], _, _, _, _, _, _, _, _, _, _, []).
editarClienteJSON([H|T], H.ident, Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, Row, Col, AllAssets, [_{ident: H.ident, name: Name, age: Age, cpf: Cpf, email: Email, password: Password, cash: Cash, patrimony: Patrimony, canDeposit: CanDeposit, row: Row, col: Col, allAssets: AllAssets} | T]).
editarClienteJSON([H|T], Ident, Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, Row, Col, AllAssets, [H|Out]) :- editarClienteJSON(T, Ident, Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, Row, Col, AllAssets, Out).

% ok
editClientJSON(Client) :-
    Client = client(Ident, Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, Row, Col, AllAssets),
	lerJSON("../../Data/Clients.json", File),
	editarClienteJSON(File, Ident, Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, Row, Col, AllAssets, SaidaParcial),
	clientesToJSON(SaidaParcial, Saida),
	open("../../Data/Clients.json", write, Stream), write(Stream, Saida), close(Stream).

clienteToJSON(Ident,  Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, Row, Col, AllAssets, Out) :-
	swritef(Out, '{"ident": %w, "name":"%w", "age": "%w", "cpf": "%w", "email": "%w", "password": "%w", "cash": %w,"patrimony": %w,"canDeposit": %w, "row": %w,"col": %w,"allAssets": %w}', [Ident,  Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, Row, Col, AllAssets]).

% ok
clientesToJSON([], []).
clientesToJSON([H|T], [X|Out]) :- 
	clienteToJSON(H.ident, H.name, H.age, H.cpf, H.email, H.password, H.cash, H.patrimony, H.canDeposit, H.row, H.col, H.allAssets, X), 
	clientesToJSON(T, Out).

% ok
saveClientJSON(FilePath, Client) :- 
    Client = client(Ident, Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, Row, Col, AllAssets),
    lerJSON(FilePath, File),
    clientesToJSON(File, ListaCompaniesJSON),
    getClientJSON(Out), length(Out, Length), NewIdent is Length + 1,
    clienteToJSON(NewIdent, Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, Row, Col, AllAssets, ClienteJSON),
    append(ListaCompaniesJSON, [ClienteJSON], Saida),
    open(FilePath, write, Stream), write(Stream, Saida), close(Stream).

% ok
removerClientJSON([], _, []).
removerClientJSON([H|T], H.ident, T).
removerClientJSON([H|T], Ident, [H|Out]) :- removerClientJSON(T, Ident, Out).

% ok
removeClientJSON(Id) :-
    lerJSON("../../Data/Clients.json", File),
    removerClientJSON(File, Id, SaidaParcial),
    clientesToJSON(SaidaParcial, Saida),
    open("../../Data/Clients.json", write, Stream), write(Stream, Saida), close(Stream).

% ok
getClient(Int, Clients) :- 
    getClientJSON(Out),
    getClientsByID(Int, Out, Clients).

% ok
getClientsByID(_, [], _) :- fail.
getClientsByID(Ident, [client(Ident, Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, Row, Col, AllAssets)|_], client(Ident, Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, Row, Col, AllAssets)).
getClientsByID(Ident, [_|Resto], ClienteEncontrado) :-
    getClientsByID(Ident, Resto, ClienteEncontrado).

% ok
existClientByEmail(Email, Result) :- 
    getClientJSON(Out),
    searchClientByEmail(Email, Out, Result).

% ok
searchClientByEmail(_, [], false).
searchClientByEmail(Email, [client(_, _, _, _, ClientEmail, _, _, _, _, _, _, _)|Rest], Result) :-
    string_lower(Email, LowerEmail), string_lower(ClientEmail, LowerClientEmail),
    LowerEmail = LowerClientEmail,
    Result = true;
    searchClientByEmail(Email, Rest, Result).
