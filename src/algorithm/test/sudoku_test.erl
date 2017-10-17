%%%-------------------------------------------------------------------
%%% @author Ashen
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%         数独测试
%%% @end
%%% Created : 02. 十月 2017 19:23
%%%-------------------------------------------------------------------
-module(sudoku_test).
-author("Ashen").

-define(SOURCE_MOD, sudoku).

%% API
-export([
    test/0
]).

test() ->
    check_input_test(),
    ok.

check_input_test() ->
    [{error, length_equal_nine} = ?SOURCE_MOD:check_input(lists:seq(1, X)) || X <- lists:seq(0, 8)],
    {error, sudoku_rule_limit} = ?SOURCE_MOD:check_input([1 || _ <- lists:seq(1, 9)]),
    ?SOURCE_MOD:set_data([lists:seq(1, 9), [0 || _ <- lists:seq(1, 9)],[0 || _ <- lists:seq(1, 9)]]),
    {error, sudoku_rule_limit} = ?SOURCE_MOD:check_input(lists:seq(1, 9)),
    ?SOURCE_MOD:del_data(),
    ?SOURCE_MOD:set_data([[1,0,0,0,0,0,0,0,0]]),
    {error, sudoku_rule_limit} = ?SOURCE_MOD:check_input([0,1,0,0,0,0,0,0,0]),
    ?SOURCE_MOD:del_data(),
    ok.
    