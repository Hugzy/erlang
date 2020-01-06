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

print(Atom) when is_atom(Atom) ->
    io:fwrite("~p \n", [Atom]);
print(List) when is_list(List) ->
    io:fwrite("variable: ~128p~n", [List]);
print(Integer) when is_integer(Integer) ->
    io:fwrite("~p \n", [Integer]).
print(Text, Atom) when is_atom(Atom) ->
    io:fwrite("~p: ~p \n", [Text, Atom]);
print(Text, Atom) when is_integer(Atom) ->
    io:fwrite("~p: ~p \n", [Text, Atom]);
print(Text, List) when is_list(List) ->
    io:fwrite("~p: ~128p~n", [Text, List]).

operation(1, Left, Right) ->
    Result = Left + Right,
    print("Result: ", Result),
    Result;
operation(2, Left, Right) ->
    Result = Left * Right,
    print("Result", Result),
    Result.


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
    print("storing element", Element),
    print("in place", Place),
    lists:sublist(List, Place) ++
      [Element] ++ lists:nthtail(Place + 1, List).

create_element(0, _, Var1, Var2, Storage, Result) ->
    {Result, Var1, Var2, Storage};
create_element(1, OpCode, _, Var2, Storage, Result) ->
    {Result, Result, Var2, Storage};
create_element(2, OpCode, Var1, _, Storage, Result) ->
    {Result, Var1, Result, Storage};
create_element(3, OpCode, Var1, Var2, _, Result) ->
    {Result, Var1, Var2, Result}.

get(_, 0) ->
    [];
%get([H | _], _) when H == 99 ->
%    H;
get([H | T], Count) ->
    print(Count),
    [H | get(T, Count-1)].
    

loop(99, _, All_Data) ->
    print("exit", 99),
    All_Data;
loop(Code, [H1, H2, H3 | T], All_Data) ->
    print("Elements", [Code, H1, H2, H3]),
    % Get next three elements and the opcode as input parameter
    % If the execution gets into this function we can just perform the operation because it would have hit the exit first otherwise
    Result = operation(Code, H1, H2),
    New_list = insert(H3, Result, All_Data),
    % keep looping
    [OpCode | Tail_Without_Opcode] = T,
    loop(OpCode, Tail_Without_Opcode, New_list).


% result should be [11, 1, 1, 4, 1, 5, 6, 99]
test_data(v1) -> [1, 1, 1, 4, 99, 5, 7, 0, 99];
test_data(v2) -> [1,1,1,0,99].

test() ->
    %[Seed | Tail] = test_data(v2),
    %Data = loop(Seed, Tail, test_data(v2)),
    %print(Data),

    [Seed2 | Tail2] = test_data(v1),
    Data2 = loop(Seed2, Tail2, test_data(v1)),
    print(Data2),

    ok.

main() -> fill(test_data(v2)).
% Insert the result into the list of elements

