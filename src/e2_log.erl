%% ===================================================================
%% @author Garrett Smith <g@rre.tt>
%% @copyright 2011-2012 Garrett Smith
%%
%% @doc e2 log support.
%%
%% e2_log provides a more terse interface to Erlang's standard
%% [http://www.erlang.org/doc/man/error_logger.html error_logger] module.
%%
%% @end
%% ===================================================================

-module(e2_log).

-export([info/1, info/2, error/1, error/2,
         tty/1,
         add_handler/1, add_handler/2, delete_handler/1]).

-define(is_string(S), is_list(S) orelse is_binary(S)).

%%--------------------------------------------------------------------
%% @doc Log an info message or report.
%%
%% @spec (Info) -> ok
%% Info = string() | term()
%% @end
%%--------------------------------------------------------------------

info(Msg) when ?is_string(Msg) ->
    error_logger:info_msg(Msg);
info(Report) ->
    error_logger:info_report(Report).

%%--------------------------------------------------------------------
%% @doc Log an info message or report.
%%
%% If the first argument is a string, the second argument must be a
%% list of arguments used in message format string.
%%
%% If the first argument is an atom, it is used as the report type for
%% the second argument.
%%
%% @spec (MsgOrType, ArgsOrReport) -> ok
%% MsgOrType = string() | atom()
%% ArgsOrReport = [term()] | term()
%% @end
%%--------------------------------------------------------------------

info(Msg, Args) when ?is_string(Msg) ->
    error_logger:info_msg(Msg, Args);
info(Type, Report) ->
    error_logger:info_report(Type, Report).

%%--------------------------------------------------------------------
%% @doc Logs an error message or report.
%% @spec (Info) -> ok
%% Info = string() | term()
%% @end
%%--------------------------------------------------------------------

error(Msg) when ?is_string(Msg) ->
    error_logger:error_msg(Msg);
error(Report) ->
    error_logger:error_report(Report).

%%--------------------------------------------------------------------
%% @doc Log an error message or report.
%%
%% Refer to {@link info/2} for an explanation on how the arguments are
%% used in this function.
%%
%% @spec (MsgOrType, ArgsOrReport) -> ok
%% MsgOrType = string() | atom()
%% ArgsOrReport = [term()] | term()
%% @end
%%--------------------------------------------------------------------

error(Msg, Args) when ?is_string(Msg) ->
    error_logger:error_msg(Msg, Args);
error(Type, Report) ->
    error_logger:error_report(Type, Report).

%%--------------------------------------------------------------------
%% @doc Turns tty printing on or off.
%% @spec (boolean()) -> ok
%% @end
%%--------------------------------------------------------------------

tty(Flag) ->
    error_logger:tty(Flag).

%%--------------------------------------------------------------------
%% @doc Registered a log handler.
%% @equiv add_handler(Handler, [])
%% @end
%%--------------------------------------------------------------------

add_handler(Handler) ->
    add_handler(Handler, []).

%%--------------------------------------------------------------------
%% @doc Registered a log handler.
%%
%% Log handlers must implement the {@link e2_log_handler} behavior.
%%
%% @spec (Handler, Args) -> ok
%% Handler = atom()
%% Args = term()
%% @end
%%--------------------------------------------------------------------

add_handler(Handler, Args) ->
    gen_event:add_handler(
      error_logger, {e2_log_handler, Handler}, {Handler, Args}).

%%--------------------------------------------------------------------
%% @doc Unregisters a log handler.
%% @spec (Handler) -> ok
%% Handler = atom()
%% @end
%%--------------------------------------------------------------------

delete_handler(Handler) ->
    gen_event:delete_handler(error_logger, {e2_log_handler, Handler}, []).