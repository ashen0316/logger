%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. 九月 2017 14:48
%%%-------------------------------------------------------------------
-module(sort_util_test).
-author("Administrator").

%% API
-compile([export_all]).

-define(SOURCE_MODULE,sort_util).

get_permutations_test() ->
    [] = ?SOURCE_MODULE:get_permutations(0),
    [] = ?SOURCE_MODULE:get_permutations(-1),
    [] = ?SOURCE_MODULE:get_permutations(-657),
    [[1]] = ?SOURCE_MODULE:get_permutations(1),
    [[1,2],[2,1]] = ?SOURCE_MODULE:get_permutations(2),
    [[1,2,3],[1,3,2],[2,1,3],[2,3,1],[3,1,2],[3,2,1]] = ?SOURCE_MODULE:get_permutations(3),
    [
        [1,2,3,4],[1,2,4,3],[1,3,2,4],[1,3,4,2],[1,4,2,3],[1,4,3,2],
        [2,1,3,4],[2,1,4,3],[2,3,1,4],[2,3,4,1],[2,4,1,3],[2,4,3,1],
        [3,1,2,4],[3,1,4,2],[3,2,1,4],[3,2,4,1],[3,4,1,2],[3,4,2,1],
        [4,1,2,3],[4,1,3,2],[4,2,1,3],[4,2,3,1],[4,3,1,2],[4,3,2,1]
    ] = ?SOURCE_MODULE:get_permutations(4),
    ok.
