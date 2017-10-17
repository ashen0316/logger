%%%-------------------------------------------------------------------
%%% @author Ashen
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%         2-路插入排序
%%%         基于二分插入排序的优化，将待排序字段根据第一个数字分为两段，进行二分插入排序
%%% @end
%%% Created : 22. 十一月 2017 14:40
%%%-------------------------------------------------------------------
-module(two_way_insertion_sort).
-author("Ashen").
-include("logger.hrl").
%% API
-export([
    sort/0,
    sort/1
]).

-compile([export_all]).

sort() ->
    sort(sort_util:init_rand_list()).

sort([]) ->
    [];
sort([H | T]) ->
    {LowList, HighList} = do_spilt_2_way(H, T),
    SortLowList = do_sort(LowList, []),
    SortHighList = do_sort(HighList, []),
    SortResult = SortLowList ++ [H] ++ SortHighList,
    ?WARNING_MSG("~n sort result:~p", [SortResult]),
    SortResult.

do_sort([], SortResult) ->
    SortResult;
do_sort([H | T], SortResultAcc) ->
    do_sort(T,do_binary_sort(H, SortResultAcc, [], [])).

do_spilt_2_way(StandardNum, SourceList) ->
    do_spilt_2_way(StandardNum, SourceList, [], []).
do_spilt_2_way(_StandardNum, [], LowList, HighList) ->
    {LowList, HighList};
do_spilt_2_way(StandardNum, [H | T], LowListAcc, HighLitsAcc) when H > StandardNum ->
    do_spilt_2_way(StandardNum, T, LowListAcc, [H | HighLitsAcc]);
do_spilt_2_way(StandardNum, [H | T], LowListAcc, HighLitsAcc) ->
    do_spilt_2_way(StandardNum, T, [H | LowListAcc], HighLitsAcc).

do_binary_sort(Num, SourceList) ->
    do_binary_sort(Num, SourceList, [], []).
do_binary_sort(Num, [], LowListAcc, HighListAcc) ->
    LowListAcc ++ [Num | HighListAcc];
do_binary_sort(Num, SourceList, LowListAcc, HighListAcc) ->
    %?WARNING_MSG("num:~p, source:~p", [Num, SourceList]),
    MidIndex = (length(SourceList) + 1) div 2,
    HList = lists:sublist(SourceList, MidIndex),
    TList = SourceList -- HList,
    case lists:nth(MidIndex, SourceList) > Num of
        true when length(HList) =:= 1 ->
            LowListAcc ++ [Num | SourceList ++ HighListAcc];
        true ->
            do_binary_sort(Num, HList, LowListAcc, TList ++ HighListAcc);
        false ->
            do_binary_sort(Num, TList, LowListAcc ++ HList, HighListAcc)
    end.
