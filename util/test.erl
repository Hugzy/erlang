-module(test).
-export([merge/2]).
-compile([export_all]).

test() ->
    ok.

main() ->
    ok.

merge([],[]) ->
    [];
merge([], L) ->
    L;
merge(L, [])->
    L;
merge([H1|T1], [H2|T2]) when H2 > H1 ->
    [H1| merge(T1,[H2|T2])];
merge([H1|T1], [H2|T2]) when H1 >= H2 ->
    [H2| merge([H1|T1],T2)].