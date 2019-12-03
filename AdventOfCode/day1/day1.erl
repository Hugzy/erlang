-module(day1).
-export([]).
-compile(export_all).

data() ->
    [128270, 147113, 61335, 78766, 119452,
		     116991, 70640, 145446, 117606, 135046, 70489, 131072,
		     67955, 66424, 126450, 101418, 90225, 66004, 136510,
		     61695, 143880, 53648, 58699, 119214, 83838, 95895,
		     66388, 66755, 120223, 79310, 93828, 136686, 108958,
		     140752, 85343, 103800, 126602, 147726, 88228, 83380,
		     77877, 61922, 75448, 67095, 60888, 136692, 63271,
		     113742, 68854, 86904, 110243, 104642, 141854, 71205,
		     76729, 138540, 134142, 62517, 63306, 71363, 126146,
		     74749, 76716, 59135, 62449, 110575, 134030, 84072,
		     122698, 96891, 69976, 94501, 149180, 57944, 64873,
		     68192, 138238, 119185, 137570, 79274, 111040, 142586,
		     120872, 63586, 78628, 122704, 147951, 102593, 105562,
		     55180, 64450, 87466, 112522, 60000, 149885, 52154,
		     80633, 61867, 86380, 136024].

test_data() ->
    [12,14,1969, 100756].

test() ->
    %Pids = map_fuel(test_data()),
    %io:format("pid: ~p \n", [Pids]),
    %Result = calculate_total(Pids),
    %io:format("result: ~p \n", [Result]),
    List = [],
    [2, 2, 966, 50346] = [calculate_fuel(N, self(), [])|| N <- test_data()],
    ok.

print({atom, N}) ->
    io:fwrite("atom: ~p \n", [N]);
print({list, List}) -> io:fwrite("list: ~w~n \n", [List]).

calculate_total(Pids) ->
    Mapped = [receive {Pid, R} -> R end || Pid <- Pids],
    print({list, Mapped}),
    lists:sum(Mapped).

map_fuel(All) ->
    % could thread this
    % Did thread this
    Main = self(),
    List = lists:map(fun (X) ->
			     spawn(day1, calculate_fuel, [X, Main, []])
		     end,
		     All),
    print({list, List}),
    List.

calculate_fuel(Mass, Main, List) ->
    Temp = erlang:floor(Mass / 3),
    Return_value = Temp - 2,
    % Send the result back to main

    case Return_value of
        N when N > 0 ->
            calculate_fuel(Return_value, Main, [Return_value | List]);
        N when 0 >= N ->
            Sum = lists:sum(List),
            Main ! {self(), Sum}
    end.

main() ->
    calculate_total(map_fuel(data())).