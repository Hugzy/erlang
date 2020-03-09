-module(exc).
-export([]).
-compile([export_all]).
-include_lib("kernel/include/file.hrl").

test() ->
    ok.

file_write_time(File) ->
    case file:read_file_info(File) of
        {ok, Facts} ->
            {Facts#file_info.mtime};
        _ ->
            error
    end.

main() ->
    file_write_time("exc.erl"),
    file_write_time("exc.beam").
