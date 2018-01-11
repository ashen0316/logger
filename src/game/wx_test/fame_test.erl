%%%-------------------------------------------------------------------
%%% @author Ashen
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%         图形化界面，展示迷宫生成过程
%%% @end
%%% Created : 05. 一月 2018 10:25
%%%-------------------------------------------------------------------
-module(fame_test).
-author("Ashen").

-include_lib("wx/include/wx.hrl").

-behaviour(wx_object).
-export([start/0, start/1, start_link/0, start_link/1, format/3,
    init/1, terminate/2,  code_change/3,
    handle_info/2, handle_call/3, handle_cast/2, handle_event/2]).


-record(state, {win, demo, example, selector, log, grid}).

%% For wx-2.9 usage
-ifndef(wxSTC_ERLANG_COMMENT_FUNCTION).
-define(wxSTC_ERLANG_COMMENT_FUNCTION, 14).
-define(wxSTC_ERLANG_COMMENT_MODULE, 15).
-define(wxSTC_ERLANG_COMMENT_DOC, 16).
-define(wxSTC_ERLANG_COMMENT_DOC_MACRO, 17).
-define(wxSTC_ERLANG_ATOM_QUOTED, 18).
-define(wxSTC_ERLANG_MACRO_QUOTED, 19).
-define(wxSTC_ERLANG_RECORD_QUOTED, 20).
-define(wxSTC_ERLANG_NODE_NAME_QUOTED, 21).
-define(wxSTC_ERLANG_BIFS, 22).
-define(wxSTC_ERLANG_MODULES, 23).
-define(wxSTC_ERLANG_MODULES_ATT, 24).
-endif.

start() ->
    start([]).

start(Debug) ->
    wx_object:start(?MODULE, Debug, []).

start_link() ->
    start_link([]).

start_link(Debug) ->
    wx_object:start_link(?MODULE, Debug, []).

format(Config,Str,Args) ->
    Log = proplists:get_value(log, Config),
    wxTextCtrl:appendText(Log, io_lib:format(Str, Args)),
    ok.

-define(DEBUG_NONE, 101).
-define(DEBUG_VERBOSE, 102).
-define(DEBUG_TRACE, 103).
-define(DEBUG_DRIVER, 104).

