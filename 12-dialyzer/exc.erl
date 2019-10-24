-module(exc).
-export([fixed1/2]).

%-spec bug1(integer(), string()) -> number().
%bug1(X, Y) -> 
%    X + Y.


-spec fixed1(integer(), integer()) -> integer().
fixed1(X,Y) ->
    X+Y.

