-module(lib_misc).
-export([sum/1, map/2, for/3]).

for(Max, Max, F) -> [F(Max)];
for(I, Max, F)   -> [F(I)|for(I+2, Max, F)].

sum([H|T])  -> H + sum(T);
sum([])     -> 0.

map(_, [])         -> [];
map(F, [H|T])   -> [F(H) | map(F,T)].