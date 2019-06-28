-module(logger).

-behaviour(gen_server).

%% User interface grouping
-export([start_link/0]).

%% User interface grouping
-export([addLog/2, getLogs/1, deleteLogs/1]).

%% Gen_Server
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

%%%===================================================================
%%% API
%%%===================================================================

start_link() ->
  gen_server:start_link({global, ?MODULE}, ?MODULE, [], []).

addLog(NodeName, Message) ->
  gen_server:call({global, ?MODULE}, {addLog, NodeName, Message}).

getLogs(NodeName) ->
  gen_server:call({global, ?MODULE}, {getLogs, NodeName}).

deleteLogs(NodeName) ->
  gen_server:call({global, ?MODULE}, {deleteLogs, NodeName}).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================


init([]) ->
  process_flag(trap_exit, true),
  io:format("~p (~p) starting.... ~n", [{global, ?MODULE}, self()]),
  logger_logic:initDB(),
  {ok, []}.

handle_call({addLog, NodeName, Message}, _From, State) ->
  logger_logic:addLog(NodeName, Message),
  io:format("Log has been added for ~p~n",[NodeName]),
  {reply, ok, State};

handle_call({getLogs, NodeName}, _From, State) ->
  Logs = logger_logic:getLogs(NodeName),
  lists:foreach(fun(Log) ->
    io:format("Log for ~p: ~p - ~p~n", [ NodeName | tuple_to_list(Log)])
                end, Logs),
  {reply, ok, State};

handle_call({deleteLogs, NodeName}, _From, State) ->
  logger_logic:deleteLogs(NodeName),
  io:format("Data deleted for: ~p~n",[NodeName]),
  {reply, ok, State};

handle_call(_Request, _From, State) ->
  {noreply, State}.


handle_cast(_Request, State) ->
  {noreply, State}.

handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, _State) ->
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.
