:- consult('SaveClient.pl').
:- dynamic user/5.
:- dynamic user/5.

getName(Name) :-
    write('Digite o seu nome: '),
    flush_output(current_output),
    read_string(user_input, "\n", "\r", _, NameStr),
    (string_length(NameStr, Length), Length > 18 ->
        writeln('\nAviso: O nome do usuário deve ter no máximo 18 caracteres.'),
        getName(Name);
     true),
    Name = NameStr.

getAge(Age) :-
    write('Digite a sua idade: '),
    flush_output(current_output),
    read_string(user_input, "\n", "\r", _, AgeStr),
    (not(number_chars(Age, AgeStr)) ->
        writeln('\nAviso: A idade deve possuir apenas números.'),
        getAge(Age);
    number_chars(AgeNum, AgeStr), AgeNum < 18 ->
    writeln('\nAviso: proibido menores de 18 anos.'),
    getAge(Age);
    true),
    Age = AgeNum.
    
getCPF(CPF) :-
    write('Digite o seu CPF (apenas números, 11 dígitos): '),
    flush_output(current_output),
    read_line_to_string(user_input, CPFStr),
    (not(number_chars(_, CPFStr)) ->
        writeln('\nAviso: o CPF deve possuir apenas números.'),
        getCPF(CPF);
    string_length(CPFStr, CPFLength), CPFLength \= 11 ->
        writeln('\nAviso: O CPF não contém 11 dígitos.'),
        getCPF(CPF);
    true,
    formatCPF(CPFStr, CPF)).
    
formatCPF(CPFStr, FormattedCPF) :-
    sub_string(CPFStr, 0, 3, _, Part1),
    sub_string(CPFStr, 3, 3, _, Part2),
    sub_string(CPFStr, 6, 3, _, Part3),
    sub_string(CPFStr, 9, _, 0, Part4),
    format(string(FormattedCPF), '~w.~w.~w-~w', [Part1, Part2, Part3, Part4]).

getEmail(Email) :-
    write('Digite o seu e-mail: '),
    flush_output(current_output),
    read_line_to_string(user_input, EmailStr),
    (existClientByEmail(EmailStr, false) -> 
        Email = EmailStr;
    writeln('\nAviso: O e-mail já foi cadastrado.'),
    getEmail(Email)).
    
getPassword(Password) :-
    write('Digite a sua senha: '),
    flush_output(current_output),
    read_string(user_input, "\n", "\r", _, PasswordStr),
    (string_length(PasswordStr, Length), Length < 5 ->
        writeln('\nAviso: A senha deve ter no mínimo 5 dígitos.'),
        getPassword(Password);
    true),
    Password = PasswordStr.

