:- consult('ModelClient.pl').
:- consult('SaveClient.pl').

main :-
    createClient(1, 'Levi', '22', '999', 'email@example.com', '12345', 100.0, Client),
    Client = client(Ident,  Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, Row, Col, AllAssets),
    saveClientJSON('../../Data/Clients.json', Client), 

    existClientByEmail('email@example.com', Result),
    write(Result),
    
    halt.