init(Options) ->
    wx:new(Options),
    process_flag(trap_exit, true),
    
    Frame = wxFrame:new(wx:null(), ?wxID_ANY, "wxErlang widgets", [{size,{1000,900}}]),
    MB = wxMenuBar:new(),
    File    = wxMenu:new([]),
    %wxMenu:append(File, ?wxID_PRINT, "&Print code"),
    %wxMenu:appendSeparator(File),       %% 添加一条横线
    wxMenu:append(File, ?wxID_EXIT, "Quit"),
    %Debug    = wxMenu:new([]),
    %wxMenu:appendRadioItem(Debug, ?DEBUG_NONE, "None"),
    %wxMenu:appendRadioItem(Debug, ?DEBUG_VERBOSE, "Verbose"),
    %wxMenu:appendRadioItem(Debug, ?DEBUG_TRACE, "Trace"),
    %wxMenu:appendRadioItem(Debug, ?DEBUG_DRIVER, "Driver"),
    Help    = wxMenu:new([]),
    wxMenu:append(Help, ?wxID_HELP, "Reset"),
    wxMenu:append(Help, ?wxID_ABOUT, "About"),
    wxMenuBar:append(MB, File, "&File"),
    %wxMenuBar:append(MB, Debug, "&Debug"),
    wxMenuBar:append(MB, Help, "&Help"),
    wxFrame:setMenuBar(Frame,MB),
    
    wxFrame:connect(Frame, command_menu_selected),     % 右上角按钮选中状态
    wxFrame:connect(Frame, close_window),
    
    _SB = wxFrame:createStatusBar(Frame,[]),
    
    %%   T        Uppersplitter
    %%   O        Left   |    Right
    %%   P  Widgets|Code |    Demo
    %%   S  -------------------------------
    %%   P          Log Window
    TopSplitter   = wxSplitterWindow:new(Frame, [{style, ?wxSP_NOBORDER}]),
    %UpperSplitter = wxSplitterWindow:new(TopSplitter, [{style, ?wxSP_NOBORDER}]),
    %LeftSplitter  = wxSplitterWindow:new(UpperSplitter, [{style, ?wxSP_NOBORDER}]),
    %% Setup so that sizers and initial sizes, resizes the windows correct
    wxSplitterWindow:setSashGravity(TopSplitter,   0.5),
    %wxSplitterWindow:setSashGravity(UpperSplitter, 0.60),
    %wxSplitterWindow:setSashGravity(LeftSplitter,  0.20),
    
    %% LeftSplitter:
    %Example = fun(Beam) ->
    %        "ex_" ++ F = filename:rootname(Beam),
    %    F
    %          end,
    % TODO
    %Mods = ["grid"],
    %
    %CreateLB = fun(Parent) ->
    %    wxListBox:new(Parent, ?wxID_ANY,
    %        [{style, ?wxLB_SINGLE},
    %            {choices, Mods}])
    %           end,
    %{LBPanel, [LB],_} = create_subwindow(LeftSplitter, "Example", [CreateLB]),
    %wxListBox:setSelection(LB, 0),
    %wxListBox:connect(LB, command_listbox_selected),
    %
    %CreateCode = fun(Parent) ->
    %    code_area(Parent)
    %             end,
    %{CodePanel, [Code],_} = create_subwindow(LeftSplitter, "Code", [CreateCode]),
    %
    %wxSplitterWindow:splitVertically(LeftSplitter, LBPanel, CodePanel,
    %    [{sashPosition,150}]),
    
    %% Demo:
    {DemoPanel, [], DemoSz} = create_subwindow(TopSplitter, "Show", []),
    
    %% UpperSplitter:
    %wxSplitterWindow:splitVertically(UpperSplitter, LeftSplitter, DemoPanel,
    %    [{sashPosition,10}]),
    
    %% TopSplitter:
    AddEvent = fun(Parent) ->
        EventText = wxTextCtrl:new(Parent,
            ?wxID_ANY,
            [{style, ?wxTE_DONTWRAP bor
                ?wxTE_MULTILINE bor ?wxTE_READONLY}
            ]),
        wxTextCtrl:appendText(EventText, "Result\n"),
        EventText
               end,
    
    {EvPanel, [EvCtrl],_} = create_subwindow(TopSplitter, "Result", [AddEvent]),
    
    wxSplitterWindow:splitVertically(TopSplitter, DemoPanel, EvPanel,
        [{sashPosition,-200}]),
    
    wxFrame:show(Frame),
    
    State = #state{win=Frame, demo={DemoPanel,DemoSz}, selector=EvPanel, log=EvCtrl},
    %% Load the first example:
    %Ex = wxListBox:getStringSelection(LB),
    process_flag(trap_exit, true),
    {_, _, _, GridPid} = ExampleObj = load_example("grid", State),
    wxSizer:add(DemoSz, ExampleObj, [{proportion,1}, {flag, ?wxEXPAND}]),
    wxSizer:layout(DemoSz),
    
    %% The windows should be set up now, Reset Gravity so we get what we want
    wxSplitterWindow:setSashGravity(TopSplitter,   1.0),
    %wxSplitterWindow:setSashGravity(UpperSplitter, 0.0),
    %wxSplitterWindow:setSashGravity(LeftSplitter,  0.0),
    wxSplitterWindow:setMinimumPaneSize(TopSplitter, 1),
   % wxSplitterWindow:setMinimumPaneSize(UpperSplitter, 1),
    %wxSplitterWindow:setMinimumPaneSize(LeftSplitter, 1),
    
    wxToolTip:enable(true),
    wxToolTip:setDelay(500),
    
    {Frame, State#state{example=ExampleObj, grid = GridPid}}.

create_subwindow(Parent, BoxLabel, Funs) ->
    Panel = wxPanel:new(Parent),
    Sz    = wxStaticBoxSizer:new(?wxVERTICAL, Panel, [{label, BoxLabel}]),
    wxPanel:setSizer(Panel, Sz),
    Ctrls = [Fun(Panel) || Fun <- Funs],
    [wxSizer:add(Sz, Ctrl, [{proportion, 1}, {flag, ?wxEXPAND}])
        || Ctrl <- Ctrls],
    {Panel, Ctrls, Sz}.

%%%%%%%%%%%%
%% Callbacks

%% Handled as in normal gen_server callbacks
handle_info({'EXIT',_, wx_deleted}, State) ->
    {noreply,State};
handle_info({'EXIT',_, shutdown}, State) ->
    {noreply,State};
handle_info({'EXIT',_, normal}, State) ->
    {noreply,State};
handle_info(Msg, State) ->
    io:format("Got Info ~p~n",[Msg]),
    {noreply,State}.

handle_call(Msg, _From, State) ->
    io:format("Got Call ~p~n",[Msg]),
    {reply,ok,State}.

handle_cast(Msg, State) ->
    io:format("Got cast ~p~n",[Msg]),
    {noreply,State}.

%% Async Events are handled in handle_event as in handle_info
handle_event(#wx{id = Id,
    event = #wxCommand{type = command_menu_selected}},
    State = #state{grid = GridPid}) ->
    case Id of
        ?wxID_HELP ->
            gen_server:cast(GridPid, reset),
            {noreply, State};
        ?wxID_ABOUT ->
            AboutString =
                "Demo of various widgets\n"
                "Authors: Olle & Dan",
            wxMessageDialog:showModal(wxMessageDialog:new(State#state.win, AboutString,
                [{style,
                    ?wxOK bor
                        ?wxICON_INFORMATION bor
                        ?wxSTAY_ON_TOP},
                    {caption, "About"}])),
            {noreply, State};
        ?wxID_EXIT ->
            wx_object:call(State#state.example, shutdown),
            {stop, normal, State};
        _ ->
            {noreply, State}
    end;
handle_event(#wx{event=#wxClose{}}, State = #state{win=Frame}) ->
    io:format("~p Closing window ~n",[self()]),
    ok = wxFrame:setStatusText(Frame, "Closing...",[]),
    {stop, normal, State};
handle_event(Ev,State) ->
    io:format("~p Got event ~p ~n",[?MODULE, Ev]),
    {noreply, State}.

code_change(_, _, State) ->
    {stop, not_yet_implemented, State}.

terminate(_Reason, State = #state{win=Frame}) ->
        catch wx_object:call(State#state.example, shutdown),
    wxFrame:destroy(Frame),
    wx:destroy().

%%%%%%%%%%%%%%%%% Internals %%%%%%%%%%

load_example(Ex, #state{demo={DemoPanel,DemoSz}, log=EvCtrl}) ->
    ModStr = Ex ++ "_test",
    Mod = list_to_atom(ModStr),
    %ModFile = "../src/game/wx_test/" ++ ModStr ++ ".erl",
    %load_code(Code, file:read_file(ModFile)),
    %find(Code),
    Mod:start([{parent, DemoPanel}, {demo_sz, DemoSz}, {log, EvCtrl}]).

