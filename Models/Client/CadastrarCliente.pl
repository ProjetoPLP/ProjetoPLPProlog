:- consult('GetInfoForCreateClient.pl').
:- consult('SaveClient.pl').
:- consult('ModelClient.pl').

cadastrarCliente :-
    getNewClient(Client),
    saveClientJSON("../../Data/Clients.json", Client).

getNewClient(Client) :-
    getName(Name),
    getAge(Age),
    getCPF(CPF),
    getEmail(Email),
    getPassword(Password),
    createClient(1, Name, Age, CPF, Email, Password, 100.0, Client).

main:-
    cadastrarCliente,
    halt.