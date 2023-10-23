:- module(realizarLogin, [fazerLogin/1]).

:- use_module('./Models/Client/GetInfoForMakeLogin.pl').
:- use_module('./Models/Client/SaveClient.pl').
:- use_module('./Models/Client/LoginClient.pl').
:- use_module(library(http/json)).


fazerLogin(Result) :-
    getLoginEmail(LoginEmail),
    getLoginPassword(LoginPassWord),
    searchAndGetClientByEmail(LoginEmail, client(Ident, _, _, _, _, Password, _, _, _, _, _, _)),
    (Ident =\= -1 ->
        (Password == LoginPassWord ->
            saveLogin(Ident),
            Result = true
        ;
            writeln("Aviso: Senha incorreta."),
            Result = false
        )
    ;
        writeln("Aviso: E-mail não cadastrado."),
        Result = false
).


searchAndGetClientByEmail(LoginEmail, Client) :-
    getClientJSON(Clients),
    verifingIfExistEmailClient(LoginEmail, Clients, Client).


verifingIfExistEmailClient(_, [], client(-1, '', '', '', '', '', 0.0, 0.0, false, 0, 0, [])).
verifingIfExistEmailClient(LoginEmail, [H|T], Client) :-
    H = client(_, _, _, _, Email, _, _, _, _, _, _, _),
    (LoginEmail == Email -> Client = H ; verifingIfExistEmailClient(LoginEmail, T, Client)).