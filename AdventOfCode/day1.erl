-module(day1).
-export([]).
-compile(export_all).

test() ->
    Pids = map_fuel([12, 14, 1969, 100756]),
    %[2,2,654,33583] = Mapped,
    io:format("pid: ~p \n", [Pids]),
    34241 = calculate_total(Pids),
    ok.

print(List) ->
       io:fwrite("~w~n \n",[List]).

calculate_total(Pids) ->
    Mapped = [],
    [receive {Pid, R} -> io:format("val: ~p \n", [R]), [R|Mapped] end || Pid <- Pids],
    print(Mapped),
    lists:sum(Mapped).

map_fuel(All) ->
    % could thread this
    Main = self(),
    List = lists:map(fun(X) -> spawn(day1, calculate_fuel, [X, Main]) end, All),
    print(List),
    List.
    
calculate_fuel(Mass, Main) ->
    Temp = erlang:floor(Mass/3),
    Return_value = Temp - 2,
    % Send the result back to main
    io:format("result ~p \n", [Return_value]),
    Main ! {self(), Return_value}.

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