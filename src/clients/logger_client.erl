-module(logger_client).

%% API
-export([addNewLog/1, getMasterLogs/0, clearMasterLogs/0]).

addNewLog(Message) ->
  logger:addLog(node(), Message).

getMasterLogs() -> logger:getLogs(node()).

clearMasterLogs() -> logger:deleteLogs(node()).

