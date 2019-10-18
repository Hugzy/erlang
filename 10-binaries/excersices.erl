-module(excersices).
-export([rev/2, term_to_packet/1, packet_to_term/1, rev_binary/1, test/0]).

test() ->
    Packet1 = term_to_packet(hello),
    Packet2 = term_to_packet(fox),
    <<0,0,0,9,131,100,0,5,104,101,108,108,111>> = Packet1,
    <<0,0,0,7,131,100,0,3,102,111,120>> = Packet2,
    hello = packet_to_term(Packet1),
    fox = packet_to_term(Packet2),
    ok.


rev (<<>>, Acc) -> Acc;
% H:1/binary -> Value:Size/TypeSpecifierList, Rest/binary -> Value/TypeSpecifierList
rev (<<H:1/binary, Rest/binary>>, Acc) ->
    rev(Rest, <<H/binary, Acc/binary>>).

term_to_packet(Term) ->
    Bin = term_to_binary(Term),
    Size = byte_size(Bin),
    <<Size:32, Bin/binary>>.

packet_to_term(Packet) ->
    Res = split_binary(Packet,4),
    {<<Size:32>>,_} = Res,
    {_, <<Binary:Size/binary>>} = Res,
    Term = binary_to_term(Binary),
    Term.

rev_binary(Binary) ->
    <<A:1, B:1, C:1, D:1, E:1, F:1, G:1, H:1>> = Binary,
    <<H:1, G:1, F:1, E:1, D:1, C:1, B:1, A:1>>.