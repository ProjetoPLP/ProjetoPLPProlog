:- module(getInfoForCreateCompany, [getCompanyName/1, getAgeFounded/1, getCNPJ/1, getActuation/1, getDeclaration/1, getCode/1]).

:- use_module('./Utils/VerificationUtils.pl').
:- use_module('./Models/Company/SaveCompany.pl').


getCompanyName(Name) :-
    write("Digite o nome da empresa: "),
    read_line_to_string(user_input, Input),
    (string_length(Input, Length), Length > 18 ->
        writeln("Aviso: O nome da empresa deve ter no máximo 18 caracteres."),
        getCompanyName(Name)
    ;
    existCompanyByName(Input) ->
        writeln("\nAviso: A empresa já foi cadastrada."),
        getCompanyName(Name)
    ;
        Name = Input
    ).


getAgeFounded(AgeFounded) :-
    write("Digite o ano de fundação da empresa: "),
    read_line_to_string(user_input, Input),
    (\+ isNumber(Input) ->
        writeln("\nAviso: o ano de fundação deve possuir apenas números."),
        getAgeFounded(AgeFounded)
    ;
        AgeFounded = Input
    ).


getCNPJ(CNPJ) :-
    write("Digite o CNPJ da empresa (apenas números, 14 dígitos): "),
    read_line_to_string(user_input, Input),
    (\+ isNumber(Input) ->
        writeln("\nAviso: o CNPJ deve possuir apenas números."),
        getCNPJ(CNPJ)
    ;
    string_length(Input, Length), Length =\= 14 -> 
        writeln("\nAviso: O CNPJ não contém 14 dígitos."),
        getCNPJ(CNPJ)
    ;
        formatCNPJ(Input, FormattedCNPJ),
        CNPJ = FormattedCNPJ
    ).
    

formatCNPJ(CNPJ, FormattedCNPJ) :-
    sub_string(CNPJ, 0, 2, _, Part1),
    sub_string(CNPJ, 2, 3, _, Part2),
    sub_string(CNPJ, 5, 3, _, Part3),
    sub_string(CNPJ, 8, 4, _, Part4),
    sub_string(CNPJ, 12, _, 0, Part5),
    format(string(FormattedCNPJ), '~w.~w.~w/~w-~w', [Part1, Part2, Part3, Part4, Part5]).


getActuation(Actuation) :-
    write("Digite a área de atuação da empresa: "),
    read_line_to_string(user_input, Input),
    (string_length(Input, Length), Length > 29 ->
        writeln("\nAviso: A área de atuação da empresa deve ter no máximo 29 caracteres."),
        getActuation(Actuation)
    ;
        Actuation = Input
    ).


getDeclaration(Declaration) :-
    write("Digite a declaração de missão da empresa: "),
    read_line_to_string(user_input, Input),
    (string_length(Input, Length), Length > 86 ->
        writeln("\nAviso: A declaração de missão da empresa deve ter no máximo 86 caracteres."),
        getDeclaration(Declaration)
    ;
        Declaration = Input
    ).


getCode(Code) :-
    write("Digite o código da ação (deve seguir o modelo VALE3): "),
    read_line_to_string(user_input, Input),
    (string_length(Input, Length), Length \= 5 ->
        writeln("\nAviso: O código da ação deve possuir 5 caracteres."),
        getCode(Code)
    ;
    existCompanyByCode(Input) ->
        writeln("\nAviso: A empresa já foi cadastrada."),
        getCode(Code)
    ;
        upcase_atom(Input, UpperCode),
        Code = UpperCode
    ).