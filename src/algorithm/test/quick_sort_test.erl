%%%-------------------------------------------------------------------
%%% @author Ashen
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%         快速排序测试模块
%%% @end
%%% Created : 27. 十月 2017 15:43
%%%-------------------------------------------------------------------
-module(quick_sort_test).
-author("Ashen").

%% API
-compile([export_all]).

-define(SOURCE_MODULE, quick_sort).

do_sort_test() ->
    [] = ?SOURCE_MODULE:sort([]),
    [[1] = ?SOURCE_MODULE:sort(X) || X <- sort_util:get_permutations(1)],
    [[1,2] = ?SOURCE_MODULE:sort(X) || X <- sort_util:get_permutations(2)],
    [[1,2,3] = ?SOURCE_MODULE:sort(X) || X <- sort_util:get_permutations(3)],
    [[1,2,3,4] = ?SOURCE_MODULE:sort(X) || X <- sort_util:get_permutations(4)],
    [[1,2,3,4,5] = ?SOURCE_MODULE:sort(X) || X <- sort_util:get_permutations(5)],
    [[1,2,3,4,5,6] = ?SOURCE_MODULE:sort(X) || X <- sort_util:get_permutations(6)],
    [11,29,32,40,55,64,76,87,92] = ?SOURCE_MODULE:sort([32,64,11,55,92,29,76,40,87]),
    ok.

