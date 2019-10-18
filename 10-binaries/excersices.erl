-module(excersices).
-export([rev/2, term_to_packet/1, packet_to_term/1]).

rev (<<>>, Acc) -> Acc;
% H:1/binary -> Value:Size/TypeSpecifierList, Rest/binary -> Value/TypeSpecifierList
rev (<<H:1/binary, Rest/binary>>, Acc) ->
    erlang:display(H),
    erlang:display(Rest),
    rev(Rest, <<H/binary, Acc/binary>>).

term_to_packet(Term) ->
    Bin = term_to_binary(Term),
    Size = byte_size(Bin),
    erlang:display(Bin),
    erlang:display(Size),
    <<Size:32, Bin/binary>>.

packet_to_term(Packet) ->
    Res = split_binary(Packet,4),
    {<<Size:32>>,_} = Res,
    {_, <<Binary:Size/binary>>} = Res,
    Term = binary_to_term(Binary),
    erlang:display(Term),
    Term.


