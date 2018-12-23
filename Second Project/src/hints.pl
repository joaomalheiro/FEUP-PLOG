create_puzzle_hints(Board, LeftHints, UpHints, RightHints, DownHints, N_Hints):-
        generate_hints(Board, LeftHints, UpHints, RightHints, DownHints, N_Hints),
        restrict_hints(Board, LeftHints, UpHints, RightHints, DownHints, N_Hints).


generate_hints(Board, LeftHints, UpHints, RightHints, DownHints, N):-
        generate_hints_aux(Board, LeftHints, [], N),
        transpose(Board, TransposedBoard),
        generate_hints_aux(TransposedBoard, UpHints, [], N),
        reverse_list_of_lists(Board, [], ReversedBoard),
        generate_hints_aux(ReversedBoard, RightHints, [], N),
        reverse_list_of_lists(TransposedBoard, [], TRBoard),
        generate_hints_aux(TRBoard , DownHints, [], N).

generate_hints(Board, LeftHints, UpHints, RightHints, DownHints, N):-
        generate_hints_aux(Board, LeftHints, [], N),
        transpose(Board, TransposedBoard),
        generate_hints_aux(TransposedBoard, UpHints, [], N),
        reverse_list_of_lists(Board, [], ReversedBoard),
        generate_hints_aux(ReversedBoard, RightHints, [], N),
        reverse_list_of_lists(TransposedBoard, [], TRBoard),
        generate_hints_aux(TRBoard , DownHints, [], N).

    reverse_list_of_lists([], ReversedBoard, ReversedBoard).
    reverse_list_of_lists([H|T], ReversedAux, ReversedBoard):-
        reverse(H, ReversedH),
        append(ReversedAux, [ReversedH], ReversedAux2),
        reverse_list_of_lists(T, ReversedAux2, ReversedBoard).

    generate_hints_aux([], Hints, Hints, _).
    generate_hints_aux([H|T], Hints, HintsAux, N):-
        generate_hints_list(H, List, [], 0, N),
        samsort(List, SortedList),
        append(HintsAux, [SortedList], HintsAux2),
        generate_hints_aux(T, Hints, HintsAux2, N).

    generate_hints_list(_, List, List, N, N).
    generate_hints_list(H, _, _, Index, N):-
        generate_random_num(1,12,1),
        Index2 is Index + 1,
        generate_hints_list(H, _,_, Index2, N).

    generate_hints_list(H, List, ListAux, Index, N):-
        nth0(Index, H, Elem),
        append(ListAux, [Elem], ListAux2),
        Index2 is Index + 1,
        generate_hints_list(H, List,ListAux2, Index2, N).