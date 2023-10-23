:- module(loginClient, [saveLogin/1, logoutClient/0, getLoggedClient/1]).

:- use_module('./Utils/JsonUtils.pl').
:- use_module(library(http/json)).


saveLogin(Ident) :- 
    format(string(FormatedJson), '{"ident": ~w}', [Ident]),
    open("./Data/Login.json", write, Stream),
    write(Stream, FormatedJson),
    close(Stream).


logoutClient :- 
    open("./Data/Login.json", write, Stream),
    write(Stream, '{}'),
    close(Stream).


getLoggedClient(Client) :- 
    lerJSON("./Data/Login.json", File),
    toClient(File, Client).
    

toClient(JSON, Client) :- (
    get_dict(ident, JSON, Ident) ->
        Client = client(Ident)
    ;
        Client = client(-1)
    ).