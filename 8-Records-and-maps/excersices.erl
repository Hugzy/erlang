-module(excersices).
-export([test/0, read_json_file/1, map_search_pred/2]).

test() ->
    Map = #{a => 1, b => 2, f => 5, g => 6, j => 12, r => 44},
    Predicate = fun(K,_) -> K =:= a end,
    {ok, _} = map_search_pred(Map, Predicate),
    Predicate2 = fun(K,_) -> K =:= b end,
    {ok, _} = map_search_pred(Map, Predicate2),
    Failing_predicate = fun(K,_) -> K =:= c end,
    error = map_search_pred(Map, Failing_predicate),
    all_tests_passed.

read_json_file(File_name) -> 
    Bin = file:read_file(File_name),
    io:fwrite("~p~n",[Bin]).

map_search_pred(Map, Predicate) when is_map(Map) ->
    map_search_pred(maps:to_list(Map), Predicate);
map_search_pred([], _) ->
    error;
map_search_pred([{Key, Value} = Head|Tail], Predicate) ->
    case Predicate(Key,Value) of
        true ->
             {ok, Head};
        false -> 
            map_search_pred(Tail, Predicate)
        end.

