%%%-------------------------------------------------------------------
%%% @author Ashen
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%         表格原件，代替地图
%%% @end
%%% Created : 05. 一月 2018 10:24
%%%-------------------------------------------------------------------
-module(grid_test).
-author("Ashen").

-behaviour(wx_object).

%% Client API
-export([start/1]).

%% wx_object callbacks
-export([init/1, terminate/2,  code_change/3,
    handle_info/2, handle_call/3, handle_cast/2, handle_event/2]).

-include_lib("wx/include/wx.hrl").

-define(ROW_NUM, 50).
-define(COL_NUM, 50).

-record(state,
{
    parent,
    config,
    grid,
    enable_cell
}).

start(Config) ->
    wx_object:start_link(?MODULE, Config, []).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
init(Config) ->
    wx:batch(fun() -> do_init(Config) end).

do_init(Config) ->
    Parent = proplists:get_value(parent, Config),
    Panel = wxPanel:new(Parent, []),
    
    %% Setup sizers
    MainSizer = wxBoxSizer:new(?wxVERTICAL),
    Sizer = wxStaticBoxSizer:new(?wxVERTICAL, Panel,
        []),
    
    Grid = create_grid(Panel),
    
    %% Add to sizers
    Options = [{flag, ?wxEXPAND}, {proportion, 1}],
    
    wxSizer:add(Sizer, Grid, Options),
    wxSizer:add(MainSizer, Sizer, Options),
    
    wxPanel:setSizer(Panel, MainSizer),
    [BornCell | TCellList] = maze:init_maze1(?ROW_NUM, ?COL_NUM),
    enable_loop_timer(BornCell, [BornCell | TCellList], Grid),
    {Panel, #state{parent=Panel, config=Config,
        grid = Grid, enable_cell = TCellList}}.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Async Events are handled in handle_event as in handle_info
handle_event(#wx{event = #wxGrid{type = grid_cell_change,
    row = Row, col = Col}},
    State = #state{}) ->
    fame_test:format(State#state.config, "Cell {~p,~p}\n",
        [Row,Col]),
    {noreply, State}.

%% Callbacks handled as normal gen_server callbacks
handle_info(enable_loop, State) ->
    NewState =
    case State#state.enable_cell of
        [] ->
            State;
        [Cell | TCellList] ->
            enable_loop_timer(Cell, [], State#state.grid),
            State#state{enable_cell = TCellList}
    end,
    {noreply, NewState};
handle_info(_Msg, State) ->
    {noreply, State}.

handle_call(shutdown, _From, State=#state{parent=Panel}) ->
    wxPanel:destroy(Panel),
    {stop, normal, ok, State};

handle_call(_Msg, _From, State) ->
    {reply,{error, nyi}, State}.

handle_cast(reset, State) ->
    reset_grid(State#state.grid),
    [BornCell | TCellList] = maze:init_maze1(?ROW_NUM, ?COL_NUM),
    enable_loop_timer(BornCell, [BornCell | TCellList], State#state.grid),
    wxFrame:refresh(State#state.parent),
    {noreply, State};
handle_cast(Msg, State) ->
    io:format("Got cast ~p~n",[Msg]),
    {noreply,State}.

code_change(_, _, State) ->
    {stop, ignore, State}.

terminate(_Reason, _State) ->
    ok.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Local functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

create_grid(Panel) ->
    %% Create the grid with 50 * 50 cells
    RowNum = ?ROW_NUM,
    ColNum = ?COL_NUM,
    Grid = wxGrid:new(Panel, 2, []),
    wxGrid:createGrid(Grid, RowNum, ColNum),
    wxGrid:setRowLabelSize(Grid, 0),
    wxGrid:setColLabelSize(Grid, 0),
    wxGrid:setDefaultRowSize(Grid, 10, []),
    wxGrid:setDefaultColSize(Grid, 10, []),
    lists:foreach(fun(Row) -> lists:foreach(fun(Col) -> wxGrid:setCellBackgroundColour(Grid, Row, Col, ?wxBLACK) end, lists:seq(0, ColNum - 1)) end, lists:seq(0, RowNum - 1)),
    wxGrid:connect(Grid, grid_cell_change),
    Grid.

reset_grid(Grid) ->
    %% Create the grid with 50 * 50 cells
    RowNum = ?ROW_NUM,
    ColNum = ?COL_NUM,
    lists:foreach(fun(Row) -> lists:foreach(fun(Col) -> wxGrid:setCellBackgroundColour(Grid, Row, Col, ?wxBLACK) end, lists:seq(0, ColNum - 1)) end, lists:seq(0, RowNum - 1)).
    

enable_loop_timer({BornX, BornY}, CellList, Grid) ->
    {LastX, LastY} = lists:last(CellList),
    [wxGrid:setCellBackgroundColour(Grid, X, Y, ?wxWHITE) || {X, Y} <- CellList],
    wxGrid:setCellBackgroundColour(Grid, BornX, BornY, ?wxGREEN),
    wxGrid:setCellBackgroundColour(Grid, LastX, LastY, ?wxRED).