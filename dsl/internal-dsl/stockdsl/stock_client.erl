-module(stock_client).
-export([]).
-compile([export_all]).

print(Atom) when is_atom(Atom) ->
    io:fwrite("~p \n", [Atom]),
    Atom;
print(List) when is_list(List) ->
    io:fwrite("variable: ~128p~n", [List]),
    List;
print(Integer) when is_integer(Integer) ->
    io:fwrite("~p \n", [Integer]),
    Integer.
print(Text, Atom) when is_atom(Atom) ->
    io:fwrite("~p: ~p \n", [Text, Atom]),
    Atom;
print(Text, Atom) when is_integer(Atom) ->
    io:fwrite("~p: ~p \n", [Text, Atom]),
    Atom;
print(Text, List) when is_list(List) ->
    io:fwrite("~p: ~128p~n", [Text, List]),
    List.


% action {
%   operation
%   conditions[...]
%   cycles[{
%       conditions[...]
%       }]
%   OnEvents[...]
%

action(sell, Amount) ->
    {action, sell, Amount};
action(buy, Amount) ->
    {action, buy, Amount};
action(list, _) ->
    {action, list}.
condition(gtn, Amount) ->
    {condition, gtn, Amount};
condition(lsn, Amount) ->
    {condition, lsn, Amount};
condition(eq, Amount) ->
    {condition, eq, Amount};
condition(lsneq, Amount) ->
    {condition, lsneq, Amount};
condition(gtneq, Amount) ->
    {condition, gtneq, Amount}.
iteration(I) ->
    {iteration, I}.
on_event() ->
    not_implemented.

run(Server, []) ->
    exit;
run(Server, [{action, sell, Amount}|_]) ->
    print("sending msg"),
    Server ! {self(), {sell, Amount}},
    receive
        {Server, SoldAmount} ->
            print("receiving msg"),
            print("client", SoldAmount)
    end.

test() ->
    ok.

main(Server) ->
    run(Server, [
        action(sell, 2),
        action(sell, 3),
        action(sell,5)
    ]).