-module(personal_site_sup).

-behaviour(supervisor).

-export([start_link/0, init/1]).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
    Port = application:get_env(personal_site, port, 8080),
    Dispatch = cowboy_router:compile(personal_site_router:routes()),
    Listener = ranch:child_spec(
        personal_site_http_listener,
        ranch_tcp,
        [{port, Port}],
        cowboy_clear,
        #{env => #{dispatch => Dispatch}}
    ),
    {ok, {{one_for_one, 10, 10}, [Listener]}}.