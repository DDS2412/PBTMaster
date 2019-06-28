-module(pbt_logic).

%% API
-export([execute_for_all/2]).

execute_for_all(Generator, Prop) ->
  Seed = now(),
  logger_client:addNewLog("Executing property based tests"),
  io:format("Executing property based tests with seed ~p~n", [Seed]),
  ListOfData = [Generator(1) || _ <- lists:seq(1, 100)],
  logger_client:addNewLog("Generator returned correct result!"),
  lists:foreach(fun(Data)->
                  Res = Prop(Data),
                  if Res == false ->
                    logger_client:addNewLog("Property isn't correct!"),
                    throw("Property isn't correct!");
                  true -> Res
                  end
                end, ListOfData),
  ok.
