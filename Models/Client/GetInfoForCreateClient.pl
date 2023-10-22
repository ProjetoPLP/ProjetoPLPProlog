:- consult('../../Utils/VerificationUtils.pl').
:- consult('./SaveClient.pl').


getClientName(Name) :-
    write("Digite o seu nome: "),
    read_line_to_string(user_input, Input),
    (string_length(Input, Length), Length > 18 ->
        writeln("\nAviso: O nome do usuário deve ter no máximo 18 caracteres."),
        getClientName(Name)
    ;
        Name = Input
    ).


getAge(Age) :-
    write("Digite a sua idade: "),
    read_line_to_string(user_input, Input),
    (\+ isNumber(Input) ->
        writeln("\nAviso: A idade deve possuir apenas números."),
        getAge(Age)
    ;
    atom_number(Input, AgeNum), AgeNum < 18 ->
        writeln("\nAviso: proibido menores de 18 anos."),
        getAge(Age)
    ; 
        Age = Input
    ).
    

getCPF(CPF) :-
    write("Digite o seu CPF (apenas números, 11 dígitos): "),
    read_line_to_string(user_input, Input),
    (\+ isNumber(Input) ->
        writeln("\nAviso: o CPF deve possuir apenas números."),
        getCPF(CPF)
    ;
    string_length(Input, Length), Length =\= 11 -> 
        writeln("\nAviso: O CPF não contém 11 dígitos."),
        getCPF(CPF)
    ;
        formatCPF(Input, FormattedCPF),
        CPF = FormattedCPF
    ).
    

formatCPF(CPF, FormattedCPF) :-
    sub_string(CPF, 0, 3, _, Part1),
    sub_string(CPF, 3, 3, _, Part2),
    sub_string(CPF, 6, 3, _, Part3),
    sub_string(CPF, 9, _, 0, Part4),
    format(string(FormattedCPF), '~w.~w.~w-~w', [Part1, Part2, Part3, Part4]).


getEmail(Email) :-
    write("Digite o seu e-mail: "),
    flush_output(current_output),
    read_line_to_string(user_input, Input),
    (existClientByEmail(Input) -> 
        writeln("\nAviso: O e-mail já foi cadastrado."),
        getEmail(Email)
    ;
        Email = Input
    ).


getPassword(Password) :-
    write("Digite a sua senha: "),
    read_line_to_string(user_input, Input),
    (string_length(Input, Length), Length < 5 ->
        writeln("\nAviso: A senha deve ter no mínimo 5 dígitos."),
        getPassword(Password)
    ;
        Password = Input
    ).