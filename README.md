# personal_site

A personal CV website written in Erlang and served with Cowboy.
Content is rendered server-side as plain HTML — no client-side
frameworks or external CDNs.

## Prerequisites

- Erlang/OTP (tested with OTP 27)
- rebar3 (3.x)

## Build

Fetch dependencies and compile:

```sh
rebar3 compile
```

## Run

Start the application with an interactive shell:

```sh
rebar3 shell
```

Then open <http://localhost:8080/> — the server responds with a
simple "Hello — CV site coming soon" HTML page.

The listening port defaults to `8080`. To use a different port,
start the shell with an override:

```sh
rebar3 shell --eval 'application:set_env(personal_site, port, 9090).'
```

## Architecture

| Module                       | Responsibility                                              |
| ---------------------------- | ----------------------------------------------------------- |
| `src/personal_site.app.src`  | OTP application resource file (name, deps, default env).    |
| `src/personal_site_app.erl`  | OTP application callback: starts the top-level supervisor.  |
| `src/personal_site_sup.erl`  | Top-level supervisor; owns the Cowboy listener child.       |
| `src/personal_site_router.erl` | Builds the Cowboy dispatch route table.                   |
| `src/personal_site_root_handler.erl` | Cowboy handler for `GET /`, returns the landing page HTML. |

New routes are added to `personal_site_router:routes/0` without
touching the listener wiring in the supervisor.
