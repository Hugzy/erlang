%%%-------------------------------------------------------------------
%%% @author Magida
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. jun 2019 21:22
%%%-------------------------------------------------------------------
-module(hello).
-author("Magida").

%% API
-export([start/0]).
start() ->
  io:fwrite("Hello world"),
  io:fwrite("|~10.5c|~-10.5c|~5c|~n", [$a, $b, $c]).
