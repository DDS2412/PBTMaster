-module(logger_logic).

%% API
-export([initDB/0, addLog/2, getLogs/1, deleteLogs/1]).

-include_lib("stdlib/include/qlc.hrl").

-include("../records.hrl").

initDB() ->
  mnesia:create_schema([node()]),
  mnesia:start(),
  %% Проверка, что таблица существует
  try
    mnesia:table_info(type, log)
  catch
    exit: _ ->
      mnesia:create_table(log, [{attributes, record_info(fields, log)},
        {type, bag},
        {disc_copies, [node()]}])
  end.

addLog(NodeName, Message) ->
  AF = fun() ->
    {CreatedOn, _} = calendar:universal_time(),
    mnesia:write(#log{nodeName = NodeName, message = Message, createdOn = CreatedOn})
  end,
  mnesia:transaction(AF).

getLogs(NodeName) ->
  AF = fun() ->
    Query = qlc:q([X || X <- mnesia:table(log), X#log.nodeName =:= NodeName]),
    Res = qlc:e(Query),
    lists:map(fun(Item) -> { Item#log.message, Item#log.createdOn }  end, Res)
       end,
  {atomic, Logs} = mnesia:transaction(AF),
  Logs.

deleteLogs(NodeName) ->
  AF = fun() ->
    Query = qlc:q([X || X <- mnesia:table(log), X#log.nodeName =:= NodeName]),
    Res = qlc:e(Query),
    F = fun() ->
      lists:foreach(fun(Res) -> mnesia:delete_object(Res)
                    end, Res)
        end,

    mnesia:transaction(F)
       end,

  mnesia:transaction(AF).
