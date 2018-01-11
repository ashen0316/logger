%%%-------------------------------------------------------------------
%%% @author Ashen
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%         迷宫生成算法
%%% @end
%%% Created : 05. 一月 2018 14:20
%%%-------------------------------------------------------------------
-module(maze).
-author("Ashen").

-include("def_atom.hrl").
-include("def_fun.hrl").

-define(ENABLE_CELL_RATE, 10).

%% API
-export([init_maze/0, init_maze/2]).
-export([init_maze1/0, init_maze1/2]).

init_maze() ->
    init_maze(50, 50).

init_maze(Row, Col) ->
    Seed = os:timestamp(),
    random:seed(Seed),
    BornCell = {sort_util:rand(1, Row), sort_util:rand(1, Col)},
    init_maze(Row, Col, [BornCell], BornCell).

init_maze(Row, Col, EnableCellList, {LastX, LastY}) ->
    case length(EnableCellList) >= (Row * Col) * (?ENABLE_CELL_RATE / 100) of
        ?TRUE ->
            EnableCellList;
        ?FALSE ->
            NextCell = rand_next_cell(Row, Col, EnableCellList, {LastX, LastY}),
            NewEnableCellList =?IF(lists:member(NextCell, EnableCellList), EnableCellList, EnableCellList ++ [NextCell]),
            init_maze(Row, Col, NewEnableCellList, NextCell)
    end.

rand_next_cell(Row, Col, _EnableCellList, {LastX, LastY}) ->
    AllNextCells = [{X, Y} ||
        {X, Y} <- [{LastX - 1, LastY}, {LastX + 1, LastY}, {LastX, LastY + 1}, {LastX, LastY - 1}],
        X >= 0, Y >= 0, X =< Row, Y =< Col],
    lists:nth(sort_util:rand(1, length(AllNextCells)), AllNextCells).

%% ---------------------------------------------------------------------------------------------
init_maze1() ->
    init_maze1(50, 50).

init_maze1(Row, Col) ->
    Seed = os:timestamp(),
    random:seed(Seed),
    BornCell = {sort_util:rand(1, Row), sort_util:rand(1, Col)},
    init_maze1(Row, Col, [BornCell], BornCell, BornCell).

init_maze1(Row, Col, EnableCellList, {LastX, LastY}, OldCell) ->
    case length(EnableCellList) >= (Row * Col) * (?ENABLE_CELL_RATE / 100) of
        ?TRUE ->
            EnableCellList;
        ?FALSE ->
            NextCell = rand_next_cell1(Row, Col, EnableCellList, {LastX, LastY}, OldCell),
            NewEnableCellList =?IF(lists:member(NextCell, EnableCellList), EnableCellList, EnableCellList ++ [NextCell]),
            init_maze1(Row, Col, NewEnableCellList, NextCell, {LastX, LastY})
    end.

rand_next_cell1(Row, Col, _EnableCellList, {LastX, LastY}, OldCell) ->
    AllNextCells = [{X, Y} ||
        {X, Y} <- [{LastX - 1, LastY}, {LastX + 1, LastY}, {LastX, LastY + 1}, {LastX, LastY - 1}],
        X >= 0, Y >= 0, X =< Row, Y =< Col, {X, Y} =/= OldCell],
    lists:nth(sort_util:rand(1, length(AllNextCells)), AllNextCells).