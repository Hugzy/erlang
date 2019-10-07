-module(raising_exceptions).
-export([try_exit/0, try_throw/0, try_error/0, read/1]).

try_exit() ->
    exit({error, "the cake has exited, contact are 51"}).

try_throw() ->
    throw({error, "the cake was thrown, contact are 51"}).

try_error() ->
    error({error, "the cake had an error, contact are 51"}).

read(File) -> 
    case file:read_file(File) of
        {ok, Bin} ->
            Bin;
        {error, Why} -> 
            error({error, Why, "You probably entered an invalid file name, either the file doesn't exist at all or you mispelled its name"})
    end.

generate_exception(1) -> a;
generate_exception(2) -> throw(a);
generate_exception(3) -> exit(a);
generate_exception(4) -> {'EXIT', a};
generate_exception(5) -> error(a).

catcher(N) ->
    try generate_exception(N) of
        Val -> {N, normal, Val}
    catch
        throw:A -> {N, caught, thrown, A};
        exit:B -> {N, caught, exited, B};
        error:C -> {N, caught, error, C}
    end.