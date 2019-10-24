-module(b).
-export([main/0]).

main() ->
    {A, B} = a:make_text(),
    is_atom(A),
    erlang:display(A),
    erlang:display(B),
    ok.

