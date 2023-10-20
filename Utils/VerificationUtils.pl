:- consult('../Models/Company/GetSetAttrsCompany.pl').


% Verifica se existe uma empresa cadastrada a bolsa a partir do seu ID
existCompany(IdComp) :-
    getCompanyJSON(Comps),
    existCompanyAux(IdComp, Comps).

existCompanyAux(_, []) :- false, !.
existCompanyAux(IdComp, [H|T]) :-
    getCompIdent(H, CompId),
    (CompId =:= IdComp -> true ; existCompanyAux(IdComp, T)).


% Verifica se uma String é um número
isNumber("0", false) :- !.
isNumber(String, R) :-
    (atom_number(String, _) -> R = true ; R = false).