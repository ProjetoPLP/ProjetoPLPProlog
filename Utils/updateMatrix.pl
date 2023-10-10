printMatrix(NomeArquivo) :-
    open(NomeArquivo, read, Stream),
    printLines(Stream),
    close(Stream).

printLines(Stream) :-
    \+ at_end_of_stream(Stream),
    read_line_to_string(Stream, Linha),
    write(Linha), nl, % Imprime a linha
    printLines(Stream).

printLines(_).






writeMatrixValue(Arquivo, Linha, Coluna, NovoValor) :-
    leia_arquivo(Arquivo, Linhas),
    substitua_valor(Linha, Coluna, NovoValor, Linhas, NovaLista),
    gravar_arquivo(Arquivo, NovaLista).


leia_arquivo(Arquivo, Linhas) :-
    open(Arquivo, read, Stream),
    leia_linhas(Stream, Linhas),
    close(Stream).

leia_linhas(Stream, []) :-
    at_end_of_stream(Stream), !.
leia_linhas(Stream, [Linha|Resto]) :-
    read_line_to_codes(Stream, Linha),
    leia_linhas(Stream, Resto).

substitua_valor(Linha, Coluna, NovoValor, ListaOriginal, NovaLista) :-
    substitua_valor_na_linha(Linha, Coluna, NovoValor, ListaOriginal, 1, NovaLista).

substitua_valor_na_linha(_, _, _, [], _, []).
substitua_valor_na_linha(Linha, Coluna, NovoValor, [L|Resto], N, [LinhaSubstituida|RestoSubstituido]) :-
    N =:= Linha,
    substitua_na_coluna(Coluna, NovoValor, L, LinhaSubstituida),
    N1 is N + 1,
    substitua_valor_na_linha(Linha, Coluna, NovoValor, Resto, N1, RestoSubstituido).
substitua_valor_na_linha(Linha, Coluna, NovoValor, [L|Resto], N, [L|RestoSubstituido]) :-
    N \= Linha,
    N1 is N + 1,
    substitua_valor_na_linha(Linha, Coluna, NovoValor, Resto, N1, RestoSubstituido).


substitua_na_coluna(Coluna, NovoValor, ListaOriginal, ListaSubstituida) :-
    substitua_na_coluna(Coluna, NovoValor, ListaOriginal, ListaSubstituida, 1).

substitua_na_coluna(_, _, [], [], _).
substitua_na_coluna(Coluna, NovoValor, [C|Resto], [NovoValor|RestoSubstituido], N) :-
    N =:= Coluna,
    N1 is N + 1,
    substitua_na_coluna(Coluna, NovoValor, Resto, RestoSubstituido, N1).
substitua_na_coluna(Coluna, NovoValor, [C|Resto], [C|RestoSubstituido], N) :-
    N \= Coluna,
    N1 is N + 1,
    substitua_na_coluna(Coluna, NovoValor, Resto, RestoSubstituido, N1).


gravar_arquivo(Arquivo, Linhas) :-
    open(Arquivo, write, Stream),
    maplist(escreva_linha(Stream), Linhas),
    close(Stream).

escreva_linha(Stream, Linha) :-
    maplist(put_code(Stream), Linha),
    nl(Stream).






main :-
    writeMatrixValue("../Sprites/Wallet/wallet_base.txt", 5, 3, "t").
    % imprimir_arquivo("../Sprites/Wallet/wallet_base.txt").