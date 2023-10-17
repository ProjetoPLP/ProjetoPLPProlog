:- consult('GetSetAttrsClient.pl').
:- consult('SaveClient.pl').
:- consult('ModelClient.pl').

addAsset(JSONPath, ClientID, CompanyID, Qtd, Result) :- 
    getClient(JSONPath, ClientID, Client),
    Client = client(Ident, Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, Row, Col, AllAssets),
    exam(AllAssets, CompanyID, Qtd, NewAllAssets),
    deleteZeroOrNegative(NewAllAssets, NewAllAssetsPositive),
    NewClient = client(Ident, Name, Age, Cpf, Email, Password, Cash, Patrimony, CanDeposit, Row, Col, NewAllAssetsPositive),
    editClientJSON(JSONPath, NewClient),
    Result = true.

exam(AllAssets, CompanyID, Qtd, NewAllAssets) :-
    buscarEmpresa(AllAssets, CompanyID, OldQtd),
    NovoQtd is OldQtd + Qtd,
    atualizarEmpresa(AllAssets, CompanyID, NovoQtd, NewAllAssets).

atualizarEmpresa([], CompanyID, Qtd, [[CompanyID, Qtd]]).
atualizarEmpresa([[CompanyID, _]|Rest], CompanyID, NovoQtd, [[CompanyID, NovoQtd]|Rest]).
atualizarEmpresa([X|Rest], CompanyID, Qtd, [X|NewRest]) :-
    atualizarEmpresa(Rest, CompanyID, Qtd, NewRest).

buscarEmpresa([], _, 0).
buscarEmpresa([[CompanyID, Qtd]|_], CompanyID, Qtd).
buscarEmpresa([_|Rest], CompanyID, Qtd) :-
    buscarEmpresa(Rest, CompanyID, Qtd).

deleteZeroOrNegative([], []).
deleteZeroOrNegative([[CompanyID, Qtd]|Rest], Filtered) :-
    (Qtd > 0 ->
        Filtered = [[CompanyID, Qtd]|NewRest]
    ;
        Filtered = NewRest
    ),
    deleteZeroOrNegative(Rest, NewRest).