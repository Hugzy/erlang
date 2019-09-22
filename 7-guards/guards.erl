-module(guards).
-export([max/2]).

max(X,Y) when X > Y -> X;
max(_,Y) -> Y.