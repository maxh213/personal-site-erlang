# personal_site

A personal CV website written in Erlang and served with Cowboy.
The CV page is rendered server-side as plain HTML from structured
Erlang data — no client-side frameworks, templates, or external CDNs.

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

Then open <http://localhost:8080/> — the server responds with the CV page.

The listening port defaults to `8080`. To use a different port,
start the shell with an override:

```sh
rebar3 shell --eval 'application:set_env(personal_site, port, 9090).'
```

## Test

```sh
rebar3 eunit
```

## Customizing your CV

All content lives in one place: `src/personal_site_cv.erl`.
Edit the placeholder values there (name, title, summary, contact,
skills, experience, education) and the page updates automatically —
no handler or markup changes are needed.

## Architecture

| Module                              | Responsibility                                         |
| ----------------------------------- | ------------------------------------------------------ |
| `src/personal_site.app.src`         | OTP application resource file (name, deps, default env). |
| `src/personal_site_app.erl`         | OTP application callback: starts the top-level supervisor. |
| `src/personal_site_sup.erl`         | Top-level supervisor; owns the Cowboy listener child.    |
| `src/personal_site_router.erl`      | Builds the Cowboy dispatch route table (`GET /`).        |
| `src/personal_site_cv.erl`          | CV content and data (the place to edit).                 |
| `src/personal_site_page_handler.erl`| Cowboy handler that renders the CV HTML for `GET /`.     |
| `test/`                             | eunit tests for the data module and page renderer.       |

New routes are added to `personal_site_router:routes/0` without
touching the listener wiring in the supervisor.
