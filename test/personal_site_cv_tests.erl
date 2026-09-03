-module(personal_site_cv_tests).

-include_lib("eunit/include/eunit.hrl").

cv_data_has_profile_fields_test() ->
    CV = personal_site_cv:cv(),
    ?assertNotEqual(<<>>, maps:get(name, CV)),
    ?assertNotEqual(<<>>, maps:get(title, CV)),
    ?assertNotEqual(<<>>, maps:get(summary, CV)).

cv_data_has_complete_contact_test() ->
    Contact = maps:get(contact, personal_site_cv:cv()),
    ?assertNotEqual(<<>>, maps:get(email, Contact)),
    ?assertNotEqual(<<>>, maps:get(phone, Contact)),
    ?assertNotEqual(<<>>, maps:get(location, Contact)),
    ?assert(length(maps:get(links, Contact)) > 0).

cv_data_has_non_empty_skills_test() ->
    ?assert(length(maps:get(skills, personal_site_cv:cv())) > 0).

cv_data_has_well_formed_experience_test() ->
    Experience = maps:get(experience, personal_site_cv:cv()),
    ?assert(length(Experience) > 0),
    lists:foreach(
        fun(Role) ->
            ?assertNotEqual(<<>>, maps:get(company, Role)),
            ?assertNotEqual(<<>>, maps:get(title, Role)),
            ?assertNotEqual(<<>>, maps:get(dates, Role)),
            Bullets = maps:get(bullets, Role),
            ?assert(length(Bullets) >= 2),
            ?assert(length(Bullets) =< 3)
        end,
        Experience
    ).

cv_data_has_well_formed_education_test() ->
    Education = maps:get(education, personal_site_cv:cv()),
    ?assert(length(Education) > 0),
    lists:foreach(
        fun(Entry) ->
            ?assertNotEqual(<<>>, maps:get(degree, Entry)),
            ?assertNotEqual(<<>>, maps:get(school, Entry)),
            ?assertNotEqual(<<>>, maps:get(dates, Entry))
        end,
        Education
    ).