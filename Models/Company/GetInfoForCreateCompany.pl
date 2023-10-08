:- consult('SaveCompany.pl').
:- use_module(library(http/json)).
:- dynamic user/5.
:- dynamic user/5.

getName(Name) :-
    write('Digite o nome da empresa: '),
    flush_output(current_output),
    read_string(user_input, "\n", "\r", _, NameStr),
    (string_length(NameStr, Length), Length > 18 ->
        writeln('Aviso: O nome da empresa deve ter no máximo 18 caracteres.'),
        getName(Name);
        (existCompanyByName(NameStr, true) ->
            writeln('\nAviso: A empresa já foi cadastrada.'),
            getName(Name);
            Name = NameStr
        )
    ).

getAgeFounded(AgeFounded) :-
    write('Digite o ano de fundação da empresa: '),
    flush_output(current_output),
    read_line_to_string(user_input, AgeStr),
    (not(number_string(AgeFounded, AgeStr)) ->
        writeln('\nAviso: o ano de fundação deve possuir apenas números.'),
        getAgeFounded(AgeFounded);
    true).

getCNPJ(CNPJ) :-
    write('Digite o CNPJ da empresa (apenas números, 14 dígitos): '),
    flush_output(current_output),
    read_line_to_string(user_input, CNPJStr),
    (string_length(CNPJStr, 14), atom_number(CNPJStr, _), formatCNPJ(CNPJStr, FormattedCNPJ) ->
        CNPJ = FormattedCNPJ;
    writeln('\nAviso: O CNPJ deve possuir apenas números e conter 14 dígitos.'),
    getCNPJ(CNPJ)).
    
formatCNPJ(CNPJStr, FormattedCNPJ) :-
    sub_string(CNPJStr, 0, 2, _, Part1),
    sub_string(CNPJStr, 2, 3, _, Part2),
    sub_string(CNPJStr, 5, 3, _, Part3),
    sub_string(CNPJStr, 8, 4, _, Part4),
    sub_string(CNPJStr, 12, _, 0, Part5),
    format(string(FormattedCNPJ), '~w.~w.~w/~w-~w', [Part1, Part2, Part3, Part4, Part5]).
        
getActuation(Actuation) :-
    write('Digite a área de atuação da empresa: '),
    flush_output(current_output),
    read_string(user_input, "\n", "\r", _, Actuation),
    (string_length(Actuation, Length), Length > 29 ->
        writeln('\nAviso: A área de atuação da empresa deve ter no máximo 29 caracteres.'),
        getActuation(Actuation);
    true).

getDeclaration(Declaration) :-
    write('Digite a declaração de missão da empresa: '),
    flush_output(current_output),
    read_string(user_input, "\n", "\r", _, Declaration),
    (string_length(Declaration, Length), Length > 86 ->
        writeln('\nAviso: A declaração de missão da empresa deve ter no máximo 86 caracteres.'),
        getDeclaration(Declaration);
    true).

getCode(Code) :-
    write('Digite o código da ação (deve seguir o modelo VALE3): '),
    flush_output(current_output),
    read_line_to_string(user_input, CodeStr),
    (string_length(CodeStr, Length), Length \= 5 ->
        writeln('\nAviso: O código da ação deve possuir 5 caracteres.'),
        getCode(Code);
    true),
    upcase_atom(CodeStr, UpperCode),
    Code = UpperCode.

existCompanyByName(Name, Result) :- 
    getCompanyJSON(List),
    verifyIfExists(Name, List, Result).

verifyIfExists(_, [], false).
verifyIfExists(NameComp, [Company | Rest], Result) :-
    Company = company(_, Name, _, _, _, _, _, _, _, _, _, _, _, _),
    downcase_atom(Name, LowercaseName),
    downcase_atom(NameComp, LowercaseNameComp),
    (LowercaseNameComp = LowercaseName -> 
        Result = true;
        verifyIfExists(NameComp, Rest, Result)
    ).
