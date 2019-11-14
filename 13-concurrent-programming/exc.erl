-module(exc).
-export([]).
-compile(export_all).

test() -> 
    done.

start(Time, AnAtom, Fun) -> 
    spawn(fun() -> timer(Time, AnAtom, Fun) end).
start(AnAtom, Fun) -> 
    spawn(fun() -> register(AnAtom, self()), Fun() end).

timer(Time, AnAtom, Fun) ->
    receive
        cancel ->
            void
    after Time ->
        start(AnAtom, Fun)
    end.

sendMessage(Pid, Message) ->
    Pid ! Message.

sendMessage(Pid) ->
    Pid ! {{num, 2}, {num, 3}},
    done.

add() -> 
    erlang:display("started process"),
    receive
        {{num,X}, {num, Y}} ->
            Z = X+Y,
            erlang:display(Z);
        _Any ->
            erlang:display("provided message didn't match the pattern")
    end.
