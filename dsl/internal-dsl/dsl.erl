-module(dsl).
-export([]).
-compile([export_all]).

print(Atom) when is_atom(Atom) ->
    io:fwrite("~p \n", [Atom]);
print(List) when is_list(List) ->
    io:fwrite("variable: ~128p~n", [List]).
print(Text, Atom) when is_atom(Atom) ->
    io:fwrite("~p: ~p \n", [Text, Atom]).

test() ->
    ok.

run([]) ->
    [];
run([{Fun, Config}|Rest]) ->
    Pid = spawn(dsl, Fun, [Config, self()]),
    receive {Pid, Res} -> Res end,
    run(Rest).

write_to_console(Text, Main) ->
    % Write text to the console
    not_implemented.
scale_image({Image_location, Ratio}, Main) ->
    %scale image at desired location
    not_implemented.
crop_image({Image}, Main) ->
    % Crop an image
    not_implemented.
inwoke_web_request(URL, Main) ->
    % Inwoke a web-request
    not_implemented.
move_file({From, To}, Main) ->
    % Move a file from one location to another.
    not_implemented.
create_file(Name, Main) ->
    % Create a file
    not_implemented.
write_to_file(Name, Main) ->
    % Append simple text to a file
    not_implemented.
change_file_extension({File, Extension}, Main) ->
    % Change the file extension, it is up to the user to ensure that the change is valid
    not_implemented.
end_begin(_,_) ->
    % End the current context and begin the next one
    not_implemented.
end_context(_,_) ->
    % Indicates the end of the execution chain
    not_implemented.


main() ->
    statistics(wall_clock),
    Final = run([
        write_to_console,
        create_file,
        write_to_file,
        write_to_console,
        end_begin,
        scale_image,
        write_to_console,
        crop_image,
        write_to_console,
        change_file_extension,
        end_context
    ]),
    {_, Time2} = statistics(wall_clock),
    U2 = Time2,
    io:format("Process run time ~n milliseconds", [U2]).


    