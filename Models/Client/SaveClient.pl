:- use_module(library(http/json)).

% Fato dinâmico para gerar o id dos agentes
id(1).
incrementa_id :- retract(id(X)), Y is X + 1, assert(id(Y)).
:- dynamic id/1.

lerJSON(FilePath, File) :-
	open(FilePath, read, F),
	json_read_dict(F, File).

% feito
exibirClientesAux([], []).
exibirClientesAux([H|T], [client(H.ident, H.name, H.age, H.cpf, H.cpf, H.password, H.cash, H.patrimony, H.canDeposit, H.row, H.col, H.allAssets)|Rest]) :- 
    exibirClientesAux(T, Rest).

listarClientes(Out) :-
	lerJSON("../../Data/Clients.json", Clientes),
	exibirClientesAux(Clientes , Result),
    Out = Result.
% --

editarClienteJSON([], _, _, _, _, _, _, _, _, _, _, []).
editarClienteJSON([H|T], H.ident, Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, Row, Col, AllAssets, [_{ident: H.ident, name: Name, age: Age, cpf: Cpf, email: Email, password: Password, cash: Cash, patrimony: Patrimony, canDeposit: CanDeposit, row: Row, col: Col, allAssets: AllAssets} | T]).
editarClienteJSON([H|T], Ident, Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, Row, Col, AllAssets, [H|Out]) :- editarClienteJSON(T, Ident, Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, Row, Col, AllAssets, Out).

editarCliente(Client) :-
    Client = client(Ident, Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, Row, Col, AllAssets),
	lerJSON("../../Data/Clients.json", File),
	editarClienteJSON(File, Ident, Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, Row, Col, AllAssets, SaidaParcial),
	clientesToJSON(SaidaParcial, Saida),
	open("../../Data/Clients.json", write, Stream), write(Stream, Saida), close(Stream).

% Feito
clienteToJSON(Ident,  Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, Row, Col, AllAssets, Out) :-
	swritef(Out, '{"ident": %w, "name":"%w", "age": "%w", "cpf": "%w", "email": "%w", "password": "%w", "cash": %w,"patrimony": %w,"canDeposit": %w, "row": %w,"col": %w,"allAssets": %w}', [Ident,  Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, Row, Col, AllAssets]).

clientesToJSON([], []).
clientesToJSON([H|T], [X|Out]) :- 
	clienteToJSON(H.ident, H.name, H.age, H.cpf, H.cpf, H.password, H.cash, H.patrimony, H.canDeposit, H.row, H.col, H.allAssets, X), 
	clientesToJSON(T, Out).

saveClient(FilePath, Client) :- 
    Client = client(Ident, Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, Row, Col, AllAssets),
    id(ID), incrementa_id,
    lerJSON(FilePath, File),
    clientesToJSON(File, ListaAgentesJSON),
    listarClientes(Out), length(Out, Length), NewIdent is Length + 1,
    clienteToJSON(NewIdent,  Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, Row, Col, AllAssets, ClienteJSON),
    append(ListaAgentesJSON, [ClienteJSON], Saida),
    open(FilePath, write, Stream), write(Stream, Saida), close(Stream).
% --

% Feito
removerClienteJSON([], _, []).
removerClienteJSON([H|T], H.ident, T).
removerClienteJSON([H|T], Ident, [H|Out]) :- removerClienteJSON(T, Ident, Out).

removeClient(Id) :-
    lerJSON("../../Data/Clients.json", File),
    removerClienteJSON(File, Id, SaidaParcial),
    clientesToJSON(SaidaParcial, Saida),
    open("../../Data/Clients.json", write, Stream), write(Stream, Saida), close(Stream).
% --

getClient(Int, Clients) :- 
    listarClientes(Out), 
    buscarClientePorId(Int, Out, Clients).

buscarClientePorId(_, [], _) :- fail.
buscarClientePorId(Id, [client(Id, Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, Row, Col, AllAssets)|_], client(Id, Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, Row, Col, AllAssets)).
buscarClientePorId(Id, [_|Resto], ClienteEncontrado) :-
    buscarClientePorId(Id, Resto, ClienteEncontrado).