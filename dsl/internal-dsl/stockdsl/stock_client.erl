-module(stock_client).
-export([]).
-compile([export_all]).

% action {
%   operation
%   conditions[...]
%   cycles[{
%       conditions[...]
%       }]
%   OnEvents[...]
%

print(Atom) when is_atom(Atom) ->
    io:fwrite("~p \n", [Atom]),
    Atom;
print(List) when is_list(List) ->
    io:fwrite("variable: ~128p~n", [List]),
    List;
print(Integer) when is_integer(Integer) ->
    io:fwrite("~p \n", [Integer]),
    Integer.
print(Text, Atom) when is_atom(Atom) ->
    io:fwrite("~p: ~p \n", [Text, Atom]),
    Atom;
print(Text, Atom) when is_integer(Atom) ->
    io:fwrite("~p: ~p \n", [Text, Atom]),
    Atom;
print(Text, List) when is_list(List) ->
    io:fwrite("~p: ~128p~n", [Text, List]),
    List.
action_builder(Operation, Conditions) ->
    {Operation, Conditions}.
operation(sell, Amount) ->
    {action, sell, Amount};
operation(buy, Amount) ->
    {action, buy, Amount};
operation(list, _) ->
    {action, list, void}.

and_(Exp1, Exp2) ->
    {and_, Exp1, Exp2}.
or_(Exp1, Exp2) ->
    {or_, Exp1, Exp2}.
not_(Exp1) ->
    {not_, Exp1}.

condition(Value, gtn, Stock_reference) when is_atom(Stock_reference) ->
    {condition,
        fun (Server) ->
            Server ! {self(), Stock_reference},
            receive
                {_, Result} ->
                    Value > Result
            end
        end
    };
condition(Value, lsn, Stock_reference) when is_atom(Stock_reference) ->
    {condition,
        fun (Server) ->
            Server ! {self(), Stock_reference},
            receive
                {_, Result} ->
                    Value < Result
            end
        end
    };
condition(Value, eq, Stock_reference) when is_atom(Stock_reference) ->
    {condition,
        fun (Server) ->
            Server ! {self(), Stock_reference},
            receive
                {_, Result} ->
                    Value == Result
            end
        end
    };
condition(Value, lsneq, Stock_reference) when is_atom(Stock_reference) ->
    {condition,
        fun (Server) ->
            Server ! {self(), Stock_reference},
            receive
                {_, Result} ->
                    Value =< Result
            end
        end
    };
condition(Value, gtneq, Stock_reference) when is_atom(Stock_reference) ->
    {condition, 
        fun (Server) ->
            Server ! {self(), Stock_reference},
            receive
                {_, Result} ->
                    Value >= Result
            end
        end
    };
condition(_,_,_) ->
    true.

run(_, []) ->
    exit;
run(Server, [{Operation, Condition} | Rest]) ->
    {_, Op, Amount} = Operation,
    Passes = passes(Server, Condition),
    if  Passes == true ->
        Result = handle(Server, Op, Amount),
        print("Action result is:", Result);
    true -> 
        print("condition_didnt_pass")
    end,
    run(Server, Rest).

handle(Server, Op, Value) ->
    Server ! {self(), {Op, Value}},
    receive
        {_, Result} ->
            Result
    end.

% Should return a boolean
passes(Server, {and_, Fun1, Fun2}) ->
    passes(Server, Fun1) and passes(Server, Fun2);
passes(Server, {or_, Fun1, Fun2}) ->
    passes(Server, Fun1) or passes(Server, Fun2);
passes(Server, {not_, Fun1}) ->
    not passes(Server, Fun1);
passes(Server, {condition, Fun}) ->
    Fun(Server).

test_operations(Server) ->
    {_, Op, Value} = operation(sell, 100),
    300 = handle(Server, Op, Value),
    {_, Op1, Value1} = operation(buy, 10),
    10 = handle(Server, Op1, Value1),
    {_, Op2, _} = operation(list, void),
    3 = handle(Server, Op2, void),
    ok.

test_conditions(Server) ->
    Condition = not_(condition(100, gtn, stock_2)),
    false = passes(Server, Condition),
    ok.

test(Server) ->
    ok = test_operations(Server),
    ok = test_conditions(Server),
    ok.

main(Server) ->
    run(Server,[
    %[
        action_builder(
            operation(sell, 100),
            not_(
                not_(
                    condition(100, gtn, stock_2)
                )
            )
        ),
        action_builder(
            operation(sell, 100),
            not_(
                condition(100, gtn, stock_2)
            )
        ),
        action_builder(
            operation(buy, 3),
            condition(3, eq, stock_1)
            )
    %].
    ]
).