-module(lec3).
-export([]).
-compile([export_all]).

test() ->
    ok.
stack(_, [], Stack, _) ->
    Stack;
stack(load, [Inst|Instructions], Stack, Reg)->
    stack(Inst, Instructions, [Reg, Stack], Reg);
stack(push, [{_,Var}|Instructions], [Frame|Stack], Reg)->
    stack()
    err;
stack(add, [Inst|Instructions], [Frame|Stack], Reg)->
    err;
stack(mult, [Inst|Instructions], [Frame|Stack], Reg)->
    err.

main() ->
    ok.