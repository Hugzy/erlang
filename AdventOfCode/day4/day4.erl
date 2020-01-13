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

count(Needle, Haystack) -> count(Needle, Haystack, 0).

count(_, [], Count) -> Count;
count(X, [X|Rest], Count) -> count(X, Rest, Count+1);
count(X, [_|Rest], Count) -> count(X, Rest, Count).

has_adjacent_numbers_v2(_, _, Previous_count) when Previous_count == 2 ->
    true;
has_adjacent_numbers_v2(Needles, Haystack, _) when length(Needles) == 0 ->
    false;
has_adjacent_numbers_v2(Needles, Haystack, _) ->
    [H|T] = Needles,
    has_adjacent_numbers_v2(T, Haystack, count(H, Haystack)).

meets_criteria(Number) ->
    Number_list = convert_number_to_list(Number),
    has_adjacent_numbers(Number_list, -1) and does_not_decrease(Number_list , -1).

meets_criteria_v2(Number) ->
    Number_list = convert_number_to_list(Number),
    has_adjacent_numbers_v2(Number_list, Number_list, 0) and does_not_decrease(Number_list , 0).


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

loop_v2([H | Sequence]) ->
    Meets_criteria = meets_criteria_v2(H),
    if 
        Meets_criteria ->
            [H|loop_v2(Sequence)];
        true ->
            loop_v2(Sequence)
        end;
loop_v2(List) when length(List) == 0 ->
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

test_v2() ->

    true = does_not_decrease(convert_number_to_list(112233),-1),
    true = does_not_decrease(convert_number_to_list(123444),-1),
    true = does_not_decrease(convert_number_to_list(111122),-1),

    Haystack_1 = convert_number_to_list(112233),
    true = has_adjacent_numbers_v2(Haystack_1, Haystack_1,[]),
    Haystack_2 = convert_number_to_list(123444),
    false = has_adjacent_numbers_v2(Haystack_2, Haystack_2,[]),
    Haystack_3 = convert_number_to_list(111122),
    true = has_adjacent_numbers_v2(Haystack_3, Haystack_3,[]),
    ok.

main() ->
    length(loop(lists:seq(256310, 732736, 1))).

main_v2() ->
    length(loop_v2(lists:seq(256310, 732736, 1))).