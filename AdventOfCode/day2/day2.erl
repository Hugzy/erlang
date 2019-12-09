-module(day2).
-export([]).
-record(registrar,{opcode, var1, var2, storage}).
-compile(export_all).


op_code_add() -> 1.
op_code_multiply() -> 2.
op_code_exit() -> 99.
stepper() -> 4.



data() ->
    [].

test_data() ->
    [1,1,1,4,99,5,6,0,99].
    %[1,1,1,4,99].

print({atom, Text, Atom}) ->
    io:fwrite("~p: ~p \n", [Text, Atom]);
    %io:format("variable: ~p", [Atom]);
print({list, List}) ->
    io:fwrite("list: ~w~n \n", [List]).

add(Left, Right) ->
    Result = Left + Right,
    print({atom, "Result: ", Result}),
    Result.

multiply(Left, Right) ->
    Result =Left * Right,
    print({atom, "Result", Result}),
    Result.



test() ->
    ok.

num(L) ->
    length([X || X <- L, X < 1]).

insert(Place, Element, List) ->
    lists:sublist(List, (Place - 1)) ++ [Element] ++ lists:nthtail(Place + 1,List).


loop() ->
    ok.

main() ->
    ok.

% Read the OpCode from a list
% Check if we need to stop (OpCode == 99) or we need to do an operation(OpCode == 1 && 2)
% Perform that given operation on var2 and var3 from the list
% Insert the result into the list of elements