%%%-------------------------------------------------------------------
%%% @author Ashen
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%         堆排序测试模块
%%% @end
%%% Created : 12. 十月 2017 14:21
%%%-------------------------------------------------------------------
-module(heap_sort_test).
-author("Ashen").

%% API
-compile([export_all]).

-define(SOURCE_MODULE,heap_sort).

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

%% 构建堆算法，从最后一个非叶子节点开始向顶点节点进行
sort_heap_test() ->
    [] = ?SOURCE_MODULE:sort_heap_list([]),
    [{1, 1}] = ?SOURCE_MODULE:sort_heap_list([{1, 1}]),
    [{1, 1}, {2, 5}] = ?SOURCE_MODULE:sort_heap_list([{1, 1}, {2, 5}]),
    [{1, 1}, {2, 5}] = ?SOURCE_MODULE:sort_heap_list([{1, 5}, {2, 1}]),
    [{1, 1}, {2, 5}, {3, 6}] = ?SOURCE_MODULE:sort_heap_list([{1, 5}, {2, 1}, {3, 6}]),
    [{1, 1}, {2, 6}, {3, 5}] = ?SOURCE_MODULE:sort_heap_list([{1, 5}, {2, 6}, {3, 1}]),
    [{1, 1}, {2, 5}, {3, 6}] = ?SOURCE_MODULE:sort_heap_list([{1, 6}, {2, 5}, {3, 1}]),
    [{1, 1}, {2, 5}, {3, 6}] = ?SOURCE_MODULE:sort_heap_list([{1, 1}, {2, 5}, {3, 6}]),
    [{1,1},{2,2},{3,6},{4,3},{5,7},{6,8},{7,9}] = ?SOURCE_MODULE:sort_heap_list([{1, 3}, {2, 2}, {3, 6},{4,1},{5,7},{6,8},{7,9}]),
    ok.

is_sort_heap_list(HeapList) ->
    NodeList = ?SOURCE_MODULE:get_heap_node_list(HeapList),
    HeapLength = length(HeapList),
    NodeLength = length(NodeList),
    Fun = fun(Index) ->
        Num = get_node_num(Index, HeapList),
        [] =:= [ChildIndex || ChildIndex <- [Index * 2, Index * 2 + 1], ChildIndex =< HeapLength, get_node_num(ChildIndex, HeapList) < Num]
        end,
    true = lists:all(Fun, lists:seq(1, NodeLength)).

get_node_num(NodeIndex, HeapList) ->
    {_, NodeNum} = lists:keyfind(NodeIndex, 1, HeapList),
    NodeNum.

get_heap_node_list_test() ->
    [] = ?SOURCE_MODULE:get_heap_node_list([]),
    [] = ?SOURCE_MODULE:get_heap_node_list([1]),
    [1] = ?SOURCE_MODULE:get_heap_node_list([1,2]),
    [1] = ?SOURCE_MODULE:get_heap_node_list([1,2,3]),
    [1,2] = ?SOURCE_MODULE:get_heap_node_list([1,2,3,4]),
    ok.
