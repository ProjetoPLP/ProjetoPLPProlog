:- use_module(library(http/json)).
:- consult('ModelClock.pl').

lerJSON(FilePath, File) :-
	open(FilePath, read, F),
	json_read_dict(F, File).

getClock(JsonFilePath, Minutes) :- 
    open(JsonFilePath, read, F),
    json_read_dict(F, Clock),
    Minutes is Clock.minutes.

saveClock(Minutes) :- 
    clockToJSON(Minutes, Saida),
    open('../../Data/Clock.json', write, Stream),
    write(Stream, Saida),
    close(Stream).

clockToJSON(Minutes, Out) :- 
    swritef(Out, '{"minutes": %w}', [Minutes]).

addClock(Value) :- 
    getClock('../../Data/Clock.json', MinutesAtual),
    NovoTempo is MinutesAtual + Value,
    saveClock(NovoTempo).

setClock(Value) :- 
    saveClock(Value).

