%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%         直接插入排序
%%%         将一个记录插入到已排序好的有序表中，从而得到一个新，记录数增1的有序表。
%%% @end
%%% Created : 17. 十一月 2017 19:22
%%%-------------------------------------------------------------------
-module(straight_insertion_sort).
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
    SortResult;
do_sort([H | T], SortResultAcc) ->
    do_sort(T,do_insert(H, SortResultAcc, [])).

do_insert(SortNum, [], InsertResult) ->
    lists:reverse([SortNum | InsertResult]);
do_insert(SortNum, [H | T], InsertResultAcc) ->
    case SortNum > H of
        true ->
            do_insert(SortNum, T, [H | InsertResultAcc]);
        false ->
            lists:reverse(InsertResultAcc) ++ [SortNum | [H | T]]
    end.
    
