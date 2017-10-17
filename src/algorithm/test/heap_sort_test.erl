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

%% 构建堆算法，从最后一个非叶子节点开始向顶点节点进行
init_heap_test() ->
    ok.

is_sort_heap_list(HeapList) ->
    NodeList = ?SOURCE_MODULE:get_heap_node_list(HeapList),
    HeapLength = length(HeapList),
    NodeLength = length(NodeList),
    Fun = fun(Index) ->
        Num = lists:nth(Index, HeapList),
        [] =:= [ChildIndex || ChildIndex <- [Index * 2, Index * 2 + 1], ChildIndex =< HeapLength, lists:nth(ChildIndex, HeapList) < Num]
        end,
    true = lists:all(Fun, lists:seq(1, NodeLength)).

get_heap_node_list_test() ->
    [] = ?SOURCE_MODULE:get_heap_node_list([]),
    [] = ?SOURCE_MODULE:get_heap_node_list([1]),
    [1] = ?SOURCE_MODULE:get_heap_node_list([1,2]),
    [1] = ?SOURCE_MODULE:get_heap_node_list([1,2,3]),
    [1,2] = ?SOURCE_MODULE:get_heap_node_list([1,2,3,4]),
    ok.
