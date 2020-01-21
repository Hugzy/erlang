-module(day5).
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
    io:fwrite("~p \n", [Atom]),
    Atom;
print(List) when is_list(List) ->
    io:fwrite("variable: ~128p~n", [List]),
    List;
print(Integer) when is_integer(Integer) ->
    io:fwrite("~p \n", [Integer]),
    Integer.
print(Text, Atom) when is_atom(Atom) ->
    io:fwrite("~p: ~p \n", [Text, Atom]),
    Atom;
print(Text, Atom) when is_integer(Atom) ->
    io:fwrite("~p: ~p \n", [Text, Atom]),
    Atom;
print(Text, List) when is_list(List) ->
    io:fwrite("~p: ~128p~n", [Text, List]),
    List.

% Adds two inputs
operation(1, Left, Right) ->
    Left + Right;
% Multiplies two integers
operation(2, Left, Right) ->
    Left * Right;
% outputs the value of its only parameter
operation(4, Input, List) ->
    not_implemented.
% takes a single integer as input and saves it to the position given by its only parameter
operation(3, Input, Position, List) ->
    not_implemented.

insert(Place, Element, List) ->
    lists:sublist(List, Place) ++
	       [Element] ++ lists:nthtail(Place + 1, List).

get_as(variables, List, Iteration) ->
    Start = Iteration * 4 + 2,
    lists:sublist(List, Start, 3);
get_as(op_code, List, Iteration) ->
    Start = Iteration * 4 + 1,
    lists:sublist(List, Start, 1).

padding(Integer) when Integer div 10000 == 1 ->
    "";
padding(Integer) when Integer div 1000 == 1 ->
    "0";
padding(Integer) when Integer div 100 == 1 ->
    "00";
padding(Integer) when Integer div 10 == 1 ->
    "000";
padding(Integer) when Integer div 1 >= 1 ->
    "0000".


convert_int_to_opcodelist(Integer) when Integer div 10000 == 1 ->
    print("divisible by 10000", Integer),
    Stringed = integer_to_list(Integer),
    [First, Second | Rest] = lists:reverse([list_to_integer([Char]) || Char <- Stringed]),
    % Because the list was reversed beforehand the opcode is now in reverse order, thus we concat second onto first
    Code = [list_to_integer(string:concat(integer_to_list(Second), integer_to_list(First)))],
    Code ++ Rest;
convert_int_to_opcodelist(Integer) when Integer div 1000 == 1 ->
    print("divisible by 1000", Integer),
    Stringed = string:concat("0", integer_to_list(Integer)),
    [First, Second | Rest] = lists:reverse([list_to_integer([Char]) || Char <- Stringed]),
    % Because the list was reversed beforehand the opcode is now in reverse order, thus we concat second onto first
    Code = [list_to_integer(string:concat(integer_to_list(Second), integer_to_list(First)))],
    Code ++ Rest;
convert_int_to_opcodelist(Integer) when Integer div 100 == 1 ->
    print("divisible by 100", Integer),
    Stringed = string:concat("00", integer_to_list(Integer)),
    Intermediary = [list_to_integer([Char]) || Char <- Stringed],
    [First, Second | Rest] = lists:reverse(Intermediary),
    % Because the list was reversed beforehand the opcode is now in reverse order, thus we concat second onto first
    Code = [list_to_integer(string:concat(integer_to_list(Second), integer_to_list(First)))],
    Code ++ Rest;
convert_int_to_opcodelist(Integer) when Integer div 10 == 1 ->
    print("divisible by 10", Integer),
    Stringed = string:concat("000", integer_to_list(Integer)),
    [First, Second | Rest] = lists:reverse([list_to_integer([Char]) || Char <- Stringed]),
    % Because the list was reversed beforehand the opcode is now in reverse order, thus we concat second onto first 
    Code = [list_to_integer(string:concat(integer_to_list(Second), integer_to_list(First)))],
    Code ++ Rest;
convert_int_to_opcodelist(Integer) when Integer div 1 >= 1 ->
    print("divisible by 1", Integer),
    Stringed = string:concat("0000", integer_to_list(Integer)),
    Intermediary = [list_to_integer([Char]) || Char <- Stringed],
    [First, Second | Rest] = lists:reverse(Intermediary),
    % Because the list was reversed beforehand the opcode is now in reverse order, thus we concat second onto first 
    Code = [list_to_integer(string:concat(integer_to_list(Second), integer_to_list(First)))],
    Code ++ Rest.

loop(99, Data, _) -> 
    Data;
loop(Code, List, Iteration) ->
    CodeList = convert_int_to_opcodelist(Code),
    print("CodeList", CodeList),

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

test_data(v1) -> [1002,4,3,4].

boot_strap(Data) ->
    Start = 0,
    [OpCode | _] = get_as(op_code, Data, Start),
    print("opcode", OpCode),
    loop(OpCode, Data, Start).


test_int_to_opcodelist() ->
    I1 = 02,
    I10 = 11,
    I100 = 102,
    I1000 = 1002,
    I10000 = 10002,

    [02, 0, 0, 0] = print("I1", convert_int_to_opcodelist(I1)),
    [11, 0, 0, 0] = print("I10", convert_int_to_opcodelist(I10)),
    [02, 1, 0, 0] = print("I100", convert_int_to_opcodelist(I100)),
    [02, 0, 1, 0] = print("I1000", convert_int_to_opcodelist(I1000)),
    [02, 0, 0, 1] = print("I10000", convert_int_to_opcodelist(I10000)),
    ok.


test() ->
    test_int_to_opcodelist(),
    ok.

main1() ->
    Data = boot_strap(data()),
    print(Data).% Insert the result into the list of elements

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
