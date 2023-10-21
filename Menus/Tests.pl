%%
%
%   Adicionar abaixo consultas de arquivos para testes
%
%%
:- consult('../Models/Client/RealizarLogin.pl').
:- consult('../Models/Client/GetSetAttrsClient.pl').


% Adicionar à função chamadas para métodos. Executar pelo terminal com:
%
%   swipl -q -f Tests.pl
%
% dentro do diretório e chamar a função 'main.'
main :-
    fazerLogin(R), halt.
