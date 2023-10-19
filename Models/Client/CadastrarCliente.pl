:- consult('GetInfoForCreateClient.pl').
:- consult('SaveClient.pl').
:- consult('ModelClient.pl').

cadastrarCliente :-
    getNewClient(Client),
    saveClientJSON(Client).

getNewClient(Client) :-
    getName(Name),
    getAge(Age),
    getCPF(CPF),
    getEmail(Email),
    getPassword(Password),
    createClient(1, Name, Age, CPF, Email, Password, 100.0, Client).
