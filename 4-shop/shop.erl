-module(shop).
-export([test/0, cost/1, total/1]).
-import([])


test() ->
    5 = cost(oranges),
    8 = cost(newspaper),
    2 = cost(apples),
    9 = cost(pears),
    7 = cost(milk),
    ok.

total([{What, N}|T]) -> shop:cost(What) * N + total(T);
total([]) -> 0.

cost(oranges)   -> 5;
cost(newspaper) -> 8;
cost(apples)    -> 2;
cost(pears)     -> 9;
cost(milk)      -> 7.
