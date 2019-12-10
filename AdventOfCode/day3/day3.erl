-module(day3).
-export([]).
-compile([export_all]).

storage_1() ->
    [{point, 0,0}].
storage_2() ->
    [{point, 0, 0}].

test_data_1() ->
    "R75,D30,R83,U83,L12,D49,R71,U7,L72,U62,R66,U55,R34,D71,R55,D58,R83".

test_data_2() ->
    "R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51,U98,R91,D20,R16,D67,R40,U7,R15,U6,R7".

print({list, List}) ->
    io:fwrite("list: ~128p~n", [List]).

convert([H | T]) ->
    {Direction, Number} = string:take(H, [$R, $L, $U, $D]),
    {Sanitizednumber, _} = string:to_integer(Number),
    [{list_to_atom(Direction), Sanitizednumber}|convert(T)];
convert(List) when length(List) == 0 -> [].

calculate('R', Length, {point, X1, Y1}) ->
    ok;
calculate('L', Length, {point, X1, Y1}) ->
    ok;
calculate('U', Length, {point, X1, Y1}) ->
    ok;
calculate('D', Length, {point, X1, Y1}) ->
    ok.

test() ->
    List1 = convert(string:tokens(test_data_1(), ",")),
    print({list, List1}),
    List2 = convert(string:tokens(test_data_2(), ",")),
    print({list, List2}),
    ok.

loop([N = {Direction, Length}|T], Results) ->
    [M = {point, X2, Y2}|U] = Results,
    calculate(Direction, Length, M),
    

    ok;
loop(List, _) when length(List) == 0 ->
    [].

main() -> ok.

% Map the data to a tuple of direction and length
% Recursively step through the lists of directions and compute the next location for the two heads
% See if they match, if they do commit that result to storage
% at the end lookup all the results from the storage, find the closest one two origin via the manhatten distance

