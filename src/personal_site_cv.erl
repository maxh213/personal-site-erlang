%% @doc CV content and data.
%%
%% This module is the single place to edit the site's content: name, job
%% title, summary, contact details, skills, work experience and education.
%% Everything below is clearly-marked placeholder data ("Alex Example",
%% "Acme Corp", ...) — swap in real values and the rendered page updates
%% automatically; no handler or markup changes are needed.
-module(personal_site_cv).

-export([cv/0, name/0, title/0]).

%% @doc The complete CV content as a map.
%%
%% Sections:
%%   name        :: binary()          Full name
%%   title       :: binary()          Job title
%%   summary     :: binary()          Short bio/summary
%%   contact     :: map()             email, phone, location, links
%%   skills      :: [binary()]        List of skills
%%   experience  :: [map()]           Roles: company, title, dates, bullets
%%   education   :: [map()]           Entries: degree, school, dates
cv() ->
    #{
        name => name(),
        title => title(),
        summary =>
            <<"Curious software engineer who enjoys building reliable, "
              "maintainable systems and learning new tools along the way. "
              "Placeholder summary - replace with a real bio.">>,
        contact => #{
            email => <<"alex.example@example.com">>,
            phone => <<"+1 (555) 010-2030">>,
            location => <<"Springfield, USA">>,
            links => [
                #{label => <<"GitHub">>, url => <<"https://github.com/alex-example">>},
                #{label => <<"LinkedIn">>, url => <<"https://linkedin.com/in/alex-example">>}
            ]
        },
        skills => [
            <<"Erlang">>,
            <<"OTP">>,
            <<"Cowboy">>,
            <<"REST APIs">>,
            <<"PostgreSQL">>,
            <<"HTML & CSS">>,
            <<"Git">>
        ],
        experience => [
            #{
                company => <<"Acme Corp">>,
                title => <<"Software Engineer">>,
                dates => <<"Jan 2020 - Present">>,
                bullets => [
                    <<"Designed and shipped backend services in Erlang, "
                      "cutting request latency by 30%.">>,
                    <<"Mentored two junior developers and ran the team's "
                      "code-review rotation.">>,
                    <<"Introduced automated deployment checks that reduced "
                      "production incidents.">>
                ]
            },
            #{
                company => <<"Globex Inc.">>,
                title => <<"Junior Developer">>,
                dates => <<"Jun 2017 - Dec 2019">>,
                bullets => [
                    <<"Built and maintained internal web tools used daily by "
                      "over 200 employees.">>,
                    <<"Wrote integration tests that lifted CI confidence from "
                      "60% to 90% coverage.">>
                ]
            }
        ],
        education => [
            #{
                degree => <<"B.Sc. in Computer Science">>,
                school => <<"State University">>,
                dates => <<"2013 - 2017">>
            }
        ]
    }.

%% @doc Convenience accessor for the profile name.
name() ->
    <<"Alex Example">>.

%% @doc Convenience accessor for the job title.
title() ->
    <<"Software Engineer">>.