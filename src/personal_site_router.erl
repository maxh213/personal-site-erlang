-module(personal_site_router).

-export([routes/0]).

routes() ->
    [{'_', [
        {"/", personal_site_page_handler, []}
    ]}].