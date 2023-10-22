getLoginEmail(Email) :-
    write("Digite o seu email: "),
    read_line_to_string(user_input, Email).


getLoginPassword(Password) :-
    write("Digite a sua senha: "),
    read_line_to_string(user_input, Password).