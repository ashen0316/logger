%%%-------------------------------------------------------------------
%%% @author Ashen
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%         堆排序
%%%         初始时把要排序的n个数的序列看作是一棵顺序存储的二叉树（一维数组存储二叉树），
%%%         调整它们的存储序，使之成为一个堆，将堆顶元素输出，得到n 个元素中最小(或最大)的元素。
%%%         然后对前面(n-1)个元素重新调整使之成为堆，输出堆顶元素，得到n 个元素中次小(或次大)的元素。
%%%         依此类推，直到只有两个节点的堆，并对它们作交换，最后得到有n个节点的有序序列。称这个过程为堆排序。
%%% @end
%%% Created : 12. 十月 2017 14:22
%%%-------------------------------------------------------------------
-module(heap_sort).
-author("Ashen").

%% API
-export([]).

-compile([export_all]).

sort() ->
    sort(sort_util:init_rand_list()).

sort([]) ->
    [];
sort(SourceList) ->
    HeapList = init_heap_list(SourceList),
    do_sort(sort_heap_list(HeapList), []).

do_sort([{_, LastNum}], ResultAcc) ->
    ResultAcc ++ [LastNum];
do_sort([{_, Num1}, {_, Num2}], ResultAcc) ->
    ResultAcc ++ lists:sort([Num1, Num2]);
do_sort(HeapList, ResultAcc) ->
    {_, MinNum} = lists:keyfind(1, 1, HeapList),
    HeapLength = length(HeapList),
    {_, LastNum} = lists:keyfind(HeapLength, 1, HeapList),
    TempHeapList = lists:keydelete(HeapLength, 1, HeapList),
    TempHeapList1 = lists:keystore(1, 1, TempHeapList, {1, LastNum}),
    NewHeapList = sort_heap_list(TempHeapList1, [{1, LastNum}]),
    do_sort(NewHeapList, ResultAcc ++ [MinNum]).

get_heap_node_list(HeapList) ->
    lists:sublist(HeapList, 1, length(HeapList) div 2).

init_heap_list(SourceList) ->
    sort_util:build_kv_list(lists:seq(1, length(SourceList)), SourceList).

sort_heap_list(HeapList) ->
    NodeList = get_heap_node_list(HeapList),
    sort_heap_list(HeapList, NodeList).
    

sort_heap_list(HeapList, []) ->
    HeapList;
sort_heap_list(OldHeapList, [{NodeId, NodeNum} | T]) ->
    HeapLength = length(OldHeapList),
    ChildNodeList = [lists:keyfind(ChildIndex, 1, OldHeapList) || ChildIndex <- [NodeId * 2, NodeId * 2 + 1], ChildIndex =< HeapLength],
    {MinNodeId, MinNodeNum} = hd(lists:keysort(2, ChildNodeList)),
    case NodeNum =< MinNodeNum of
        true ->
            sort_heap_list(OldHeapList, T);
        false ->
            TempHeapList = lists:keystore(NodeId, 1, OldHeapList, {NodeId, MinNodeNum}),
            NewHeapList = lists:keystore(MinNodeId, 1, TempHeapList, {MinNodeId, NodeNum}),
            NodeList = get_heap_node_list(NewHeapList),
            UpdateNodeList =
            case lists:keymember(MinNodeId, 1, NodeList) of
                true ->
                    [{MinNodeId, NodeNum} | T];
                false ->
                    T
            end,
            UpdateNodeList1 =
            case lists:keymember(NodeId div 2, 1, T) orelse NodeId =:= 1 of
                true ->
                    UpdateNodeList;
                false ->
                    [lists:keyfind(NodeId div 2, 1, NewHeapList) | UpdateNodeList]
            end,
            sort_heap_list(NewHeapList, UpdateNodeList1)
    end.

    
    