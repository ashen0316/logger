%%%-------------------------------------------------------------------
%%% @author Ashen
%%% @copyright (C) 2017, <COMPANY>
%%% @doc
%%%         数独（九宫格）
%%% @end
%%% Created : 02. 十月 2017 19:21
%%%-------------------------------------------------------------------
-module(sudoku).
-author("Ashen").

-include("logger.hrl").
%% API
-export([]).

-compile([export_all]).

input(TempRowList) ->
    RowList = TempRowList ++ [0 ||_X <- lists:seq(1, 9 - length(TempRowList))],
    Data = get_data(),
    NewData = Data ++ [RowList],
    case ok of
        ok ->
            set_data(NewData);
        {error, Reason} ->
            ?WARNING_MSG("input error:~p, data:~p", [Reason, NewData]),
            skip
    end.
    
answer() ->
    set_possible_num(),
    do_answer().
do_answer() ->
    confirm_single_num(),
    guess_answer(),
    ok.

guess_answer() ->
    Data = get_data(),
    case first_possible_pos() of
        {{X, Y}, PossibleNum} ->
            [begin
                 NewData = set_pos_num(Num, {X, Y}, Data),
                 set_data(NewData),
                 catch do_answer()
             end || Num <- PossibleNum];
        {} ->
            case catch check_data(Data) of
                ok ->
                    ?WARNING_MSG("~n answer:~n~p", [Data]),
                    ok;
                _ ->
                    ok
            end
    end.

check_data(Data) ->
    CheckList = lists:seq(1, 9),
    [[] = CheckList -- get_row_data({X, 0}, Data) || X <- lists:seq(1, 9)],
    [[] = CheckList -- get_column_data({0, Y}, Data) || Y <- lists:seq(1, 9)],
    [[] = CheckList -- get_grid_data({X, Y}, Data) || X <- [1, 4, 7], Y <- [1, 4, 7]],
    ok.

first_possible_pos() ->
    Data = get_data(),
    first_possible_pos({1, 1}, Data).
first_possible_pos({10, _}, _) ->
    {};
first_possible_pos({X, Y}, Data) ->
    {NewX, NewY} = get_next_pos(X, Y),
    case get_pos_num({X, Y}, Data) of
        PosNum when is_integer(PosNum) ->
            first_possible_pos({NewX, NewY}, Data);
        PosNumList ->
            {{X, Y}, PosNumList}
    end.

confirm_single_num() ->
    Data = get_data(),
    NewData = confirm_single_num({1, 1}, Data),
    case Data =:= NewData of
        true ->
            ok;
        false ->
            confirm_single_num()
    end.

confirm_single_num({9, 9}, ResultData) ->
    set_data(ResultData),
    ResultData;
confirm_single_num({X, Y}, DataAcc) ->
    {NewX, NewY} = get_next_pos(X, Y),
    case get_pos_num({X, Y}, DataAcc) of
        PossibleNumList when is_list(PossibleNumList) ->
            RowList = get_row_data({X, Y}, DataAcc),
            NewDataAcc =
            case do_confirm_single_num(PossibleNumList, RowList) of
                [] ->
                    ColumnList = get_column_data({X, Y}, DataAcc),
                    case do_confirm_single_num(PossibleNumList, ColumnList) of
                        [] ->
                            GridList = get_grid_data({X, Y}, DataAcc),
                            case do_confirm_single_num(PossibleNumList, GridList) of
                                [] ->
                                    DataAcc;
                                [ConfirmNum] ->
                                    TempData = reduce_possible({X, Y}, DataAcc, ConfirmNum),
                                    set_pos_num(ConfirmNum, {X, Y}, TempData)
                            end;
                        [ConfirmNum] ->
                            TempData = reduce_possible({X, Y}, DataAcc,ConfirmNum),
                            set_pos_num(ConfirmNum, {X, Y}, TempData)
                    end;
                [ConfirmNum] ->
                    TempData = reduce_possible({X, Y}, DataAcc, ConfirmNum),
                    set_pos_num(ConfirmNum, {X, Y}, TempData)
            end,
            confirm_single_num({NewX, NewY}, NewDataAcc);
        _ ->
            confirm_single_num({NewX, NewY}, DataAcc)
    end.

do_confirm_single_num(PossibleNumList, SourceList) ->
    OtherPossibleNumList = lists:flatten(SourceList) -- PossibleNumList,
    PossibleNumList -- OtherPossibleNumList.

set_possible_num() ->
    Data = get_data(),
    set_possible_num({1, 1}, Data).

set_possible_num({10, _}, ResultData) ->
    set_data(ResultData);
set_possible_num({X, Y}, DataAcc) ->
    {NewX, NewY} = get_next_pos(X, Y),
    case get_pos_num({X, Y}, DataAcc) of
        0 ->
            RowList = get_row_data({X, Y}, DataAcc),
            ColumnList = get_column_data({X, Y}, DataAcc),
            GridList = get_grid_data({X, Y}, DataAcc),
            AppearNumList = [XNum || XNum <- RowList ++ ColumnList ++ GridList, is_integer(XNum), XNum =/= 0],
            PossibleNumList = lists:seq(1, 9) -- AppearNumList,
            NewDataAcc = set_pos_num(PossibleNumList, {X, Y}, DataAcc),
            set_possible_num({NewX, NewY}, NewDataAcc);
        _ ->
            set_possible_num({NewX, NewY}, DataAcc)
    end.

