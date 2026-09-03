%% @doc CV content data module.
%%
%% This module is the single source of truth for the CV content rendered by
%% {@link personal_site_cv_handler}. Every value below is clearly-marked
%% PLACEHOLDER content (persona: Ada Lovelace) so the page design can be
%% reviewed before the real owner's details arrive.
%%
%% To publish a real CV, swap the placeholder values in this file for the
%% owner's actual details. No other module needs to change: the handler
%% renders whatever this module returns, so section structure stays stable.
-module(personal_site_cv).

-export([
    name/0,
    title/0,
    email/0,
    summary/0,
    experience/0,
    skills/0,
    education/0
]).

%% === PLACEHOLDER CONTENT — replace with the real site owner's details ===

%% @doc Full name of the CV owner.
name() ->
    "Ada Lovelace".

%% @doc Job title / headline shown under the name.
title() ->
    "Analytical Engine Programmer & Mathematician".

%% @doc Contact email address.
email() ->
    "ada.lovelace@example.com".

%% @doc Professional summary for the About section.
summary() ->
    "Mathematician and writer, chiefly remembered for the work I did on "
    "Charles Babbage's proposed mechanical general-purpose computer, the "
    "Analytical Engine. I was the first to recognise that the machine had "
    "applications beyond pure calculation, and I published the first "
    "algorithm intended to be carried out by such a machine - an approach "
    "I like to think of as programming before programming existed.".

%% @doc Work experience, newest first.
%% Each entry is a map with company, role, dates and a bullets list.
experience() ->
    [
        #{
            company => "Analytical Engine Project (with Charles Babbage)",
            role => "Algorithm Author & Collaborator",
            dates => "1842 - 1843",
            bullets => [
                "Published the first algorithm intended for execution by a "
                "machine: a method for computing Bernoulli numbers on the "
                "Analytical Engine",
                "Expanded Luigi Menabrea's short memoir into notes over three "
                "times its length, anticipating loops, subroutines, and "
                "symbolic (non-numeric) computation",
                "Advised on the theoretical operation of the Engine and "
                "corresponded regularly with Babbage on its design"
            ]
        },
        #{
            company => "Independent Scholar, London",
            role => "Mathematician & Technical Writer",
            dates => "1833 - 1852",
            bullets => [
                "Studied advanced mathematics under Augustus De Morgan, "
                "covering calculus, analysis, and the foundations of algebra",
                "Translated and popularised continental scientific works for "
                "an English audience, including Menabrea's Sketch of the "
                "Analytical Engine",
                "Participated in the scientific circles of Mary Somerville "
                "and Charles Wheatstone, debating the future of machines and "
                "calculation"
            ]
        }
    ].

%% @doc List of professional skills, rendered as a bullet list.
skills() ->
    [
        "Algorithm design",
        "Mathematical analysis",
        "Symbolic reasoning",
        "Technical writing",
        "Scientific translation (French to English)",
        "Long-form collaborative problem solving"
    ].

%% @doc Education history.
%% Each entry is a map with institution, degree and dates.
education() ->
    [
        #{
            institution => "Mathematical tutelage under Augustus De Morgan, London",
            degree => "Advanced mathematics - calculus, analysis, and algebra",
            dates => "1834 - 1838"
        },
        #{
            institution => "Scientific circles of Mary Somerville, London",
            degree => "Natural philosophy, astronomy, and scientific correspondence",
            dates => "1833 - 1852"
        }
    ].
