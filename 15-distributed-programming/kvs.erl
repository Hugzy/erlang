-module(kvs).
-export([start/0, list/0, store/2, lookup/1]).

start() -> register(kvs, spawn(fun() -> loop() end)).

% Functions to call from the client
store(Key, Value) -> rpc({store, Key, Value}).
lookup(Key) -> rpc({lookup, Key}).

list() -> rpc({list}).

% Middle layer used to call the server
rpc(Q) ->
    kvs ! {self(), Q},
    receive
        {kvs, Reply} ->
            Reply
    end.


loop() ->
    receive
        {From, {store, Key, Value}} ->
            put(Key, {ok, Value}),
            From ! {kvs, true},
            loop();
        {From, {lookup, Key}} ->
            From ! {kvs, get(Key)},
            loop();
        {From, {keys}} ->
            From ! {kvs, get_keys()},
            loop();
        {From, {list}} ->
            TempList = [{K, get(K)} || K <- get_keys()],
            From !{kvs, [{K, V} || {K, {ok, V}} <- TempList]},
            loop()
    end.