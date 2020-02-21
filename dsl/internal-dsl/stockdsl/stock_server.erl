-module(stock_server).
%-compile([export_all]).
-export([start/0, loop/1]).

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


stock() -> {10000, 3}.

start() -> spawn(stock_server, loop, [stock()]).

loop({Amount, Value}) ->
  receive
    {Client, {sell, ClientAmount}} ->
        BoughtAmount = (ClientAmount * Value),
        print("Bought Amount", BoughtAmount),
        Client ! {self(), BoughtAmount},
        loop({Amount+ClientAmount, Value});
    {Client, {buy, Amount}} ->
        StockLeft = 10000 - Amount,
        Client ! {self(), Amount},
        loop({StockLeft, Value});
    {Client, current_stock} ->
        Client ! {self(), {Amount,Value}}
  end,
  loop({Amount, Value}).