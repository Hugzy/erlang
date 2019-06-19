%%%-------------------------------------------------------------------
%%% @author Magida
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. jun 2019 22:02
%%%-------------------------------------------------------------------
-module(afile_server).
-author("Magida").

%% API
-export([start/1, loop/1]).
start(Dir) -> spawn(afile_server, loop, [Dir]).

loop(Dir) ->
  receive
    {Client, list_dir} ->
      Client ! {self(), file:list_dir(Dir)};
    {Client, {get_file, File}} ->
      Full = filename:join(Dir, File),
      Client ! {self(), file:read_file(Full)}
  end,
  loop(Dir).