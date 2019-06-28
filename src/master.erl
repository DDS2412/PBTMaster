-module(master).

-behaviour(application).

%% Application callbacks
-export([start/2,start/0, stop/0, stop/1, test/0]).

%%%===================================================================
%%% Application callbacks
%%%===================================================================

start() ->
  application:start(?MODULE).

start(_StartType, _StartArgs) ->
  master_supervisor:start_link().

stop() ->
  mnesia:stop(),
  application:stop(?MODULE).

stop(_State) ->
  ok.

test() ->
  Generator = fun(Seed) -> generator_logic:integer_generator(Seed) end,
  pbt_client:for_all(Generator, fun(L) -> length(L) =:= length(lists:reverse(L)) end).
