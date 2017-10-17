%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%         排序公用模块
%%% @end
%%% Created : 17. 十一月 2017 19:25
%%%-------------------------------------------------------------------
-module(sort_util).
-author("Ashen").

-include("logger.hrl").
%% API
-export([
    init_rand_list/0,
    init_rand_list/1,
    get_permutations/1,
    build_kv_list/2
]).

%% @doc 随机生成一个列表，长度10，元素为1到1000随机，不重复
init_rand_list() ->
    do_init_rand_list(10, lists:seq(1, 1000), []).

init_rand_list(Length) ->
    do_init_rand_list(Length, lists:seq(1, 1000), []).

do_init_rand_list(0, _, RandList) ->
    RandList;
do_init_rand_list(Length, SourceList, RandListAcc) ->
    RandNum = lists:nth(rand(1, length(SourceList)), SourceList),
    NewSourceList = SourceList -- [RandNum],
    do_init_rand_list(Length - 1, NewSourceList, [RandNum | RandListAcc]).

rand(Same, Same) ->
    Same;
rand(Min, Max) ->
    M =	Min	- 1,
    random:uniform(Max - M)	+ M.

%% @doc 获取一个顺序列表的所有排列可能
get_permutations(Num) when Num =< 0 ->
    [];
get_permutations(Num) ->
    do_get_permutations(lists:seq(1, Num), []).

do_get_permutations([H], ResultAcc) ->
    [ResultAcc ++ [H]];
do_get_permutations(NumList, ResultAcc) ->
    Fun = fun(X, Acc) ->
        Acc ++ do_get_permutations(NumList -- [X], ResultAcc ++ [X])
        end,
    lists:foldl(Fun, [], NumList).

%% @doc 组合两个输入的列表，元素一一对应组成原组，多余部分剔除
build_kv_list(KList, VList) ->
    do_build_kv_list(KList, VList, []).

do_build_kv_list([], _, KVList) ->
    KVList;
do_build_kv_list(_, [], KVList) ->
    KVList;
do_build_kv_list([KH | KT], [VH | VT], KVListAcc) ->
    do_build_kv_list(KT, VT, KVListAcc ++ [{KH, VH}]).
    