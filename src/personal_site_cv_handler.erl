%% @doc Cowboy handler serving the server-rendered CV page at "/".
%%
%% All page content is pulled from {@link personal_site_cv} and rendered
%% into semantic HTML5 here with plain Erlang iolists - no templating
%% engine. Sections carry stable ids/classes (summary, experience, skills,
%% education, contact) so later styling and content swaps never require
%% handler rewrites.
-module(personal_site_cv_handler).

-behaviour(cowboy_handler).

-export([init/2, page_html/0]).

init(Req0, State) ->
    Body = page_html(),
    Req = cowboy_req:reply(
        200,
        #{<<"content-type">> => <<"text/html; charset=utf-8">>},
        Body,
        Req0
    ),
    {ok, Req, State}.

%% ---------------------------------------------------------------------------
%% Page assembly
%% ---------------------------------------------------------------------------

page_html() ->
    iolist_to_binary([
        "<!DOCTYPE html>\n",
        "<html lang=\"en\">\n",
        "<head>\n",
        "  <meta charset=\"utf-8\">\n",
        "  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">\n",
        "  <title>", escape(personal_site_cv:name()), " - Curriculum Vitae</title>\n",
        "  <link rel=\"stylesheet\" href=\"/css/style.css\">\n",
        "</head>\n",
        "<body>\n",
        header_html(),
        "<main>\n",
        summary_section(),
        experience_section(),
        skills_section(),
        education_section(),
        contact_section(),
        "</main>\n",
        "</body>\n",
        "</html>\n"
    ]).

header_html() ->
    [
        "<header class=\"cv-header\">\n",
        "  <h1>", escape(personal_site_cv:name()), "</h1>\n",
        "  <p class=\"job-title\">", escape(personal_site_cv:title()), "</p>\n",
        "</header>\n"
    ].

summary_section() ->
    [
        "<section id=\"summary\" class=\"summary\">\n",
        "  <h2>About</h2>\n",
        "  <p>", escape(personal_site_cv:summary()), "</p>\n",
        "</section>\n"
    ].

experience_section() ->
    [
        "<section id=\"experience\" class=\"experience\">\n",
        "  <h2>Experience</h2>\n",
        [experience_entry(Entry) || Entry <- personal_site_cv:experience()],
        "</section>\n"
    ].

experience_entry(#{company := Company, role := Role, dates := Dates, bullets := Bullets}) ->
    [
        "  <article class=\"experience-entry\">\n",
        "    <h3>", escape(Role), "</h3>\n",
        "    <p class=\"company\">", escape(Company), "</p>\n",
        "    <p class=\"dates\">", escape(Dates), "</p>\n",
        "    <ul>\n",
        [["      <li>", escape(Bullet), "</li>\n"] || Bullet <- Bullets],
        "    </ul>\n",
        "  </article>\n"
    ].

skills_section() ->
    [
        "<section id=\"skills\" class=\"skills\">\n",
        "  <h2>Skills</h2>\n",
        "  <ul class=\"skills-list\">\n",
        [["    <li>", escape(Skill), "</li>\n"] || Skill <- personal_site_cv:skills()],
        "  </ul>\n",
        "</section>\n"
    ].

education_section() ->
    [
        "<section id=\"education\" class=\"education\">\n",
        "  <h2>Education</h2>\n",
        [education_entry(Entry) || Entry <- personal_site_cv:education()],
        "</section>\n"
    ].

education_entry(#{institution := Institution, degree := Degree, dates := Dates}) ->
    [
        "  <article class=\"education-entry\">\n",
        "    <h3>", escape(Degree), "</h3>\n",
        "    <p class=\"institution\">", escape(Institution), "</p>\n",
        "    <p class=\"dates\">", escape(Dates), "</p>\n",
        "  </article>\n"
    ].

contact_section() ->
    Email = personal_site_cv:email(),
    [
        "<section id=\"contact\" class=\"contact\">\n",
        "  <h2>Contact</h2>\n",
        "  <p class=\"contact-email\">Email: ",
        "<a href=\"mailto:", escape(Email), "\">", escape(Email), "</a></p>\n",
        "</section>\n"
    ].

%% ---------------------------------------------------------------------------
%% Helpers
%% ---------------------------------------------------------------------------

%% Escape text before embedding it in HTML so the page stays well-formed
%% even if placeholder content is later swapped for user-supplied text.
escape(Text) when is_list(Text) ->
    lists:flatten([escape_char(Char) || Char <- Text]);
escape(Bin) when is_binary(Bin) ->
    escape(binary_to_list(Bin)).

escape_char($&) -> "&amp;";
escape_char($<) -> "&lt;";
escape_char($>) -> "&gt;";
escape_char(Char) -> Char.
