# personal_site

A personal CV website written in Erlang and served with Cowboy. Content
is rendered server-side as plain HTML — no client-side frameworks or
external CDNs.

## Overview

The app serves a single styled CV page at `GET /` using data from the
`personal_site_cv` module and an embedded stylesheet at
`GET /css/style.css` (served from `priv/static/css/style.css`). The
handler (`personal_site_cv_handler`) assembles semantic HTML with stable
element ids and classes, so styles and content can be swapped
independently.

## Prerequisites

- **Erlang/OTP 27+** (OTP 26 may work but CI and development use OTP 27)
- **rebar3 3.22+** — [install guide](https://rebar3.org/docs/getting-started/)

Check your versions:

```sh
erl -version
rebar3 version
```

## Build and Run

Fetch deps and compile:

```sh
rebar3 compile
```

Start an interactive shell (the site comes up automatically via the OTP
application supervision tree):

```sh
rebar3 shell
```

Then open <http://localhost:8080/> — the server responds with the full
CV page, rendered server-side from `src/personal_site_cv.erl`.

The listening port defaults to `8080`. To use a different port, start the
shell with an override:

```sh
rebar3 shell --eval 'application:set_env(personal_site, port, 9090).'
```

Alternatively set it per-environment in `config/sys.config` (create the
file if absent):

```erlang
[{personal_site, [{port, 9090}]}].
```

The same env key controls the port inside releases and Common Test.

## Tests

### Unit tests (eunit)

Covers:

- `personal_site_cv` — every section present, required keys non-empty,
  email shape, bullets/degree/dates structure.
- `personal_site_cv_handler:page_html/0` — output is an HTML binary
  containing the profile name, each section `id` (`summary`,
  `experience`, `skills`, `education`, `contact`), key headings, and the
  stylesheet link.

```sh
rebar3 eunit
```

Individual suite:

```sh
rebar3 eunit --module personal_site_cv_tests
rebar3 eunit --module personal_site_cv_handler_tests
```

### HTTP smoke test (Common Test)

Boots the real application on an ephemeral port (so it never collides
with a running instance) and issues live HTTP requests with `httpc`:

- `GET /` → `200 text/html` with the profile name and each section id in
  the body.
- `GET /css/style.css` → `200 text/css` with a non-empty stylesheet body.

```sh
rebar3 ct
```

Both suites run via `rebar3 do eunit, ct`.

## Customizing Your CV

All CV content lives in one module: **`src/personal_site_cv.erl`**.

Open it and replace the placeholder values (the defaults describe the
persona "Ada Lovelace" so the page design is reviewable before real
details arrive). No other module needs to change — the handler renders
whatever this module returns.

| Function | What it controls |
|---|---|
| `name/0` | Full name in the page header and `<title>`. |
| `title/0` | Headline shown under your name. |
| `email/0` | Contact address rendered in the Contact section (with a `mailto:` link). |
| `summary/0` | Paragraph for the About section. |
| `experience/0` | List of maps `%{company, role, dates, bullets}` (newest first); each `bullets` list becomes a `<ul>` in that entry. |
| `skills/0` | Flat list of strings rendered as pill badges. |
| `education/0` | List of maps `%{institution, degree, dates}`. |

Example — swap in a new experience entry:

```erlang
experience() ->
    [
        #{
            company => "Acme Corp",
            role => "Senior Erlang Engineer",
            dates => "2021 - Present",
            bullets => [
                "Led the migration of the billing service to OTP 27",
                "Cut p99 latency 40% by tuning the Cowboy accept pool"
            ]
        }
        | experience() % or replace the whole list
    ].
```

After editing, recompile and reload without restarting the shell:

```sh
r3:compile().  % inside `rebar3 shell`
```

Or rebuild from the shell prompt:

```sh
rebar3 compile
rebar3 shell
```

The stylesheet is `priv/static/css/style.css` — edit it directly if you
want to tweak colours, spacing, or responsive breakpoints (the CSS
variables at the top drive the theme).

## Architecture

| Module | Responsibility |
|---|---|
| `src/personal_site.app.src` | OTP application resource file (name, deps, default env). |
| `src/personal_site_app.erl` | OTP application callback: starts the top-level supervisor. |
| `src/personal_site_sup.erl` | Top-level supervisor; owns the Cowboy listener child. |
| `src/personal_site_router.erl` | Builds the Cowboy dispatch route table. |
| `src/personal_site_cv.erl` | CV content data (placeholder values; edit to publish a real CV). |
| `src/personal_site_cv_handler.erl` | Cowboy handler for `GET /`; `page_html/0` also exported for tests. |

New routes are added to `personal_site_router:routes/0` without
touching the listener wiring in the supervisor. The CV page's sections
carry stable ids (`summary`, `experience`, `skills`, `education`,
`contact`) so stylesheets and future content swaps attach to a fixed
structure.
