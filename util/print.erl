-module(print).
-export([print/1, print/2]).

print(Atom) when is_atom(Atom) ->
    io:fwrite("~p \n", [Atom]);
print(List) when is_list(List) ->
    io:fwrite("variable: ~128p~n", [List]).
print(Text, Atom) when is_atom(Atom) ->
    io:fwrite("~p: ~p \n", [Text, Atom]).