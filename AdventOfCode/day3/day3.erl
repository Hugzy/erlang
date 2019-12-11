-module(day3).
-export([]).
-compile([export_all]).

start() ->
    [{point, 0,0}].

test_data_1() ->
    "R75,D30,R83,U83,L12,D49,R71,U7,L72,U62,R66,U55,R34,D71,R55,D58,R83".

test_data_2() ->
    "R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51,U98,R91,D20,R16,D67,R40,U7,R15,U6,R7".

get_data(Data) ->
    string:tokens(Data, ",").

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
    {line, {point, Lx1, Ly1}, {point, Lx2, Ly2}} = Line,
    {point, Px, Py} = Point,
    ((Px =< max(Lx1, Lx2)) and (Px =< min(Lx1, Lx2)) and ((Py =< max(Ly1, Ly2)) and (Py =< min(Ly1, Ly2)))).

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

    % Get the direction identifier based on the value calculated
    direction_identifier(Val).

comput_intersection(Dir1, Dir2, Dir3, Dir4) when Dir1 /= Dir2 andalso Dir3 /= Dir4 ->
    true.

isOnLine(Dir1, OnLine) when Dir1 == 0 andalso OnLine ->
    true;
isOnLine(Dir2, OnLine) when Dir2 == 0 andalso OnLine ->
    true;
isOnLine(Dir3, OnLine) when Dir3 == 0 andalso OnLine ->
    true;
isOnLine(Dir4, OnLine) when Dir4 == 0 andalso OnLine ->
    true;
isOnLine(_, _) ->
    false.

isIntersect(L1, L2) ->
    {line, P1 , P2} = L1,
    {line, P3, P4} = L2,
    Dir1 = direction(P1, P2, P3),
    Dir2 = direction(P1, P2, P4),
    Dir3 = direction(P3, P4, P1),
    Dir4 = direction(P3, P4, P2),

    comput_intersection(Dir1, Dir2, Dir3, Dir4) or isOnLine(Dir1, (onLine(L1, P3))) or isOnLine(Dir2, (onLine(L1, P4))) or isOnLine(Dir3, (onLine(L2, P1))) or isOnLine(Dir4, (onLine(L2, P2))).

group([H|T]) when length(T) > 0 ->
    [H1|_] = T,
    [{line, H, H1}|group(T)];
group(_) ->
    [].


test() ->
    %List1 = convert(string:tokens(test_data_1(), ",")),
    %print({list, List1}),
    %Results1 = loop(List1, start()),
    %print({list, Results1}),
    %List2 = convert(string:tokens(test_data_2(), ",")),
    %print({list, List2}),
    %Results2 = loop(List2, start()),
    %print({list, Results2}),

    Results1 = loop(convert(get_data(test_data_1())), start()),
    Results2 = loop(convert(get_data(test_data_2())), start()),
    print({list, Results1}),
    print({list, Results2}),

    Lines1 = group(Results1),
    Lines2 = group(Results2),



    print({list, Lines1}),
    print({list, Lines2}),


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

