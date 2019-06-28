-module(hashmap_example).

%% API
-export([hash_map_generate/1, hashmap_prop_test_empty_and_not_empty/0, hashmap_commutation/0, hashmap_associative/0]).

hash_map_generate(Seed) ->
  random:seed(Seed),
  req(hashmap:init(), 5).

req(Map, 0) -> Map;

req(Map, Acc) ->
  req(hashmap:add(Map, random:uniform(1000), random:uniform(1000)), Acc - 1).

hashmap_prop_test_empty_and_not_empty() ->
  Generator = fun(Seed) -> hash_map_generate(Seed) end,
  pbt_client:for_all(Generator, fun(Map) ->
     Map == hashmap:merge(Map, hashmap:init())
  end).

hashmap_commutation() ->
  Generator = fun(Seed) -> [hash_map_generate(Seed) || _ <- lists:seq(1, 2) ]  end,
  pbt_client:for_all(Generator, fun(MapList) ->
    hashmap:merge(lists:nth(2, MapList), lists:nth(1, MapList)) ==
      hashmap:merge(lists:nth(1, MapList), lists:nth(2, MapList))
  end).

hashmap_associative() ->
  Generator = fun(Seed) -> [hash_map_generate(Seed) || _ <- lists:seq(1, 3) ]  end,
  pbt_client:for_all(Generator, fun(MapList) ->
    hashmap:merge(hashmap:merge(lists:nth(1, MapList), lists:nth(2, MapList)), lists:nth(3, MapList))  ==
      hashmap:merge(hashmap:merge(lists:nth(3, MapList), lists:nth(2, MapList)), lists:nth(1, MapList))
                                end).