% Adiciona a uma string uma quantidade de caracteres vazios à esquerda, baseado no limite fornecido e o tamanho da string.
fillLeft(Val, Limit, R) :-
    string_length(Val, Len),
    Void is max(0, (Limit - Len)),
    replicate(Val, Void, R).

max(X, Y, X) :- X >= Y.
max(X, Y, Y) :- X < Y.

replicate(Val, 0, Val).
replicate(Val, N, Result) :-
    N > 0,
    N1 is N - 1,
    string_concat(" ", Val, R),
    replicate(R, N1, Result).


% Adiciona a uma string uma quantidade de caracteres vazios à direita
fillRight(Val, 0, Val).
fillRight(Val, N, Result) :-
    N > 0,
    N1 is N - 1,
    string_concat(Val, " ", R),
    fillRight(R, N1, Result).


% Reseta um menu para o sprite original
resetMenu(Target, OriginalPath) :-
    open(Target, write, StreamTarget),
    open(OriginalPath, read, StreamOriginal),
    copy_stream_data(StreamOriginal, StreamTarget),
    close(StreamTarget),
    close(StreamOriginal).


% Formata, a partir do tamanho do nome, a coluna na qual o nome será escrito
getCompanyNameCol(Name, Col, R) :-
    string_length(Name, Len),
    R is (Col - ((Len - 1) // 2)).


% Formata as casas decimais de um número para uma
format(Num, R) :-
    format(atom(Formated), '~1f', [Num]),
    atom_number(Formated, R).