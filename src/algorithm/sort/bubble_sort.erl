%%%-------------------------------------------------------------------
%%% @author Ashen
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%         冒泡排序
%%%         在要排序的一组数中，对当前还未排好序的范围内的全部数，
%%%         自上而下对相邻的两个数依次进行比较和调整，让较大的数往下沉，较小的往上冒
%%% @end
%%% Created : 24. 十月 2017 10:22
%%%-------------------------------------------------------------------
-module(bubble_sort).
-author("Ashen").

%% API
-compile([export_all]).

sort() ->
    sort(sort_util:init_rand_list()).

sort([]) ->
    [];
sort(SourceList) ->
    Length = length(SourceList),
    NewSourceList = sort_util:build_kv_list(lists:seq(1, Length), SourceList),
    do_sort(NewSourceList, []).

do_sort([{_, Num}], ResultAcc) ->
    [Num | ResultAcc];
do_sort(SourceList, ResultAcc) ->
    Length = length(SourceList),
    Fun = fun(Index, SourceAcc) ->
        {_, Num1} = lists:keyfind(Index, 1, SourceAcc),
        {_, Num2} = lists:keyfind(Index + 1, 1, SourceAcc),
        case Num1 > Num2 of
            true ->
                TempAcc = lists:keystore(Index, 1, SourceAcc, {Index, Num2}),
                lists:keystore(Index + 1, 1, TempAcc, {Index + 1, Num1});
            false ->
                SourceAcc
        end
        end,
    [{_, Num} | T] = lists:reverse(lists:keysort(1, lists:foldl(Fun, SourceList, lists:seq(1, Length - 1)))),
    do_sort(T, [Num | ResultAcc]).