%%%-------------------------------------------------------------------
%%% @author Ashen
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%         希尔排序
%%%         先将整个待排序的记录序列分割成为若干子序列分别进行直接插入排序，
%%%         待整个序列中的记录“基本有序”时，再对全体记录进行依次直接插入排序。
%%% @end
%%% Created : 27. 九月 2017 15:37
%%%-------------------------------------------------------------------
-module(shells_sort).
-author("Ashen").

-include("logger.hrl").
%% API
-export([]).

-compile([export_all]).

sort() ->
    sort(sort_util:init_rand_list()).

sort(SourceList) ->
    Increment = length(SourceList) div 2,
    do_sort(SourceList, Increment).

do_sort(SourceList, Increment) ->
    SpiltResult = do_spilt(SourceList, Increment),
    InsertionResult = [straight_insertion_sort:sort(SpiltList) || SpiltList <- SpiltResult],
    MergeResult = do_merge(InsertionResult),
    case Increment =< 1 of
        true ->
            MergeResult;
        false ->
            do_sort(MergeResult, Increment div 2)
    end.

do_spilt([], _Increment) ->
    [];
do_spilt(SourceList, Increment) when Increment =< 1 ->
    [SourceList];
do_spilt(SourceList, Increment) ->
    do_spilt_impel(SourceList, [[] || _ <- lists:seq(1, Increment)], []).


do_spilt_impel([], [], SpiltResult) ->
    lists:reverse(SpiltResult);
do_spilt_impel([], [TempList | TList], SpiltResult) ->
    do_spilt_impel([], TList, [TempList | SpiltResult]);
do_spilt_impel(SourceList, [], SpiltResultAcc) ->
    do_spilt_impel(SourceList, lists:reverse(SpiltResultAcc), []);
do_spilt_impel([H | T], [TempList | TList], SpiltResultAcc) ->
    do_spilt_impel(T, TList, [TempList ++ [H] | SpiltResultAcc]).

do_merge(SourceList) ->
    do_merge_imple(SourceList, [], []).

do_merge_imple([], [], MergeResult) ->
    lists:reverse(MergeResult);
do_merge_imple([], RemindSourceList, MergeResult) ->
    do_merge_imple(lists:reverse(RemindSourceList), [], MergeResult);
do_merge_imple([[] | _], RemindSourceList, MergeResult) ->
    do_merge_imple(lists:reverse(RemindSourceList), [], MergeResult);
do_merge_imple([[H] | TList], RemindSourceLIst, MergeResult) ->
    do_merge_imple(TList, RemindSourceLIst, [H | MergeResult]);
do_merge_imple([[H | T] | TList], RemindSourceLIst, MergeResult) ->
    do_merge_imple(TList, [T | RemindSourceLIst], [H | MergeResult]).