-module(raising_exceptions).
-export([try_exit/0, try_throw/0, try_error/0]).

try_exit() ->
    exit({error, "the cake has exited, contact are 51"}).

try_throw() ->
    throw({error, "the cake was thrown, contact are 51"}).

try_error() ->
    error({error, "the cake had an error, contact are 51"}).