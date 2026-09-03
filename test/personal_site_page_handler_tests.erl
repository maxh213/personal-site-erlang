-module(personal_site_page_handler_tests).

-include_lib("eunit/include/eunit.hrl").

cv_page_contains_profile_name_test() ->
    Html = personal_site_page_handler:render(),
    ?assertMatch({match, _}, binary:match(Html, <<"Alex Example">>)),
    ?assertMatch({match, _}, binary:match(Html, <<"Software Engineer">>)).

cv_page_contains_major_section_ids_test() ->
    Html = personal_site_page_handler:render(),
    lists:foreach(
        fun(Id) -> ?assertMatch({match, _}, binary:match(Html, Id)) end,
        [<<"id=\"summary\"">>, <<"id=\"experience\"">>,
         <<"id=\"skills\"">>, <<"id=\"education\"">>]
    ).

cv_page_contains_section_headings_test() ->
    Html = personal_site_page_handler:render(),
    lists:foreach(
        fun(Heading) -> ?assertMatch({match, _}, binary:match(Html, Heading)) end,
        [<<"<h2 id=\"summary-heading\">Summary</h2>">>,
         <<"<h2 id=\"experience-heading\">Experience</h2>">>,
         <<"<h2 id=\"skills-heading\">Skills</h2>">>,
         <<"<h2 id=\"education-heading\">Education</h2>">>]
    ).

cv_page_is_complete_html5_document_test() ->
    Html = personal_site_page_handler:render(),
    ?assertMatch({match, _}, binary:match(Html, <<"<!DOCTYPE html>">>)),
    ?assertMatch({match, _}, binary:match(Html, <<"<html lang=\"en\">">>)),
    ?assertMatch({match, _}, binary:match(Html, <<"</html>">>)),
    ?assertMatch({match, _}, binary:match(Html, <<"<meta charset=\"utf-8\">">>)),
    ?assertMatch({match, _}, binary:match(Html, <<"<header>">>)),
    ?assertMatch({match, _}, binary:match(Html, <<"<main>">>)),
    ?assertMatch({match, _}, binary:match(Html, <<"<footer>">>)).

cv_page_links_stylesheet_test() ->
    Html = personal_site_page_handler:render(),
    ?assertMatch(
        {match, _},
        binary:match(Html, <<"<link rel=\"stylesheet\" href=\"/css/style.css\">">>)
    ).

cv_page_footer_shows_contact_info_test() ->
    Html = personal_site_page_handler:render(),
    Contact = maps:get(contact, personal_site_cv:cv()),
    ?assertMatch({match, _}, binary:match(Html, maps:get(email, Contact))),
    ?assertMatch({match, _}, binary:match(Html, maps:get(phone, Contact))),
    ?assertMatch({match, _}, binary:match(Html, maps:get(location, Contact))).

cv_page_renders_experience_items_test() ->
    Html = personal_site_page_handler:render(),
    Experience = maps:get(experience, personal_site_cv:cv()),
    lists:foreach(
        fun(Role) ->
            ?assertMatch({match, _}, binary:match(Html, maps:get(company, Role))),
            ?assertMatch({match, _}, binary:match(Html, maps:get(title, Role)))
        end,
        Experience
    ).

cv_page_renders_skills_and_education_test() ->
    Html = personal_site_page_handler:render(),
    Skills = maps:get(skills, personal_site_cv:cv()),
    lists:foreach(
        fun(Skill) ->
            Escaped = iolist_to_binary(personal_site_page_handler:escape(Skill)),
            ?assertMatch({match, _}, binary:match(Html, Escaped))
        end,
        Skills
    ),
    lists:foreach(
        fun(Entry) ->
            ?assertMatch({match, _}, binary:match(Html, maps:get(school, Entry))),
            ?assertMatch({match, _}, binary:match(Html, maps:get(degree, Entry)))
        end,
        maps:get(education, personal_site_cv:cv())
    ).

escape_escapes_html_special_characters_test() ->
    ?assertEqual(
        "a&amp;b&lt;c&gt;d&quot;e",
        personal_site_page_handler:escape(<<"a&b<c>d\"e">>)
    ).