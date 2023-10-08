getEmail(Email) :-
    write('Digite o seu email: '),
    flush_output(current_output),
    read_line_to_string(user_input, Email).

getPassword(Password) :-
    write('Digite a sua senha: '),
    flush_output(current_output),
    read_line_to_string(user_input, Password).
