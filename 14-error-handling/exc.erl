-module(exc).
-export([]).
-compile(export_all).


test() ->
    {Pid, Ref} = my_spawn(exc, process, [1000]),
    do_crash(Pid, Ref).

do_crash(Pid, Ref) ->
    Pid ! {msg, "do crash"},
    receive
        {'DOWN', Ref, process, Pid, Reason} ->
            io:format("I (parent) My worker ~p died (~p)~n", [Pid, Reason])
    end.

do_crash(Pid) ->
    Pid ! {msg, "do crash"}.

process(Time) ->
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
    after 
        Time ->
            io:format("I am still alive"),
            process(Time)
    end.

im_still_alive() ->
    %io:format("i'm still alive"),
    timer:sleep(5000),
    im_still_alive().

on_exit(Pid, Fun) ->
    spawn(fun() ->
        Ref = monitor(process, Pid),
            receive
                {'DOWN', Ref, process, Pid, Why} ->
                    Fun(Why);
                _All ->
                    io:format("something happened")
        end
    end),
    Pid.

delay() ->
    timer:sleep(10000).

succes(true) ->
    io:format("process was killed");
succes(false) ->
    io:format("process wasn't killed most likely because it is trapping normal exit signals").


keep_alive(Fun) ->
    process_flag(trap_exit, true),
    Pid = spawn_link(Fun),
    on_exit(Pid, fun(Why) ->
        io:format("Process died: ~p, restarting it~n", [Why]),
        io:format("Pid: ~p", [Pid]),
        keep_alive(Fun),
        Pid end),
    Pid.

exc4() ->
    keep_alive(fun exc:im_still_alive/0).

my_spawn3(Mod, Func, Args, Timer) ->
        Pid = spawn(Mod, Func, Args),
        receive
        after
            Timer ->
                Response = exit(Pid, normal),
                succes(Response)
        end.

my_spawn2(Mod, Func, Args) ->
    Pid = spawn(Mod, Func, Args),
    on_exit(Pid, fun(Why) -> io:format("'\nan error occured ~p", [Why]) end),
    timer:sleep(2000),
    do_crash(Pid).

my_spawn(Mod, Func, Args) -> 
    {Pid, Ref} = spawn_monitor(Mod, Func, Args),
    {Pid, Ref}.