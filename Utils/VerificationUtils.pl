:- consult('../Models/Company/GetSetAttrsCompany.pl').


% Verifica se existe uma empresa cadastrada a bolsa a partir do seu ID
existCompany(JSONPath, Id, R) :-
    getCompanyJSON(JSONPath, Comps),
    existCompanyAux(JSONPath, Id, Comps, R).

existCompanyAux(_, _, [], false) :- !.
existCompanyAux(JSONPath, Id, (H|T), R) :-
    getIdent(JSONPath, H, CompId),
    (CompId =:= Id -> true ; existCompanyAux(JSONPath, Id, T, R)).


% Verifica se uma String é um número
isNumber("0", false) :- !.
isNumber(String, R) :-
    (atom_number(String, _) -> R = true ; R = false).