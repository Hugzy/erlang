-module(day1).
-export([]).
-compile(export_all).

test() ->
    Mapped = map_fuel([12, 14, 1969, 100756]),
    [2,2,654,33583] = Mapped,
    34241 = calculate_total(Mapped),
    ok.

calculate_total(Mapped) ->
    lists:sum(Mapped).

map_fuel(All) ->
    % could thread this
    lists:map(fun(X) -> spawn(day1, calculate_fuel, [X]) end, All).
    
calculate_fuel(Mass) ->
    Temp = erlang:floor(Mass/3),
    Return_value = Temp - 2,
    Return_value.

readlines(FileName) ->
    {ok, Device} = file:open(FileName, [read]),
    try get_all_lines(Device)
      after file:close(Device)
    end.

get_all_lines(Device) ->
    case io:get_line(Device, "") of
        eof  -> [];
        Line -> Line ++ get_all_lines(Device)
    end.

main() ->
    Lines = readlines("input"),
    Lines.