%% @doc Cowboy handler that renders the CV page.
%%
%% The page is built entirely in plain Erlang from the structured data in
%% `personal_site_cv' — no external templating engine. Section ids and
%% classes are stable and minimal (`summary', `experience', `skills',
%% `education', ...) so they can be styled by a later stylesheet.
-module(personal_site_page_handler).

-behaviour(cowboy_handler).

-export([init/2, render/0, escape/1]).

init(Req0, State) ->
    Body = render(),
    Req = cowboy_req:reply(
        200,
        #{<<"content-type">> => <<"text/html; charset=utf-8">>},
        Body,
        Req0
    ),
    {ok, Req, State}.

%% @doc Render the complete HTML5 CV document as a binary.
-spec render() -> binary().
render() ->
    CV = personal_site_cv:cv(),
    Name = maps:get(name, CV),
    Title = maps:get(title, CV),
    Summary = maps:get(summary, CV),
    Contact = maps:get(contact, CV),
    Skills = maps:get(skills, CV),
    Experience = maps:get(experience, CV),
    Education = maps:get(education, CV),
    iolist_to_binary([
        "<!DOCTYPE html>\n",
        "<html lang=\"en\">\n",
        "<head>\n",
        "  <meta charset=\"utf-8\">\n",
        "  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">\n",
        "  <title>", escape(Name), " - ", escape(Title), "</title>\n",
        "  <link rel=\"stylesheet\" href=\"/css/style.css\">\n",
        "  <link rel=\"icon\" type=\"image/svg+xml\" href=\"/favicon.svg\">\n",
        "</head>\n",
        "<body>\n",
        "  <header>\n",
        "    <h1>", escape(Name), "</h1>\n",
        "    <p class=\"job-title\">", escape(Title), "</p>\n",
        "  </header>\n",
        "  <main>\n",
        render_summary(Summary),
        render_experience(Experience),
        render_skills(Skills),
        render_education(Education),
        "  </main>\n",
        render_contact(Contact),
        "</body>\n",
        "</html>\n"
    ]).

render_summary(Summary) ->
    ["    <section id=\"summary\" aria-labelledby=\"summary-heading\">\n",
     "      <h2 id=\"summary-heading\">Summary</h2>\n",
     "      <p>", escape(Summary), "</p>\n",
     "    </section>\n"].

render_experience(Experience) ->
    ["    <section id=\"experience\" aria-labelledby=\"experience-heading\">\n",
     "      <h2 id=\"experience-heading\">Experience</h2>\n",
     [render_role(Role) || Role <- Experience],
     "    </section>\n"].

render_role(Role) ->
    ["      <article class=\"role\">\n",
     "        <h3 class=\"role-title\">", escape(maps:get(title, Role)), "</h3>\n",
     "        <p class=\"role-company\">", escape(maps:get(company, Role)), "</p>\n",
     "        <p class=\"role-dates\">", escape(maps:get(dates, Role)), "</p>\n",
     "        <ul class=\"role-bullets\">\n",
     [["          <li>", escape(Bullet), "</li>\n"] || Bullet <- maps:get(bullets, Role)],
     "        </ul>\n",
     "      </article>\n"].

render_skills(Skills) ->
    ["    <section id=\"skills\" aria-labelledby=\"skills-heading\">\n",
     "      <h2 id=\"skills-heading\">Skills</h2>\n",
     "      <ul class=\"skills-list\">\n",
     [["        <li class=\"skill\">", escape(Skill), "</li>\n"] || Skill <- Skills],
     "      </ul>\n",
     "    </section>\n"].

render_education(Education) ->
    ["    <section id=\"education\" aria-labelledby=\"education-heading\">\n",
     "      <h2 id=\"education-heading\">Education</h2>\n",
     [render_education_entry(Entry) || Entry <- Education],
     "    </section>\n"].

render_education_entry(Entry) ->
    ["      <article class=\"education-entry\">\n",
     "        <h3 class=\"education-degree\">", escape(maps:get(degree, Entry)), "</h3>\n",
     "        <p class=\"education-school\">", escape(maps:get(school, Entry)), "</p>\n",
     "        <p class=\"education-dates\">", escape(maps:get(dates, Entry)), "</p>\n",
     "      </article>\n"].

render_contact(Contact) ->
    Email = maps:get(email, Contact),
    ["  <footer>\n",
     "    <h2 id=\"contact-heading\">Contact</h2>\n",
     "    <address class=\"contact\">\n",
     "      <a class=\"contact-email\" href=\"mailto:", escape(Email), "\">",
     escape(Email), "</a>\n",
     "      <a class=\"contact-phone\" href=\"tel:",
     escape(maps:get(phone, Contact)), "\">", escape(maps:get(phone, Contact)), "</a>\n",
     "      <span class=\"contact-location\">", escape(maps:get(location, Contact)), "</span>\n",
     "      <ul class=\"contact-links\">\n",
     [["        <li><a href=\"", escape(maps:get(url, Link)), "\">",
       escape(maps:get(label, Link)), "</a></li>\n"]
      || Link <- maps:get(links, Contact)],
     "      </ul>\n",
     "    </address>\n",
     "  </footer>\n"].

%% @doc HTML-escape text content. Works on binaries or strings and only
%% rewrites the ASCII characters that are significant in HTML, so UTF-8
%% bytes pass through untouched.
escape(Bin) when is_binary(Bin) ->
    escape(binary_to_list(Bin));
escape(List) when is_list(List) ->
    lists:flatten(escape_chars(List, [])).

escape_chars([], Acc) ->
    lists:reverse(Acc);
escape_chars([$& | Rest], Acc) ->
    escape_chars(Rest, ["&amp;" | Acc]);
escape_chars([$< | Rest], Acc) ->
    escape_chars(Rest, ["&lt;" | Acc]);
escape_chars([$> | Rest], Acc) ->
    escape_chars(Rest, ["&gt;" | Acc]);
escape_chars([$" | Rest], Acc) ->
    escape_chars(Rest, ["&quot;" | Acc]);
escape_chars([Char | Rest], Acc) ->
    escape_chars(Rest, [Char | Acc]).