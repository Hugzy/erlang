-module(lcg).
-export([main/0]).


lcg(A, C, M, L) ->
    Xi = (A * lcg(A, C, M, L) + C) rem M,
    Ri = Xi / M,
    Ri.

lcg(A, C, M, [], 10000) ->
    Xi = (A *  + C) rem M,
    Ri = Xi / M,
    Ri.

main() ->
    [lcg(101427, 321, 65536, [X]) || X <- rand:uniform(10)].