check_input(RowList) ->
    Data = get_data(),
    TempData = Data ++ [RowList],
    RowNum = length(TempData),
    RowResult = [X || X <- RowList, X > 0] -- lists:seq(1, 9),
    case RowResult =:= [] of
        true ->
            Fun = fun(ColumnNum) ->
                ColumnList = get_column_data({RowNum, ColumnNum}, TempData),
                ColumnResult = [X || X <- ColumnList, X > 0] -- lists:seq(1, 9),
                case ColumnResult =:= [] of
                    true ->
                        GridList = get_grid_data({RowNum, ColumnNum}, TempData),
                        GridResult = [X || X <- GridList, X > 0] -- lists:seq(1, 9),
                        GridResult =:= [];
                    false ->
                        false
                end
            
                  end,
            case lists:all(Fun, lists:seq(1, 9)) of
                true ->
                    ok;
                false ->
                    {error, sudoku_rule_limit}
            end;
        false ->
            {error, sudoku_rule_limit}
    end.

get_data() ->
    case erlang:get(sudoku_data) of
        undefined ->
            [];
        Data ->
            Data
    end.

set_data(Data) ->
    erlang:put(sudoku_data, Data).

del_data() ->
    set_data([]).

get_pos_num({X, Y}, Data) ->
    lists:nth(Y, lists:nth(X, Data)).
set_pos_num(PosNum, {X, Y}, Data) ->
    NewPosNum =
    case is_list(PosNum) andalso length(PosNum) =:= 1 of
        true ->
            hd(PosNum);
        false ->
            PosNum
    end,
    RowList = lists:nth(X, Data),
    NewRowList = lists:sublist(RowList, 1, Y - 1) ++ [NewPosNum] ++ lists:sublist(RowList, Y + 1, 9),
    TempData = lists:sublist(Data, 1, X - 1) ++ [NewRowList] ++ lists:sublist(Data, X + 1, 9),
    case is_integer(NewPosNum) of
        true ->
            reduce_possible({X, Y}, TempData, NewPosNum);
        false ->
            TempData
    end.

get_row_data({RowNum, _ColumnNum}, Data) ->
    lists:nth(RowNum, Data).
get_column_data({_RowNum, ColumnNum}, Data) ->
    [lists:nth(ColumnNum, X) || X <- Data].
get_grid_data({RowNum, ColumnNum}, Data) ->
    BeginRow = ((RowNum - 1) div 3) * 3 + 1,
    BeginColumn = ((ColumnNum -1) div 3) * 3 + 1,
    [lists:nth(Y, lists:nth(X, Data)) || X <- lists:seq(BeginRow, BeginRow + 2), Y <- lists:seq(BeginColumn, BeginColumn + 2)].

get_grid_pos({RowNum, ColumnNum}) ->
    BeginRow = ((RowNum - 1) div 3) * 3 + 1,
    BeginColumn = ((ColumnNum -1) div 3) * 3 + 1,
    [{X, Y} || X <- lists:seq(BeginRow, BeginRow + 2), Y <- lists:seq(BeginColumn, BeginColumn + 2)].

get_next_pos(X, Y) ->
    case Y =:= 9 of
        true ->
            {X + 1, 1};
        false ->
            {X, Y + 1}
    end.

reduce_possible({X, Y}, Data, ConfirmNum) ->
    RowList = get_row_data({X, Y}, Data),
    RowFun =
        fun(YAcc, DataAcc) when YAcc =:= Y ->
            DataAcc;
        (YAcc, DataAcc) ->
            case lists:nth(YAcc, RowList) of
                PossibleList when is_list(PossibleList) ->
                    set_pos_num(PossibleList -- [ConfirmNum], {X, YAcc}, DataAcc);
                _ ->
                    DataAcc
            end
             end,
    RowData = lists:foldl(RowFun, Data, lists:seq(1, 9)),
    
    ColumnList = get_column_data({X, Y}, Data),
    ColumnFun =
        fun(XAcc, DataAcc) when XAcc =:= X ->
                DataAcc;
            (XAcc, DataAcc) ->
                case lists:nth(XAcc, ColumnList) of
                    PossibleList when is_list(PossibleList) ->
                        set_pos_num(PossibleList -- [ConfirmNum], {XAcc, Y}, DataAcc);
                    _ ->
                        DataAcc
                end
        end,
    ColumnData = lists:foldl(ColumnFun, RowData, lists:seq(1, 9)),
    
    GridFun =
        fun({XAcc, YAcc}, DataAcc) when XAcc =:= X andalso YAcc =:= Y ->
            DataAcc;
            ({XAcc, YAcc}, DataAcc) ->
                case get_pos_num({XAcc, YAcc}, DataAcc) of
                    PossibleList when is_list(PossibleList) ->
                        set_pos_num(PossibleList -- [ConfirmNum], {XAcc, YAcc}, DataAcc);
                    _ ->
                        DataAcc
                end
        end,
    lists:foldl(GridFun, ColumnData, get_grid_pos({X, Y})).
    

test_data1() ->
    set_data([
        [3,0,2,7,0,0,0,0,9],
        [0,0,8,0,0,0,0,4,5],
        [0,0,4,0,0,1,3,0,0],
        [0,0,0,0,5,9,0,0,0],
        [0,9,0,0,3,0,0,6,0],
        [0,0,0,2,6,0,0,0,0],
        [0,0,1,4,0,0,2,0,0],
        [2,6,0,0,0,0,1,0,0],
        [4,0,0,0,0,2,5,0,3]
    ]).

test_data2() ->
    set_data([
        [0,9,5,0,0,8,0,0,0],
        [0,0,2,0,0,6,7,0,0],
        [0,4,0,0,0,0,0,0,5],
        [0,5,0,0,2,0,0,0,7],
        [0,6,0,0,5,0,0,2,0],
        [4,0,0,0,7,0,0,8,0],
        [2,0,0,0,0,0,0,4,0],
        [0,0,6,1,0,0,3,0,0],
        [0,0,0,3,0,0,2,5,0]
    ]).