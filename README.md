# PBTMaster
## Пример генератора
``` Erlang
integer_generator(Seed) ->
  random:seed(Seed),
  [random:uniform(1000) || _ <- lists:seq(1, 100)].

Generator = fun(Seed) -> generator_logic:integer_generator(Seed) end
```
## Пример функции для проверки свойств
``` Erlang
fun(L) -> length(L) =:= length(lists:reverse(L)
````
## Пример API для тестирования
``` Erlang
pbt_client:for_all(Generator, fun(L) -> length(L) =:= length(lists:reverse(L)) end).
````
