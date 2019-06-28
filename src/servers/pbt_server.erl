-module(pbt_server).

-behaviour(gen_server).

%% API
-export([start_link/0]).

-export([execute_for_all/2]).

%% gen_server callbacks
-export([init/1,
  handle_call/3,
  handle_cast/2,
  handle_info/2,
  terminate/2,
  code_change/3]).

%%%===================================================================
%%% API
%%%===================================================================

start_link() ->
  gen_server:start_link({global, ?MODULE}, ?MODULE, [], []).

execute_for_all(Generator, Prop) ->
  gen_server:call({global, ?MODULE}, {execute_for_all, Generator, Prop}).

%%integer_generator(Seed, Number, MaxNumber) ->
%%  gen_server:call({global, ?MODULE}, {integer_generator, Seed, Number, MaxNumber}).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

init([]) ->
  process_flag(trap_exit, true),
  io:format("~p (~p) starting.... ~n", [{global, ?MODULE}, self()]),
  {ok, []}.

handle_call({execute_for_all, Generator, Prop}, _From, State) ->
  pbt_logic:execute_for_all(Generator, Prop),
  logger_client:addNewLog("Property is correct!"),
  io:format("Property is correct!~n"),
  {reply, ok, State};

handle_call(_Request, _From, State) ->
  {reply, ok, State}.

handle_cast(_Request, State) ->
  {noreply, State}.

handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, _State) ->
  logger_client:addNewLog(_Reason),
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
