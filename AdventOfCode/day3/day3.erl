-module(day3).
-export([]).
-compile([export_all]).

start() ->
    [{point, 0,0}].

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
    {point, X1+Length, Y1};
calculate('L', Length, {point, X1, Y1}) ->
    {point, X1-Length, Y1};
calculate('U', Length, {point, X1, Y1}) ->
    {point, X1, Y1+Length};
calculate('D', Length, {point, X1, Y1}) ->
    {point, X1, Y1-Length}.

onLine(Line, Point) ->
   %if(p.x <= max(l1.p1.x, l1.p2.x) && p.x <= min(l1.p1.x, l1.p2.x) &&
   %   (p.y <= max(l1.p1.y, l1.p2.y) && p.y <= min(l1.p1.y, l1.p2.y)))
   %   return true;
   %return false;

   


direction_identifier(Identifier) when Identifier == 0 ->
    0;
direction_identifier(Identifier) when Identifier > 0 ->
    1;
direction_identifier(Identifier) when Identifier < 0 ->
    2.

direction(A, B, C) ->
    {point, Ax, Ay} = A,
    {point, Bx, By} = B,
    {point, Cx, Cy} = C,
    % Based on this
    %int val = (b.y-a.y)*(c.x-b.x)-(b.x-a.x)*(c.y-b.y);
    Val = (By-Ay)*(Cx-Bx)-(Bx-Ax)*(Cy-By),

    direction_identifier(Val).


test() ->
    %List1 = convert(string:tokens(test_data_1(), ",")),
    %print({list, List1}),
    %Results1 = loop(List1, start()),
    %print({list, Results1}),
    %List2 = convert(string:tokens(test_data_2(), ",")),
    %print({list, List2}),
    %Results2 = loop(List2, start()),
    %print({list, Results2}),

    P1 = {point, 0, 0},
    P2 = {point, 5, 5},
    P3 = {point, 2,-10},
    P4 = {point, 3, 10},
    Dir1 = direction(P1, P2, P3),
    Dir2 = direction(P1, P2, P4),
    Dir3 = direction(P3, P4, P1),
    Dir4 = direction(P3, P4, P2),

    print({list, [Dir1, Dir2, Dir3, Dir4]}),

    ok.

loop([{Direction, Length}|T], Results) ->
    [M|U] = Results,
    % Adding newly calculated result to the list of results
    loop(T, [calculate(Direction, Length, M) | Results]);
loop(List, Results) when length(List) == 0 ->
    Results.

main() -> ok.

% Map the data to a tuple of direction and length
% Recursively step through the lists of directions and compute the next location for the two heads
% See if they match, if they do commit that result to storage
% at the end lookup all the results from the storage, find the closest one two origin via the manhatten distance

