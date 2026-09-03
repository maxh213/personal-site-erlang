-module(personal_site_root_handler).

-behaviour(cowboy_handler).

-export([init/2]).

init(Req0, State) ->
    Body = <<"<!DOCTYPE html><html><head><meta charset=\"utf-8\">"
             "<title>Personal CV site</title></head>"
             "<body><h1>Hello — CV site coming soon</h1></body></html>"/utf8>>,
    Req = cowboy_req:reply(
        200,
        #{<<"content-type">> => <<"text/html; charset=utf-8">>},
        Body,
        Req0
    ),
    {ok, Req, State}.