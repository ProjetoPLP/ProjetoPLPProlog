:- module(matrixUtils, [printMatrix/1, writeMatrixValue/4]).


% Printa no terminal o conteúdo do arquivo .txt
printMatrix(NomeArquivo) :-
    write('\e[H\e[2J'),
    open(NomeArquivo, read, Stream),
    repeat,
    (   read_line_to_string(Stream, Linha),
        (   Linha == end_of_file
        ->  true
        ;   writeln(Linha),
            fail
        )
    ),
    close(Stream).


% Sobrescreve no arquivo .txt um novo valor
writeMatrixValue(Arquivo, Valor, Linha, Coluna) :-
    string_chars(Valor, CharList),
    writeValue(Arquivo, Linha, Coluna, CharList).
    

writeValue(_, _, _, []) :- !.
writeValue(Arquivo, Linha, Coluna, [H|T]) :-
    leia_arquivo(Arquivo, Linhas),
    substitua_valor(Linha, Coluna, H, Linhas, NovaLista),
    gravar_arquivo(Arquivo, NovaLista),
    C1 is Coluna + 1,
    writeValue(Arquivo, Linha, C1, T).

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
substitua_na_coluna(Coluna, NovoValor, [_|Resto], [NovoValor|RestoSubstituido], N) :-
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