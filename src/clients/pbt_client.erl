-module(pbt_client).

%% API
-export([for_all/2]).

for_all(RawType, Prop) -> pbt_server:execute_for_all(RawType, Prop).
