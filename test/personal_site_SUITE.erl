-module(personal_site_SUITE).

-include_lib("common_test/include/ct.hrl").

-export([all/0, init_per_suite/1, end_per_suite/1]).
-export([http_root_returns_200/1, http_css_returns_200/1]).

all() ->
    [http_root_returns_200, http_css_returns_200].

init_per_suite(Config) ->
    ok = application:ensure_all_started(inets),
    application:set_env(personal_site, port, 0),
    {ok, _} = application:ensure_all_started(personal_site),
    Port = ranch:get_port(personal_site_http_listener),
    [{port, Port} | Config].

end_per_suite(_Config) ->
    ok = application:stop(personal_site),
    _ = application:stop(ranch),
    _ = application:stop(cowlib),
    _ = application:stop(cowboy),
    ok = application:stop(inets),
    ok.

http_root_returns_200(Config) ->
    Port = proplists:get_value(port, Config),
    Url = "http://localhost:" ++ integer_to_list(Port) ++ "/",
    {ok, {{_, 200, _}, Headers, Body}} =
        httpc:request(get, {Url, []}, [], [{body_format, binary}]),
    ContentType = header_value("content-type", Headers),
    true = ContentType /= undefined,
    true = string:find(string:lowercase(ContentType), "text/html") /= nomatch,
    Name = list_to_binary(personal_site_cv:name()),
    true = binary:match(Body, Name) /= nomatch,
    true = binary:match(Body, <<"id=\"summary\"">>) /= nomatch,
    true = binary:match(Body, <<"id=\"experience\"">>) /= nomatch,
    true = binary:match(Body, <<"id=\"skills\"">>) /= nomatch,
    true = binary:match(Body, <<"id=\"education\"">>) /= nomatch,
    true = binary:match(Body, <<"id=\"contact\"">>) /= nomatch,
    ok.

http_css_returns_200(Config) ->
    Port = proplists:get_value(port, Config),
    Url = "http://localhost:" ++ integer_to_list(Port) ++ "/css/style.css",
    {ok, {{_, 200, _}, Headers, Body}} =
        httpc:request(get, {Url, []}, [], [{body_format, binary}]),
    ContentType = header_value("content-type", Headers),
    true = ContentType /= undefined,
    true = string:find(string:lowercase(ContentType), "text/css") /= nomatch,
    true = byte_size(Body) > 100,
    true = binary:match(Body, <<":root">>) /= nomatch,
    ok.

header_value(Key, Headers) ->
    Lower = string:lowercase(Key),
    case lists:search(fun({K, _}) -> string:lowercase(K) =:= Lower end, Headers) of
        {value, {_, V}} -> V;
        false -> undefined
    end.
