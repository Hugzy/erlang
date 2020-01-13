-module(day2).
-export([]).
-compile(export_all).

data() ->
    [1, 12, 2, 3, 1, 1, 2, 3, 1, 3, 4, 3, 1, 5, 0, 3, 2, 10,
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
    Left + Right;
operation(2, Left, Right) ->
    Left * Right.

insert(Place, Element, List) ->
    lists:sublist(List, Place) ++
	       [Element] ++ lists:nthtail(Place + 1, List).

get_as(variables, List, Iteration) ->
    Start = Iteration * 4 + 2,
    lists:sublist(List, Start, 3);
get_as(op_code, List, Iteration) ->
    Start = Iteration * 4 + 1,
    lists:sublist(List, Start, 1).

loop(99, Data, _) -> 
    %print("exit", 99), 
    Data;
loop(Code, List, Iteration) ->
    [Index1, Index2, Storing_position] = get_as(variables, List, Iteration),
    % Get next three elements and the opcode as input parameter
    % If the execution gets into this function we can just perform the operation because it would have hit the exit first otherwise
    % Adding 1 to the index because some retard made lists:nth not 0 index based.
    Value1 = lists:nth(Index1+1, List),
    Value2 = lists:nth(Index2+1, List),
    Result = operation(Code, Value1, Value2),
    New_list = insert(Storing_position, Result, List),
    [OpCode | _] = get_as(op_code, New_list, Iteration + 1),
    % There is a problem because only the resulting list is updated and not the executing list
    loop(OpCode, New_list, Iteration + 1).

for(0, _, _) -> 
   [];
for(N,Term, Fun) when N > 0 -> 
    Fun(N),
    [Term|for(N-1,Term, Fun)]. 

noun(Iter, Data) ->
    for(Iter,0, fun(N) -> verb(Iter, N, Data) end),
    ok.
verb(Iter, OuterCycle, Data) ->
    for(Iter,0, fun(InnerCycle) -> 
        %print("Loop Cycle:", [OuterCycle, InnerCycle]),
        Start = 0,
        NewData = insert(2, OuterCycle, (insert(1, InnerCycle, Data))),
        %print("NewData", NewData),
        [OpCode | _] = get_as(op_code, NewData, Start),
        Data2 = loop(OpCode, NewData, Start),
        [H, Noun, Verb | T] = Data2,
        output_result(H, Noun, Verb, T)
     end),
    ok.

test_data(v1) -> [1,0,0,0,99];
test_data(v2) -> [2,3,0,3,99];
test_data(v3) -> [2,4,4,5,99,0];
test_data(v4) -> [1,1,1,4,99,5,6,0,99].

test() ->
    Start = 0,

    [OpCode1 | _] = get_as(op_code, test_data(v1), Start),
    [2,0,0,0,99] = loop(OpCode1, test_data(v1), Start),
    
    [OpCode2 | _] = get_as(op_code, test_data(v2), Start),
    [2,3,0,6,99] = loop(OpCode2, test_data(v2), Start),
    
    [OpCode3 | _] = get_as(op_code, test_data(v3), Start),
    [2,4,4,5,99,9801] = loop(OpCode3, test_data(v3), Start),
    
    [OpCode4 | _] = get_as(op_code, test_data(v4), Start),
    [30,1,1,4,2,5,6,0,99] = loop(OpCode4, test_data(v4), Start),
    ok.

test2() ->
    print("hello?"),
    noun(2, test_data(v1)).

main1() ->
    Start = 0,
    [OpCode | _] = get_as(op_code, data(), Start),
    Data2 = loop(OpCode, data(), Start),
    print(Data2).% Insert the result into the list of elements

output_result(19690720, Noun, Verb, Rest) ->
    print("Result: ", 19690720),
    shell:strings(false),
    print("Noun, Verb", [Noun, Verb]),
    shell:strings(true),
    print("Final result: ", (100*Noun+Verb));
output_result(3562624, Noun, Verb, Rest) ->
    print("Result", 3562624),
    print("Final result: ", (100*Noun+Verb)),
    print(Rest);
output_result(_,_,_,_) ->
    nothing.

main2() ->
    noun(99, data()).
