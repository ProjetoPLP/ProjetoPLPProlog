:- consult('ModelClient.pl').
:- consult('SaveClient.pl').

main :-
    %createClient(1, 'Levi', '22', '13387993471', '12345', 'email@example.com', 100.0, Client),
    %Client = client(Ident,  Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, Row, Col, AllAssets),
    %saveClient('../../Data/Clients.json', Client), halt.
    
    %listarClientes(Out),
    %buscarClientePorId(1, Out, Result),
    %write(Result), halt.

    getClient(1, Result),
    write(Result),
    %createClient(1, 'Leviiiii', '22', '13387993471', '12345', 'email@example.com', 100.0, Client2),
    %Client2 = client(Ident,  Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, Row, Col, AllAssets),
    %editarCliente(Client2),
    %halt.
    halt.