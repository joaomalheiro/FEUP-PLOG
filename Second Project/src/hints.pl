create_puzzle_hints(Board, NewBoard, LeftHints, UpHints, RightHints, DownHints, N_Hints,Level):-
        generate_hints(Board, LeftHints, UpHints, RightHints, DownHints, N_Hints,Level),
        restrict_hints(NewBoard, LeftHints, UpHints, RightHints, DownHints, N_Hints).


generate_hints(Board, LeftHints, UpHints, RightHints, DownHints, N,Level):-
        generate_hints_aux(Board, LeftHints, [], N,Level),
        transpose(Board, TransposedBoard),
        generate_hints_aux(TransposedBoard, UpHints, [], N,Level),
        reverse_list_of_lists(Board, [], ReversedBoard),
        generate_hints_aux(ReversedBoard, RightHints, [], N,Level),
        reverse_list_of_lists(TransposedBoard, [], TRBoard),
        generate_hints_aux(TRBoard , DownHints, [], N,Level).

    reverse_list_of_lists([], ReversedBoard, ReversedBoard).
    reverse_list_of_lists([H|T], ReversedAux, ReversedBoard):-
        reverse(H, ReversedH),
        append(ReversedAux, [ReversedH], ReversedAux2),
        reverse_list_of_lists(T, ReversedAux2, ReversedBoard).

    generate_hints_aux([], Hints, Hints, _,_).
    generate_hints_aux([H|T], Hints, HintsAux, N,Level):-
        generate_hints_list(H, List, [], 0, N,Level),
        samsort(List, SortedList),
        append(HintsAux, [SortedList], HintsAux2),
        generate_hints_aux(T, Hints, HintsAux2, N,Level).

    generate_hints_list(_, List, List, N, N,_).
    generate_hints_list(H, List, ListAux, Index, N,Level):-
        generate_random_num(1,Level,1),
        Index2 is Index + 1,
        generate_hints_list(H, List, ListAux, Index2, N,1).
    
    
    generate_hints_list(H, List, ListAux, Index, N,Level):-
        nth0(Index, H, Elem),
        append(ListAux, [Elem], ListAux2),
        Index2 is Index + 1,
        generate_hints_list(H, List,ListAux2, Index2, N,Level).


    restrict_hints(Board, LeftHints, UpHints, RightHints, DownHints, N):-
        restrict_hints_aux(Board, LeftHints, N),  
        transpose(Board, TransposedBoard),
        restrict_hints_aux(TransposedBoard, UpHints, N),
        reverse_list_of_lists(Board, [], ReversedBoard),
        restrict_hints_aux(ReversedBoard, RightHints, N),
        reverse_list_of_lists(TransposedBoard, [], TRBoard),
        restrict_hints_aux(TRBoard , DownHints, N).

    restrict_hints_aux([], [], _).
    restrict_hints_aux([_|T], [HHint|THint], N):-
        length(HHint, 0),
        restrict_hints_aux(T, THint, N).
    restrict_hints_aux([H|T], [HHint|THint], N):-
        restrict_hints_aux2(H, HHint, N),
        restrict_hints_aux(T, THint, N).

    restrict_hints_aux2(BoardLine, Hint, N):-
        restrict_hint_constrain(BoardLine, Hint, N).
        
    restrict_hint_constrain(H, Hint, N):-
        length(Residue,N),
        append(Residue, _ , H),
        add_hint_constrain(Hint, Residue).

    add_hint_constrain([], _).
    add_hint_constrain([H | T], Residue):-
        element(_, Residue, H),
        add_hint_constrain(T, Residue).    