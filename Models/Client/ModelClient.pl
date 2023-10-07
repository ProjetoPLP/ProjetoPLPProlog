createClient(Ident, Name, Age, Cpf, Email, Password, Cash, Client) :-
    Client = client(Ident, Name, Age, Cpf, Email, Password, Cash, 0.0, false, 19, 51, []).


createAsset(CompanyID, Qtd, Asset) :- 
    Asset = asset(CompanyID, Qtd).
