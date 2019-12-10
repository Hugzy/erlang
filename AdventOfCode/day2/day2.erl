-module(day2).

-export([]).

-record(registrar, {opcode, var1, var2, storage}).

-compile(export_all).

op_code_add() -> 1.

op_code_multiply() -> 2.

op_code_exit() -> 99.

stepper() -> 4.

data() ->
    [1, 0, 0, 3, 1, 1, 2, 3, 1, 3, 4, 3, 1, 5, 0, 3, 2, 10,
     1, 19, 1, 5, 19, 23, 1, 23, 5, 27, 1, 27, 13, 31, 1, 31,
     5, 35, 1, 9, 35, 39, 2, 13, 39, 43, 1, 43, 10, 47, 1,
     47, 13, 51, 2, 10, 51, 55, 1, 55, 5, 59, 1, 59, 5, 63,
     1, 63, 13, 67, 1, 13, 67, 71, 1, 71, 10, 75, 1, 6, 75,
     79, 1, 6, 79, 83, 2, 10, 83, 87, 1, 87, 5, 91, 1, 5, 91,
     95, 2, 95, 10, 99, 1, 9, 99, 103, 1, 103, 13, 107, 2,
     10, 107, 111, 2, 13, 111, 115, 1, 6, 115, 119, 1, 119,
     10, 123, 2, 9, 123, 127, 2, 127, 9, 131, 1, 131, 10,
     135, 1, 135, 2, 139, 1, 10, 139, 0, 99, 2, 0, 14, 0].

test_data() -> [1, 1, 1, 4, 99, 5, 6, 0, 99].

    %[1,1,1,4,99].

print({atom, Text, Atom}) ->
    io:fwrite("~p: ~p \n", [Text, Atom]);
%io:format("variable: ~p", [Atom]);
print({list, List}) ->
    io:fwrite("list: ~w~n \n", [List]).

operation(1, Left, Right) ->
    Result = Left + Right,
    print({atom, "Result: ", Result}),
    Result;
operation(2, Left, Right) ->
    Result = Left * Right,
    print({atom, "Result", Result}),
    Result.

test() ->
    Filled = fill(test_data()), 
    print({list, Filled}),
    loop(Filled, test_data()).

%extract(List) -> 
%    fill(List).

fill([Var1, Var2, Var3, Var4 | T]) ->
    Tuple = {Var1, Var2, Var3, Var4},
    [Tuple | fill(T)];
fill([OpCode | _]) -> 
    Tuple = {OpCode},
    [Tuple].

num(L) -> length([X || X <- L, X < 1]).

insert(Place, Element, List) ->
    lists:sublist(List, Place - 1) ++
      [Element] ++ lists:nthtail(Place + 1, List).

create_element(0, _, Var1, Var2, Storage, Result) ->
    {Result, Var1, Var2, Storage};
create_element(1, OpCode, _, Var2, Storage, Result) ->
    {Result, Result, Var2, Storage};
create_element(2, OpCode, Var1, _, Storage, Result) ->
    {Result, Var1, Result, Storage};
create_element(3, OpCode, Var1, Var2, _, Result) ->
    {Result, Var1, Var2, Result}.

loop([{OpCode, Var1, Var2, Storage}|T], Data) -> 
    print({list, Data}),

    % Caclculate the reuslt
    Result = operation(OpCode, Var1, Var2),

    % Calculate where we need to store the result
    Place = round(Storage/4),
    print({atom, "Place", Place}),
    Spot = Storage rem 4,
    print({atom, "Spot: ", Spot}),
    Tuple = create_element(Spot, OpCode, Var1, Var2, Storage, Result),
    print({atom, "Tuple", Tuple}),
    New_list = insert(Storage, Tuple, Data),

    print({list, New_list}),

    loop(T, New_list);
loop([_|_], Data) ->
    print({atom, "Got here 2?", ""}),
    Data.

main() -> ok.

% Read the OpCode from a list
% Check if we need to stop (OpCode == 99) or we need to do an operation(OpCode == 1 && 2)
% Perform that given operation on var2 and var3 from the list
% Insert the result into the list of elements

