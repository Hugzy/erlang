-module(day4).
-export([]).
-compile([export_all]).

print({atom, Text, Atom}) ->
    io:fwrite("~p: ~p \n", [Text, Atom]);
print({list, List}) ->
    io:fwrite("list: ~128p~n", [List]).

convert_number_to_list(Number) ->
    Stringed = integer_to_list(Number),
    [list_to_integer([Char]) || Char <- Stringed].

does_not_decrease([Current|Number_list], Previous) when Current >= Previous ->
    does_not_decrease(Number_list, Current);
does_not_decrease([Current|_Number_list], Previous) when Previous > Current ->
    false;
does_not_decrease(List, _Previous) when length(List) == 0 ->
    true.

has_adjacent_numbers([H|Number_list], Previous) when Previous == H ->
    true;
has_adjacent_numbers(List, Previous) when length(List) == 0 ->
    false;
has_adjacent_numbers([H|Number_list], Previous) ->
    has_adjacent_numbers(Number_list, H).

meets_criteria(Number) ->
    Number_list = convert_number_to_list(Number),
    has_adjacent_numbers(Number_list, -1) and does_not_decrease(Number_list , -1).

loop([H | Sequence]) ->
    Meets_criteria = meets_criteria(H),
    if 
        Meets_criteria ->
            [H|loop(Sequence)];
        true ->
            loop(Sequence)
        end;
loop(List) when length(List) == 0 ->
    [].

test() ->
    true = does_not_decrease(convert_number_to_list(111111),-1),
    false = does_not_decrease(convert_number_to_list(223450),-1),
    true = does_not_decrease(convert_number_to_list(123789),-1),

    true = has_adjacent_numbers(convert_number_to_list(111111),-1),
    true = has_adjacent_numbers(convert_number_to_list(223450),-1),
    false = has_adjacent_numbers(convert_number_to_list(123789),-1),

    true = meets_criteria(111111),
    false = meets_criteria(223450),
    false = meets_criteria(123789),

    ok.

main() ->
    length(loop(lists:seq(256310, 732736, 1))).