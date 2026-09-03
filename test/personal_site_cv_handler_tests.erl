-module(personal_site_cv_handler_tests).

-include_lib("eunit/include/eunit.hrl").

contains(Bin, Sub) when is_binary(Bin), is_list(Sub) ->
    binary:match(Bin, list_to_binary(Sub)) /= nomatch;
contains(Bin, Sub) when is_binary(Bin), is_binary(Sub) ->
    binary:match(Bin, Sub) /= nomatch.

page_html_is_binary_test() ->
    Html = personal_site_cv_handler:page_html(),
    ?assert(is_binary(Html)),
    ?assert(byte_size(Html) > 500).

page_contains_html_tags_test() ->
    Html = personal_site_cv_handler:page_html(),
    ?assert(contains(Html, "<html")),
    ?assert(contains(Html, "</html>")),
    ?assert(contains(Html, "<!DOCTYPE html>")).

page_contains_name_test() ->
    Html = personal_site_cv_handler:page_html(),
    Name = personal_site_cv:name(),
    ?assert(contains(Html, Name)).

page_contains_section_ids_test() ->
    Html = personal_site_cv_handler:page_html(),
    ?assert(contains(Html, "id=\"summary\"")),
    ?assert(contains(Html, "id=\"experience\"")),
    ?assert(contains(Html, "id=\"skills\"")),
    ?assert(contains(Html, "id=\"education\"")),
    ?assert(contains(Html, "id=\"contact\"")).

page_contains_section_headings_test() ->
    Html = personal_site_cv_handler:page_html(),
    ?assert(contains(Html, ">About<")),
    ?assert(contains(Html, ">Experience<")),
    ?assert(contains(Html, ">Skills<")),
    ?assert(contains(Html, ">Education<")),
    ?assert(contains(Html, ">Contact<")).

page_contains_css_link_test() ->
    Html = personal_site_cv_handler:page_html(),
    ?assert(contains(Html, "/css/style.css")).

page_contains_title_tag_test() ->
    Html = personal_site_cv_handler:page_html(),
    ?assert(contains(Html, "<title>")),
    ?assert(contains(Html, "Curriculum Vitae")).

page_escapes_html_chars_test() ->
    Html = personal_site_cv_handler:page_html(),
    ?assert(is_binary(Html)),
    ?assertNot(contains(Html, "<script>")).
