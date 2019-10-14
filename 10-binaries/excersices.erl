-module(excersices).
-export([rev/2]).

rev (<<>>, Acc) -> Acc;
rev (<<H:1/binary, Rest/binary>>, Acc) ->
    rev(Rest, <<H/binary, Acc/binary>>).