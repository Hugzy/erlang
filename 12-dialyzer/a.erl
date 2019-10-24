-module(a).
-opaque hello_world() :: {string(), string()}.
-export_type([hello_world/0]).

-export([make_text/0]).

-spec make_text() -> hello_world().
make_text() -> {"hello", "world"}.

