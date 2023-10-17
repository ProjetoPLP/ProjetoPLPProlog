:- consult('../Models/Company/GetSetAttrsCompany.pl').


% Verifica se existe uma empresa cadastrada a bolsa a partir do seu ID
existCompany(Id, R) :-
    getCompanyJSON(Comps),
    existCompanyAux(Id, Comps, R).

existCompanyAux(_, [], false) :- !.
existCompanyAux(Id, (H|T), R) :-
    getIdent(H, CompId),
    (CompId =:= Id -> true ; existCompanyAux(Id, T, R)).


% Verifica se uma String é um número
isNumber("0", false) :- !.
isNumber(String, R) :-
    (atom_number(String, _) -> R = true ; R = false).