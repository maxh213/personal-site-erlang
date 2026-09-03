-module(personal_site_router).

-export([routes/0]).

routes() ->
    [{'_', [
        {"/", personal_site_cv_handler, []},
        {"/css/[...]", cowboy_static, {priv_dir, personal_site, "static/css"}}
    ]}].
