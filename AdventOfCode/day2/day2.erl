-module(day2).
-export([]).
-compile(export_all).


op_code_add() -> 1.
op_code_multiply() -> 2.
op_code_exit() -> 99.

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
    % Test insert functionality
    insert(3, 13456, test_data()).
    
    % Test sublist functionality
    %lists:sublist(test_data(), 3),
    %test_data().
    % ok.

num(L) ->
    length([X || X <- L, X < 1]).

insert(Place, Element, List) ->
    lists:sublist(List, (Place - 1)) ++ [Element] ++ lists:nthtail(Place + 1,List).

% Returns the result of that specific operation.
operation(1, Registry) ->
    [Reg1, Reg2, Reg3] = Registry,
    Res = add(Reg1, Reg2);
    %insert(Reg3, Res, Data);
operation(2, Registry) ->
    [Reg1, Reg2, Reg3] = Registry,
    Res = multiply(Reg1, Reg2);
    %insert(Reg3, Res, Data);
operation(99, Data)->
    print({atom, "operation99", ""}),
    print({list, Data}),
    exit(ok).
    %Data.

loop(List) when is_list(List) andalso length(List) > 0  ->
    [Op_code | Tail] = List,
    Registry = lists:sublist(Tail, 3),
    operation(Op_code, Registry),
    loop(lists:nthtail(4, List));
loop(List) ->
    List.

main() ->
    loop(test_data()).