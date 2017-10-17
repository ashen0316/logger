%%%-------------------------------------------------------------------
%%% @author Ashen
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%         二元选择排序
%%%         在要排序的一组数中，选出最小与最大的两个数与第1个位置和最后1个位置的数交换；
%%%         然后在剩下的数当中再找最小和最大的与第2个位置和倒数第2个位置的数交换，
%%%         依次类推，直到第n-1个元素（倒数第二个数）和第n个元素（最后一个数）比较为止。
%%% @end
%%% Created : 10. 十月 2017 14:21
%%%-------------------------------------------------------------------
-module(two_selection_sort).
-author("Ashen").

%% API
-export([]).
-compile([export_all]).

sort() ->
    sort(sort_util:init_rand_list()).

sort(SourceList) ->
    do_sort(SourceList, [], []).

do_sort([], LowList, HighList) ->
    LowList ++ HighList;
do_sort([SingleNum], LowList, HighList) ->
    LowList ++ [SingleNum] ++ HighList;
do_sort(SourceList, LowList, HighList) ->
    MaxNum = lists:max(SourceList),
    MinNum = lists:min(SourceList),
    do_sort(SourceList -- [MinNum, MaxNum], LowList ++ [MinNum], [MaxNum | HighList]).