is_list_of_numbers(List) :-
    list_to_string(List, String),
    string_contains_only_digits(String).

string_contains_only_digits(String) :-
    string_chars(String, Chars),
    maplist(char_type_number, Chars).

char_type_number(Char) :-
    char_type(Char, digit).

list_to_string([], '').
list_to_string([H|T], String) :-
    atom_string(H, Atom),
    list_to_string(T, Rest),
    string_concat(Atom, Rest, String).

