%%%-------------------------------------------------------------------
%%% @author Ashen
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%         简单选择排序
%%%         在要排序的一组数中，选出最小（或者最大）的一个数与第1个位置的数交换；
%%%         然后在剩下的数当中再找最小（或者最大）的与第2个位置的数交换，
%%%         依次类推，直到第n-1个元素（倒数第二个数）和第n个元素（最后一个数）比较为止。
%%% @end
%%% Created : 28. 九月 2017 14:47
%%%-------------------------------------------------------------------
-module(simple_selection_sort).
-author("Ashen").

-include("logger.hrl").
%% API
-compile([export_all]).

sort() ->
    sort(sort_util:init_rand_list()).

sort(SourceList) ->
    do_sort(SourceList, []).

do_sort([], SortResult) ->
    lists:reverse(SortResult);
do_sort(SourceList, SortResultAcc) ->
    MinNum = lists:min(SourceList),
    do_sort(SourceList -- [MinNum], [MinNum | SortResultAcc]).
