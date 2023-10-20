getLoginEmail(Email) :-
    write('Digite o seu email: '),
    flush_output(current_output),
    read_line_to_string(user_input, Email).


getLoginPassword(Password) :-
    write('Digite a sua senha: '),
    flush_output(current_output),
    read_line_to_string(user_input, Password).