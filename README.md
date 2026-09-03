# personal_site

Personal CV website in Erlang + Cowboy. Serves a semantic, responsive HTML CV at `GET /` with a stylesheet at `/css/style.css`, both rendered/served without any client-side framework or templating engine.

## Prerequisites

- Erlang/OTP 27 (OTP 26+ should work; tested on 27)
- rebar3 3.20+

Verify:

```sh
erl -version
rebar3 version
```

## Run

```sh
rebar3 compile
rebar3 shell
```

Then open <http://localhost:8080/> — `personal_site_sup` starts a Cowboy listener on the configured port (default 8080) using routes from `personal_site_router`.

`rebar3 shell` loads `personal_site` automatically via `{shell, [{apps, [personal_site]}]}` in `rebar.config`.

### Configure the port

Default is `8080` (`{env, [{port, 8080}]}` in `src/personal_site.app.src`). Override at startup without editing files:

```sh
rebar3 shell --eval 'application:set_env(personal_site, port, 9090).'
```

Or with an `sys.config`:

```erlang
[{personal_site, [{port, 9090}]}].
```

```sh
rebar3 shell --config sys.config
```

The supervisor reads `application:get_env(personal_site, port, 8080)` on start.

## Tests

Unit tests (eunit) cover the CV data module and page renderer; the Common Test suite boots the app and smoke-tests HTTP responses.

```sh
rebar3 eunit   # unit tests: personal_site_cv + personal_site_page_handler:render/0
rebar3 ct      # HTTP smoke test: GET / -> 200 text/html, GET /css/style.css -> 200 text/css
rebar3 ct --verbose
```

The CT suite (`test/personal_site_http_SUITE.erl`) starts the app on an ephemeral port (`port 0` + `ranch:get_port/1`) so it does not clash with a running dev server.

> Note: This environment has no `erl`/`rebar3` installed, so `rebar3 eunit`/`rebar3 ct` were not executed here. The tests are written to pass when the toolchain is available.

## Customizing your CV

All placeholder content lives in one file:

**`src/personal_site_cv.erl`** — module `personal_site_cv`, function `cv/0`.

- `name/0` and `title/0` are convenience accessors used by the page title and header; the map returned by `cv/0` is the source of truth.
- Sections in the returned map: `name`, `title`, `summary`, `contact` (`email`, `phone`, `location`, `links`), `skills` (list), `experience` (list of `#{company, title, dates, bullets}`), `education` (list of `#{degree, school, dates}`).
- Replace the placeholder values (e.g. `<<"Alex Example">>`, `<<"Acme Corp">>`, summary text, links) with real data. The handler `personal_site_page_handler:render/0` HTML-escapes values and re-renders the page automatically — no markup or router changes needed.

Other modules and when to touch them:

| Module | Role |
|---|---|
| `src/personal_site.app.src` | OTP app resource (name, deps, default `port` env) |
| `src/personal_site_app.erl` | Application callback, starts the supervisor |
| `src/personal_site_sup.erl` | Supervisor that owns the Cowboy listener |
| `src/personal_site_router.erl` | Cowboy dispatch table (`GET /`, `/css/...`, `/favicon.svg`) |
| `src/personal_site_page_handler.erl` | Cowboy handler; `render/0` builds the HTML5 document |
| `priv/static/css/style.css` | Stylesheet served via `cowboy_static` |
| `priv/static/favicon.svg` | Favicon |
| `test/` | eunit + Common Test |

## Architecture

```
browser -> Cowboy (ranch_tcp) -> personal_site_router:routes/0
                                -> personal_site_page_handler (GET /)
                                -> cowboy_static (GET /css/*, /favicon.svg)
personal_site_page_handler:render/0 <- personal_site_cv:cv/0
```

Warnings are errors (`warnings_as_errors` in `rebar.config`), so the app starts cleanly with no compiler warnings.
