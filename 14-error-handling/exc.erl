-module(exc).
-export([]).
-compile(export_all).


test() ->
    {Pid, Ref} = my_spawn(exc, start_process, []),
    do_crash(Pid, Ref).

do_crash(Pid, Ref) ->
    Pid ! {msg, "do crash"},
    receive
        {'DOWN', Ref, process, Pid, Reason} ->
            io:format("I (parent) My worker ~p died (~p)~n", [Pid, Reason])
    end.

start_process() ->
    N = erlang:system_time(millisecond),
    erlang:display("hello from crashing process"),
    receive
        {msg, "do crash"} ->
            M = erlang:system_time(millisecond),
            L = M - N,
            io:format("Process lived for ~p milliseconds", [L]),
            exit("crashed");
        _ ->
            erlang:display("did nothing")
    end.
    

my_spawn(Mod, Func, Args) -> 
    {Pid, Ref} = spawn_monitor(Mod, Func, Args),
    {Pid, Ref}.