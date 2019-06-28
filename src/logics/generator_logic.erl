-module(generator_logic).

%% API
-export([integer_generator/1, random_integer/1]).

integer_generator(Seed) ->
  random:seed(Seed),
  [random:uniform(1000) || _ <- lists:seq(1, 100)].

random_integer(Seed) ->
  random:seed(Seed),
  random:uniform(1000).

