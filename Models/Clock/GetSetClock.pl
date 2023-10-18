:- use_module(library(http/json)).
:- consult('ModelClock.pl').

lerJSON(JSONPath, File) :-
	open(JSONPath, read, F),
	json_read_dict(F, File).

getClock(JSONPath, Minutes) :- 
    open(JSONPath, read, F),
    json_read_dict(F, Clock),
    Minutes is Clock.minutes.

saveClock(JSONPath, Minutes) :- 
    clockToJSON(Minutes, Saida),
    open(JSONPath, write, Stream),
    write(Stream, Saida),
    close(Stream).

clockToJSON(Minutes, Out) :- 
    swritef(Out, '{"minutes": %w}', [Minutes]).

addClock(JSONPath, Value) :- 
    getClock(JSONPath, MinutesAtual),
    NovoTempo is MinutesAtual + Value,
    saveClock(JSONPath, NovoTempo).

setClock(JSONPath, Value) :- 
    saveClock(JSONPath, Value).