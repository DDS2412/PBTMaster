-module(hashmap).

-export([add/3, delete/2, init/0, hashCode/1, map/2, filter/2, foldl/3, foldr/3, lengthMap/1, mapf/2, join/1, merge/2]).

-record(tuple, {key, val}).

hashCode(Key) when (Key rem 10) rem 10 == 0 -> 1;

hashCode(Key) -> (Key rem 10) rem 10.

init() -> [ #tuple{key=null, val=null} || _ <- lists:seq(1, 11)].

add(Map, Key, Value) ->
  Hash = hashCode(Key),
  Element =  lists:nth(Hash, Map),
  case Element#tuple.key == Key of
    true ->
      lists:sublist(Map, Hash-1) ++ [#tuple{key=Key, val=Value}] ++ lists:nthtail(Hash,Map);
    false when Element#tuple.key == null ->
      lists:sublist(Map, Hash-1) ++ [#tuple{key=Key, val=Value}] ++ lists:nthtail(Hash,Map);
    false when Element#tuple.key /= null ->
      case Element#tuple.val == Value of
        true -> Map;
        false -> req(Map, Hash, Value, Key)
      end
  end.

delete(Map, Key) ->
  Hash = hashCode(Key),
  Element =  lists:nth(Hash, Map),
  case Element#tuple.key == Key of
    true ->
      lists:sublist(Map, Hash-1) ++ [#tuple{key=null, val=null}] ++ lists:nthtail(Hash,Map);
    false when Element#tuple.key == null  ->
      Map;
    false -> delReq(Map, Hash, Key)
  end.

filter(Map, Fun) when length(Map) >= 1 ->
  [Element | Tail] = Map,
  case Fun(Element#tuple.key, Element#tuple.val) of
    true -> [Element] ++ filter(Tail, Fun);
    false -> filter(Tail, Fun)
  end;
filter(Map, Fun) when length(Map) < 1 ->
  [].

foldl(Map, Fun, Acc) ->
  case length(Map) > 0 of
    true -> [ Element | Tail ] = Map,
      case Element#tuple.key /= null of
        true -> foldl (Tail, Fun, Fun(Element#tuple.key, Element#tuple.val, Acc) );
        false -> foldl (Tail, Fun, Acc)
      end;
    false -> Acc
  end.

foldr(Map, Fun, Acc) ->
  ReverseMap = lists:reverse(Map),
  foldl(ReverseMap, Fun, Acc).

map(Map, Fun) when length(Map) > 0 ->
  [ Element | Tail ] = Map,
  case Element#tuple.key /= null of
    true -> [#tuple{key=Element#tuple.key, val=Fun(Element#tuple.key, Element#tuple.val)}] ++ map(Tail, Fun);
    false -> [Element] ++ map(Tail, Fun)
  end;
map(Map, Fun) when length(Map) =< 0 ->
  [].

mapf(Map, Fun) ->
  foldl(Map, fun(K,V,Acc) -> add(Acc, K, Fun(K,V)) end, init()).

lengthMap(Map) -> foldl(Map, fun(_,_,Sum) -> Sum + 1 end, 0).

join(Map) ->
  Fun = fun(_,V, Str) ->
    String = Str ++ V ,
    String ++ ","
        end,

  foldl(Map, Fun, "").

merge (Map1, Map2) ->
  F = fun(K,V,Acc) when K /= null ->
    add(Acc, K, V)
      end,
  fun(K,V,Acc) when K == null ->
    []
  end,

  Acc = Map1 ++ init() ++ init() ++ init() ,
  foldl(Map2, F, Acc).


req(Map, KeyNow, Value, Key) when KeyNow < 11 ->
  Element = lists:nth(KeyNow, Map),
  case Element#tuple.key == null of
    true -> lists:sublist(Map, KeyNow-1) ++ [#tuple{key=Key, val=Value}] ++ lists:nthtail(KeyNow,Map);
    false -> req(Map, KeyNow+1, Value, Key)
  end;

req(Map, KeyNow, Value, Key) when KeyNow > 11 -> Map.


delReq(Map, KeyNow, Key) when KeyNow < 11 ->
  Element = lists:nth(KeyNow, Map),
  case Element#tuple.key == Key of
    true -> lists:sublist(Map, KeyNow-1) ++ [#tuple{key=null, val=null}] ++ lists:nthtail(KeyNow,Map);
    false -> delReq(Map, KeyNow+1, Key)
  end;

delReq(Map, KeyNow, Key) when KeyNow >= 11 -> Map.
