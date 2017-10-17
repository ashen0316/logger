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

sort(SourceList) ->
    HeapList = init_heap_list(SourceList),
    do_sort(HeapList, []).

do_sort(_, _) ->
    ok.

get_heap_node_list(HeapList) ->
    lists:sublist(HeapList, 1, length(HeapList) div 2).

init_heap_list(SourceList) ->
    sort_util:build_kv_list(lists:seq(1, length(SourceList)), SourceList).
    