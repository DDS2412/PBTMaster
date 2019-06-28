-module(master_supervisor).

-behaviour(supervisor).

%% API
-export([start_link/0, start_link_shell/0]).

-export([init/1]).

start_link_shell() ->
  {ok, Pid} = supervisor:start_link({global, ?MODULE}, ?MODULE, []),
  unlink(Pid).

start_link() ->
  supervisor:start_link({global, ?MODULE}, ?MODULE, []).

%% supervisor callback
init([]) ->
  process_flag(trap_exit, true),
  %% supervisor:which_children(server_supervisor).
  %% supervisor:terminate_child(server_supervisor,serverId).
  io:format("~p (~p) starting...~n", [{global,?MODULE}, self()]),

%% If MaxRestarts restarts occur in MaxSecondsBetweenRestarts seconds
%% supervisor and child processes are killed
  RestartStrategy = one_for_all,
  MaxRestarts = 3,                  % 3 restart within
  MaxSecondsBetweenRestarts = 5,    % five seconds
  Flags = {RestartStrategy, MaxRestarts, MaxSecondsBetweenRestarts},

%% permanent - always restart
%% temporary - never restart
%% transient - restart if abnormally ends
  Restart = permanent,

%%brutal_kill - use exit(Child, kill) to terminate
%%integer - use exit(Child, shutdown) - milliseconds
  Shutdown = infinity,

%% worker
%% supervisor
  Type = worker,

%% Modules ones supervisor uses
%% {ChildId, {StartFunc - {module,function,arg}, Restart, Shutdown, Type, Modules}.
%%  PbasedSpecifications = {pbasedServerId, {pbased_server, start_link, []},
%%    Restart, Shutdown, Type, [pbased_server]},

  PBTSpecifications = {pbtServerId, {pbt_server, start_link, []},
    Restart, Shutdown, Type, [pbt_server]},

  MnesiaSpecifications = {mnesiaServerId, {logger, start_link, []},
    Restart, Shutdown, Type, [logger]},

%% tuple of restart strategy, max restart and max time
%% child specification
  {ok, {Flags, [MnesiaSpecifications, PBTSpecifications]}}.