%%%-------------------------------------------------------------------
%%% @author Ashen
%%% @copyright (C) 2017,<COMPANY>
%%% @doc
%%%         希尔排序测试模块
%%% @end
%%% Created : 27. 九月 2017 15:38
%%%-------------------------------------------------------------------
-module(shells_sort_test).
-author("Ashen").

%% API
-compile([export_all]).

-define(SOURCE_MODULE,shells_sort).

do_spilt_test() ->
    [[] = ?SOURCE_MODULE:do_spilt([],X) || X <- lists:seq(1,8)],
    [[1]] = ?SOURCE_MODULE:do_spilt([1],1),
    [[1]] = ?SOURCE_MODULE:do_spilt([1],0),
    [[1,3,5],[2,4]] = ?SOURCE_MODULE:do_spilt([1,2,3,4,5],2),
    [[1,4],[2,5],[3]] = ?SOURCE_MODULE:do_spilt([1,2,3,4,5],3),
    [[1,5],[2],[3],[4]] = ?SOURCE_MODULE:do_spilt([1,2,3,4,5],4),
    [[1],[2],[3],[4],[5]] = ?SOURCE_MODULE:do_spilt([1,2,3,4,5],5),
    [[1],[2],[3],[4],[5],[]] = ?SOURCE_MODULE:do_spilt([1,2,3,4,5],6),
    [[1,3,5,7,9],[2,4,6,8,10]] = ?SOURCE_MODULE:do_spilt([1,2,3,4,5,6,7,8,9,10],2),
    [[1,4,7,10],[2,5,8],[3,6,9]] = ?SOURCE_MODULE:do_spilt([1,2,3,4,5,6,7,8,9,10],3),
    [[1,5,9],[2,6,10],[3,7],[4,8]] = ?SOURCE_MODULE:do_spilt([1,2,3,4,5,6,7,8,9,10],4),
    ok.

do_merge_test() ->
    [] = ?SOURCE_MODULE:do_merge([]),
    [1] = ?SOURCE_MODULE:do_merge([[1]]),
    [1,2,3,4,5] = ?SOURCE_MODULE:do_merge([[1,3,5],[2,4]]),
    [1,2,3,4,5] = ?SOURCE_MODULE:do_merge([[1,4],[2,5],[3]]),
    [1,2,3,4,5] = ?SOURCE_MODULE:do_merge([[1,5],[2],[3],[4]]),
    [1,2,3,4,5] = ?SOURCE_MODULE:do_merge([[1],[2],[3],[4],[5]]),
    [1,2,3,4,5] = ?SOURCE_MODULE:do_merge([[1],[2],[3],[4],[5],[]]),
    [1,2,3,4,5,6,7,8,9,10] = ?SOURCE_MODULE:do_merge([[1,3,5,7,9],[2,4,6,8,10]]),
    [1,2,3,4,5,6,7,8,9,10] = ?SOURCE_MODULE:do_merge([[1,4,7,10],[2,5,8],[3,6,9]]),
    [1,2,3,4,5,6,7,8,9,10] = ?SOURCE_MODULE:do_merge([[1,5,9],[2,6,10],[3,7],[4,8]]),
    ok.

do_sort_test() ->
    [] = ?SOURCE_MODULE:sort([]),
    [[1] = ?SOURCE_MODULE:sort(X) || X <- sort_util:get_permutations(1)],
    [[1,2] = ?SOURCE_MODULE:sort(X) || X <- sort_util:get_permutations(2)],
    [[1,2,3] = ?SOURCE_MODULE:sort(X) || X <- sort_util:get_permutations(3)],
    [[1,2,3,4] = ?SOURCE_MODULE:sort(X) || X <- sort_util:get_permutations(4)],
    [[1,2,3,4,5] = ?SOURCE_MODULE:sort(X) || X <- sort_util:get_permutations(5)],
    [[1,2,3,4,5,6] = ?SOURCE_MODULE:sort(X) || X <- sort_util:get_permutations(6)],
    [[1,2,3,4,5,6,7] = ?SOURCE_MODULE:sort(X) || X <- sort_util:get_permutations(7)],
    [[1,2,3,4,5,6,7,8] = ?SOURCE_MODULE:sort(X) || X <- sort_util:get_permutations(8)],
    [[1,2,3,4,5,6,7,8,9] = ?SOURCE_MODULE:sort(X) || X <- sort_util:get_permutations(9)],
    [11,29,32,40,55,64,76,87,92] = ?SOURCE_MODULE:sort([32,64,11,55,92,29,76,40,87]),
    ok.
