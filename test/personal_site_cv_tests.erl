-module(personal_site_cv_tests).

-include_lib("eunit/include/eunit.hrl").


non_empty_string(String) ->
    ?assert(is_list(String)),
    ?assert(String /= []),
    ?assert(lists:all(fun(C) -> is_integer(C) end, String)),
    ?assert(string:trim(String) /= []).

name_test() ->
    Name = personal_site_cv:name(),
    non_empty_string(Name).

title_test() ->
    non_empty_string(personal_site_cv:title()).

email_test() ->
    Email = personal_site_cv:email(),
    non_empty_string(Email),
    ?assert(string:find(Email, "@") /= nomatch),
    ?assert(string:find(Email, ".") /= nomatch).

summary_test() ->
    Summary = personal_site_cv:summary(),
    non_empty_string(Summary),
    ?assert(length(Summary) > 20).

experience_test() ->
    Exps = personal_site_cv:experience(),
    ?assert(is_list(Exps)),
    ?assert(Exps /= []),
    lists:foreach(fun(Entry) ->
        ?assert(is_map(Entry)),
        ?assert(maps:is_key(company, Entry)),
        ?assert(maps:is_key(role, Entry)),
        ?assert(maps:is_key(dates, Entry)),
        ?assert(maps:is_key(bullets, Entry)),
        non_empty_string(maps:get(company, Entry)),
        non_empty_string(maps:get(role, Entry)),
        non_empty_string(maps:get(dates, Entry)),
        Bullets = maps:get(bullets, Entry),
        ?assert(is_list(Bullets)),
        ?assert(Bullets /= []),
        lists:foreach(fun(B) -> non_empty_string(B) end, Bullets)
    end, Exps).

skills_test() ->
    Skills = personal_site_cv:skills(),
    ?assert(is_list(Skills)),
    ?assert(Skills /= []),
    lists:foreach(fun(S) -> non_empty_string(S) end, Skills).

education_test() ->
    Edu = personal_site_cv:education(),
    ?assert(is_list(Edu)),
    ?assert(Edu /= []),
    lists:foreach(fun(Entry) ->
        ?assert(is_map(Entry)),
        ?assert(maps:is_key(institution, Entry)),
        ?assert(maps:is_key(degree, Entry)),
        ?assert(maps:is_key(dates, Entry)),
        non_empty_string(maps:get(institution, Entry)),
        non_empty_string(maps:get(degree, Entry)),
        non_empty_string(maps:get(dates, Entry))
    end, Edu).

all_sections_present_test() ->
    ?assert(is_list(personal_site_cv:name())),
    ?assert(is_list(personal_site_cv:title())),
    ?assert(is_list(personal_site_cv:email())),
    ?assert(is_list(personal_site_cv:summary())),
    ?assert(is_list(personal_site_cv:experience())),
    ?assert(is_list(personal_site_cv:skills())),
    ?assert(is_list(personal_site_cv:education())).
