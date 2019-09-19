%%%-------------------------------------------------------------------
%%% @author Magida
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 21. jun 2019 22:10
%%%-------------------------------------------------------------------
-module(tuples).
-author("Magida").

%% API
-export([start/0]).
start() ->
  C = {coordinates, 10, 42},
  {coordinates, X , Y} = C,
  io:fwrite("~w",[Y]).