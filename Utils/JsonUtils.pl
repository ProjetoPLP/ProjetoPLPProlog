:- module(jsonUtils, [lerJSON/2, readFileTxt/2]).

:- use_module(library(http/json)).


lerJSON(JSONPath, File) :-
	open(JSONPath, read, Stream),
	json_read_dict(Stream, File),
    close(Stream).


readFileTxt(FilePath, Text) :-
    open(FilePath, read, Stream),
    read_stream_to_codes(Stream, TextCodes),
    close(Stream),
    string_codes(Text, TextCodes).