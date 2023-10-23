:- module(getSetClock, [getClock/1, addClock/1, setClock/1]).

:- use_module(library(http/json)).


getClock(Minutes) :- 
    open("./Data/Clock.json", read, Stream),
    json_read_dict(Stream, Clock),
    close(Stream),
    Minutes is Clock.minutes.

saveClock(Minutes) :- 
    clockToJSON(Minutes, Saida),
    open("./Data/Clock.json", write, Stream),
    write(Stream, Saida),
    close(Stream).

clockToJSON(Minutes, Out) :- 
    swritef(Out, '{"minutes": %w}', [Minutes]).

addClock(Value) :- 
    getClock(MinutesAtual),
    NovoTempo is MinutesAtual + Value,
    saveClock(NovoTempo).

setClock(Value) :- 
    saveClock(Value).