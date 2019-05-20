%%%-------------------------------------------------------------------
%%% @author Ashen
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%     浅塘游戏的最佳解法
%%%     记录每个块可移动的排列组合，然后递归，算出最小步数
%%% @end
%%% Created : 20. 五月 2019 23:30
%%%-------------------------------------------------------------------
-module(save_fish).
-author("Ashen").

-include("logger.hrl").

%% API
-export([
    test/0
]).

-record(r_pond_block, {
    pos = {0, 0}    % 起点位置(左上方)
    , length = 0    % 长度
    , dir = 0       % 方向
    , is_fish = 0   % 是否鱼
}).

%% 阻挡块的方向
-define(POND_BLOCK_DIR_H, 0).  % 横
-define(POND_BLOCK_DIR_V, 1).  % 竖

%% 鱼塘的大小
-define(POND_MAX_X, 6).
-define(POND_MAX_Y, 6).

%% ====================================================================
%% API functions
%% ====================================================================
start(BlockList) ->
    ok.

%% ====================================================================
%% Local functions
%% ====================================================================
test() ->
    BlockList =
        [
            #r_pond_block{pos = {1, 1}, length = 2, dir = 0}
            , #r_pond_block{pos = {3, 1}, length = 2, dir = 0}
            , #r_pond_block{pos = {5, 1}, length = 2, dir = 1}
            , #r_pond_block{pos = {6, 1}, length = 2, dir = 1}
            , #r_pond_block{pos = {3, 2}, length = 3, dir = 1}
            , #r_pond_block{pos = {1, 3}, length = 2, dir = 0, is_fish = 1}
            , #r_pond_block{pos = {6, 3}, length = 2, dir = 1}
            , #r_pond_block{pos = {4, 4}, length = 2, dir = 1}
            , #r_pond_block{pos = {1, 5}, length = 2, dir = 1}
            , #r_pond_block{pos = {2, 5}, length = 2, dir = 0}
            , #r_pond_block{pos = {2, 6}, length = 2, dir = 0}
            , #r_pond_block{pos = {4, 6}, length = 2, dir = 0}
        ],
    start(BlockList).