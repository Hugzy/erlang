-module(stock_client).
-export([]).
-compile([export_all]).

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


% action {
%   operation
%   conditions[...]
%   cycles[{
%       conditions[...]
%       }]
%   OnEvents[...]
%

action_builder(Operation, [Conditions]) ->
    {Operation, Conditions}.
operation(sell, Amount) ->
    {action, sell, Amount};
operation(buy, Amount) ->
    {action, buy, Amount};
operation(list, _) ->
    {action, list, void}.

and_(Exp1, Exp2) ->
    fun(Op1, Op2, Variable) ->
        Exp1(Op1, Variable) and Exp2(Op2, Variable)
    end.
or_(Exp1, Exp2) ->
    fun(Op1, Op2, V_lhs, V_rhs) ->
        Exp1(Op1, V_lhs) or Exp2(Op2, V_rhs)
    end.
not_(Exp1) ->
    fun(Op, Variable) ->
        Exp1(Op, Variable)
    end.

condition(gtn, Variabel) ->
    fun (Server, Lhs) ->
        Server ! {self(), Variabel},
        receive
            {_, Result} ->
                Lhs > Result
        end
    end;
condition(lsn, Variabel) ->
    fun (Server, Lhs) ->
        Server ! {self(), Variabel},
        receive
            {_, Result} ->
                Lhs < Result
        end
    end;
condition(eq, Variabel) ->
    fun (Server, Lhs) ->
        Server ! {self(), Variabel},
        receive
            {_, Result} ->
                Lhs == Result
        end
    end;
condition(lsneq, Variabel) ->
    fun (Server, Lhs) ->
        Server ! {self(), Variabel},
        receive
            {_, Result} ->
                Lhs =< Result
        end
    end;
condition(gtneq, Variabel) ->
    fun (Server, Lhs) ->
        Server ! {self(), Variabel},
        receive
            {_, Result} ->
                Lhs >= Result
        end
    end.

run(Server, []) ->
    exit;
run(Server, [{Operation, Conditions} | Rest]) ->
    {_, Op, Amount} = Operation,
    Passes = passes(Conditions),
    if  Passes == true ->
        handle(Op, Amount);
    true -> 
        condition_didnt_pass
    end,
    print("Operation", Op),
    print("amount", Amount).

    %print("sending msg"),
    %Server ! {self(), {sell, Amount}},
    %receive
    %    {Server, SoldAmount} ->
    %        print("receiving msg"),
    %        print("client", SoldAmount)
    %end.

handle(Op, Amount) ->
    ok.

% Should return a boolean
passes([]) ->
    true;
passes(Conditions) ->
    ok;
passes([{and_, Fun1, Fun2} | Rest]) ->
    ok;
passes([{or_, Fun1, Fun2} | Rest]) ->
    ok;
passes([{not_, Fun1} | Rest]) ->
    ok.


test() ->
    ok.

main(Server) ->
    run(Server,[
    %[
        action_builder(
            operation(sell, 100),
            [
                not_(
                    or_(                    
                        and_(
                            condition(gtn, stock_1),
                            condition(gtn, stock_2)
                        ),
                        condition(eq, stock_3)
                    )
                )
            ]),
        action_builder(
            operation(buy, 3),
            [
                condition(eq, stock_1)
            ])
    %].
    ]
).