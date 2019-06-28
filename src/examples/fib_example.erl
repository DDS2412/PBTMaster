-module(fib_example).

%% API
-export([fib/1]).

-export([fib_prop_test/0]).

fib(0) -> 0;

fib(1) -> 1;

fib(N) -> fib(N-1) + fib(N-2).

fib_prop_test() ->
  Generator = fun(Seed) -> generator_logic:random_integer(Seed) end,
  pbt_client:for_all(Generator,
    fun(L) -> if L >= 2 ->
      Res = fib(L-1) + fib(L-2),
      Res =:= fib(L);
                true -> true
              end
    end).


