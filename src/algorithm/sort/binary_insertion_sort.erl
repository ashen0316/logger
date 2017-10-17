%%%-------------------------------------------------------------------
%%% @author Ashen
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%         二分插入排序
%%%         基于直接插入排序的优化，用二分查找寻找插入位置
%%% @end
%%% Created : 20. 十一月 2017 0:35
%%%-------------------------------------------------------------------
-module(binary_insertion_sort).
-author("Ashen").

-include("logger.hrl").
%% API
-export([
    sort/0,
    sort/1
]).

sort() ->
    sort(sort_util:init_rand_list()).

sort(L) ->
    do_sort(L, []).

do_sort([], SortResult) ->
    ?WARNING_MSG("~n sort result:~p", [SortResult]);
do_sort([H | T], SortResultAcc) ->
    do_sort(T,do_binary_insert(H, SortResultAcc, [], [])).

do_binary_insert(Num, [], LowListAcc, HighListAcc) ->
    LowListAcc ++ [Num | HighListAcc];
do_binary_insert(Num, SourceList, LowListAcc, HighListAcc) ->
    %?WARNING_MSG("num:~p, source:~p", [Num, SourceList]),
    MidIndex = (length(SourceList) + 1) div 2,
    HList = lists:sublist(SourceList, MidIndex),
    TList = SourceList -- HList,
    case lists:nth(MidIndex, SourceList) > Num of
        true when length(HList) =:= 1 ->
            LowListAcc ++ [Num | SourceList ++ HighListAcc];
        true ->
            do_binary_insert(Num, HList, LowListAcc, TList ++ HighListAcc);
        false ->
            do_binary_insert(Num, TList, LowListAcc ++ HList, HighListAcc)
    end.
    
