%%%-------------------------------------------------------------------
%%% @author Ashen
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%         2-路插入排序测试
%%% @end
%%% Created : 22. 十一月 2017 14:43
%%%-------------------------------------------------------------------
-module(two_way_insertion_sort_test).
-author("Administrator").

%% API
-compile([export_all]).

-define(SOURCE_MODULE, two_way_insertion_sort).

do_sort_test() ->
    [] = ?SOURCE_MODULE:sort([]),
    [1] = ?SOURCE_MODULE:sort([1]),
    [1,2] = ?SOURCE_MODULE:sort([1,2]),
    [1,2,3] = ?SOURCE_MODULE:sort([1,2,3]),
    [1,2] = ?SOURCE_MODULE:sort([2,1]),
    [1,2,3] = ?SOURCE_MODULE:sort([3,2,1]),
    [1,2,3] = ?SOURCE_MODULE:sort([3,1,2]),
    ok.

do_binary_sort_test() ->
    [1] = ?SOURCE_MODULE:do_binary_sort(1, []),
    [1,2] = ?SOURCE_MODULE:do_binary_sort(2, [1]),
    [1,2,3] = ?SOURCE_MODULE:do_binary_sort(3, [1,2]),
    [1,2] = ?SOURCE_MODULE:do_binary_sort(1, [2]),
    [1,2,3] = ?SOURCE_MODULE:do_binary_sort(1, [2,3]),
    [1,2,3] = ?SOURCE_MODULE:do_binary_sort(2, [1,3]),
    [1,2,3,4] = ?SOURCE_MODULE:do_binary_sort(2, [1,3,4]),
    [1,2,3,4] = ?SOURCE_MODULE:do_binary_sort(1, [2,3,4]),
    [1,2,3,4] = ?SOURCE_MODULE:do_binary_sort(3, [1,2,4]),
    [1,2,3,4] = ?SOURCE_MODULE:do_binary_sort(4, [1,2,3]),
    ok.

do_spilt_2_way_test() ->
    {[], []} = ?SOURCE_MODULE:do_spilt_2_way(1, []),
    {[], [2]} = ?SOURCE_MODULE:do_spilt_2_way(1, [2]),
    {[1], []} = ?SOURCE_MODULE:do_spilt_2_way(2, [1]),
    {[1], [3]} = ?SOURCE_MODULE:do_spilt_2_way(2, [3,1]),
    {[1], [3]} = ?SOURCE_MODULE:do_spilt_2_way(2, [1,3]),
    {[1], [3,4]} = ?SOURCE_MODULE:do_spilt_2_way(2, [4,1,3]),
    {[1,2], [5,4]} = ?SOURCE_MODULE:do_spilt_2_way(3, [2,4,1,5]),
    {[2,1], [4,5]} = ?SOURCE_MODULE:do_spilt_2_way(3, [1,5,4,2]),
    ok.
    

