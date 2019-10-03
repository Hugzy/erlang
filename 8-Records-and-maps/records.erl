-module(records).
-record(name,{firstname, lastname}).
-export([test/0, print_record/1]).

test() -> 
    ok.

print_record(#name{firstname=F, lastname=L} = N) when is_record(N, name) ->
    erlang:display(F),
    erlang:display(L),
    N1 = N#name{firstname=frederik, lastname=madsen},
    erlang:display(N1#name.firstname),
    erlang:display(N1#name.lastname),
    ok.
