-module(personal_site_router).

-export([routes/0]).

%% Dispatch table for the site. Dynamic routes come first, then static
%% assets are served straight from the app's priv/static directory via
%% cowboy_static (MIME types are inferred from file extensions).
routes() ->
    [{'_', [
        {"/", personal_site_page_handler, []},
        {"/css/[...]", cowboy_static, {priv_dir, personal_site, "static/css"}},
        {"/favicon.svg", cowboy_static, {priv_file, personal_site, "static/favicon.svg"}}
    ]}].
