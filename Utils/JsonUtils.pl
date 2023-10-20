:- use_module(library(http/json)).

lerJSON(JSONPath, File) :-
	open(JSONPath, read, Stream),
	json_read_dict(Stream, File),
    close(Stream).