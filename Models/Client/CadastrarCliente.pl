:- module(cadastrarCliente, [cadastrarCliente/0]).

:- use_module('./Models/Client/GetInfoForCreateClient.pl').
:- use_module('./Models/Client/SaveClient.pl').
:- use_module('./Models/Client/ModelClient.pl').


cadastrarCliente :-
    getNewClient(Client),
    saveClientJSON(Client).


getNewClient(Client) :-
    getClientName(Name),
    getAge(Age),
    getCPF(CPF),
    getEmail(Email),
    getPassword(Password),
    createClient(1, Name, Age, CPF, Email, Password, 100.0, Client).