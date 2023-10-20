:- use_module(library(http/json)).

saveLogin(Client) :- 
    open("../Data/Login.json", write, Stream),
    write(Stream, Client),
    close(Stream).

logoutClient :- 
    open("../Data/Login.json", write, Stream),
    write(Stream, '{}'),
    close(Stream).

getLoggedClient(Client) :- 
    lerJSON("../Data/Login.json", File),
    toClient(File, Client).
    
lerJSON(FilePath, File) :-
    open(FilePath, read, Stream),
    json_read_dict(Stream, File),
    close(Stream).

toClient(JSON, Client) :- (
    get_dict(ident, JSON, Ident),
    get_dict(name, JSON, Name),
    get_dict(age, JSON, Age),
    get_dict(cpf, JSON, CPF),
    get_dict(email, JSON, Email),
    get_dict(password, JSON, Password),
    get_dict(cash, JSON, Cash),
    get_dict(patrimony, JSON, Patrimony),
    get_dict(canDeposit, JSON, CanDeposit),
    get_dict(row, JSON, Row),
    get_dict(col, JSON, Col),
    get_dict(allAssets, JSON, AllAssets) ->
        Client = client(Ident, Name, Age, CPF, Email, Password, Cash, Patrimony, CanDeposit, Row, Col, AllAssets);
        Client = client(0, '', 0, '', '', '', 0.0, 0.0, false, 0, 0, [])
    ).
