-module(personal_site_http_SUITE).

-include_lib("common_test/include/ct.hrl").

-export([all/0, init_per_suite/1, end_per_suite/1]).
-export([get_root_returns_html/1, get_css_returns_stylesheet/1]).

all() ->
    [get_root_returns_html, get_css_returns_stylesheet].

init_per_suite(Config) ->
    ok = application:ensure_started(inets),
    ok = application:ensure_started(crypto),
    application:set_env(personal_site, port, 0),
    {ok, _} = application:ensure_all_started(personal_site),
    Port = get_port(),
    ok = wait_until_listening(Port, 20),
    [{port, Port} | Config].

end_per_suite(Config) ->
    application:stop(personal_site),
    application:stop(ranch),
    _ = proplists:get_value(port, Config),
    ok.

get_root_returns_html(Config) ->
    Port = proplists:get_value(port, Config),
    Url = url(Port, "/"),
    {ok, {{_, 200, _}, Headers, Body}} = httpc:request(get, {Url, []}, [], [{body_format, binary}]),
    ContentType = header(Headers, "content-type"),
    true = ContentType =/= undefined,
    true = contains(string:to_lower(ContentType), "text/html"),
    BodyBin = iolist_to_binary(Body),
    Name = personal_site_cv:name(),
    {match, _} = binary:match(BodyBin, Name),
    {match, _} = binary:match(BodyBin, <<"<html">>),
    {match, _} = binary:match(BodyBin, <<"</html>">>),
    ok.

get_css_returns_stylesheet(Config) ->
    Port = proplists:get_value(port, Config),
    Url = url(Port, "/css/style.css"),
    {ok, {{_, 200, _}, Headers, Body}} = httpc:request(get, {Url, []}, [], [{body_format, binary}]),
    ContentType = header(Headers, "content-type"),
    true = ContentType =/= undefined,
    true = contains(string:to_lower(ContentType), "text/css"),
    BodyBin = iolist_to_binary(Body),
    true = byte_size(BodyBin) > 0,
    {match, _} = binary:match(BodyBin, <<"--bg">>),
    ok.

url(Port, Path) ->
    "http://127.0.0.1:" ++ integer_to_list(Port) ++ Path.

header(Headers, Key) ->
    Lower = string:to_lower(Key),
    case lists:search(fun({K, _}) -> string:to_lower(K) =:= Lower end, Headers) of
        {value, {_, V}} -> V;
        false -> undefined
    end.

contains(Haystack, Needle) ->
    string:find(Haystack, Needle) =/= nomatch.

get_port() ->
    case ranch:get_port(personal_site_http_listener) of
        {ok, P} -> P;
        P when is_integer(P) -> P;
        Other -> ct:fail({unexpected_port, Other})
    end.

wait_until_listening(_Port, 0) ->
    ct:fail(listener_not_ready);
wait_until_listening(Port, N) ->
    Url = url(Port, "/"),
    case httpc:request(get, {Url, []}, [{timeout, 500}], [{body_format, binary}]) of
        {ok, {{_, 200, _}, _, _}} -> ok;
        _ -> timer:sleep(100), wait_until_listening(Port, N - 1)
    end.
