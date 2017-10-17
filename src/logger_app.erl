-module(logger_app).

-behaviour(application).

%% Application callbacks
-export([start/0, start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start() ->
    code:add_patha("../deps/lager/ebin"),
    code:add_patha("../deps/goldrush/ebin"),
    lager:start(),
    application:start(logger).

start(_StartType, _StartArgs) ->
    logger_sup:start_link().

stop(_State) ->
    ok.
