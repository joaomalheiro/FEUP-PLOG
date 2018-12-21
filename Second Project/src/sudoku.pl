:- use_module(library(clpfd)).
:- use_module(library(lists)).
:- use_module(library(system)).
:- use_module(library(random)).

    % Starts game
    start:-
        now(Seed),
        setrand(Seed),
        create_board(Board, 4),
        N is round(sqrt(4)),
        domain_board(Board,4),
        restrict_lines(Board), restrict_columns(Board), restrict_squares(Board),
        term_variables(Board, BoardLine),
        labeling([value(mySelValores)], BoardLine),
        write(Board), nl,
        generate_hints(Board, LeftHints, UpHints, RightHints, DownHints, N),
        create_board(NewBoard, 4),
        domain_board(NewBoard, 4),
        restrict_lines(NewBoard), restrict_columns(NewBoard), restrict_squares(NewBoard),
        restrict_hints(NewBoard, LeftHints, UpHints, RightHints, DownHints),
        term_variables(NewBoard, NewBoardLine),
        labeling([], NewBoardLine),
        write(NewBoard).
    
    mySelValores(Var, _Rest, BB, BB1) :-
        fd_set(Var, Set),
        select_best_value(Set, Value),
        (   
            first_bound(BB, BB1), Var #= Value
            ;   
            later_bound(BB, BB1), Var #\= Value
        ).
    
    select_best_value(Set, BestValue):-
        fdset_to_list(Set, Lista),
        length(Lista, Len),
        random(0, Len, RandomIndex),
        nth0(RandomIndex, Lista, BestValue).

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

    generate_hints_aux([], Hints, Hints, N).
    generate_hints_aux([H|T], Hints, HintsAux, N):-
        generate_hints_list(H, List, [], 0, N),
        sort(List, SortedList),
        append(HintsAux, [SortedList], HintsAux2),
        generate_hints_aux(T, Hints, HintsAux2, N).

    generate_hints_list(H, List, List, N, N).
    generate_hints_list(H, List, ListAux, Index, N):-
        nth0(Index, H, Elem),
        append(ListAux, [Elem], ListAux2),
        Index2 is Index + 1,
        generate_hints_list(H, List,ListAux2, Index2, N).
        

    create_board(NewBoard, LineSize):-
        create_board_aux(NewBoard, [], 0, LineSize).
    create_board_aux(NewBoard, NewBoard, LineSize, LineSize).
    create_board_aux(NewBoard, NewBoardAux, I, LineSize):-
        length(NewLine, LineSize),
        append(NewBoardAux, [NewLine], NewBoardAux2),
        I2 is I+1,
        create_board_aux(NewBoard, NewBoardAux2, I2, LineSize).
        
    create_squares([H|T], SquaresBoard):-
        length(H, Size),
        Square is round(sqrt(Size)),
        create_squares_aux_vertical([H|T] , SquaresBoard, [], Square, 0, Size).

    create_squares_aux_vertical(Board, SquaresBoard, SquaresBoard, N, Max, Max).
    create_squares_aux_vertical(Board, SquaresBoard, SquaresBoardAux, N, I, Max):-
        create_squares_aux_horizontal(Board, SquaresBoardLine, [], N, I, 0, Max),
        append(SquaresBoardAux, SquaresBoardLine, SquaresBoardAux2),
        I2 is I + N,
        create_squares_aux_vertical(Board, SquaresBoard, SquaresBoardAux2, N, I2, Max).
        
    create_squares_aux_horizontal(Board, SquaresBoard, SquaresBoard, N, Line, Max, Max).
    create_squares_aux_horizontal(Board, SquaresBoard, SquaresBoardAux, N, Line, I, Max):-
        create_squares_aux2_vertical(Board, H2, [], I, Line, N, 0),
        append(SquaresBoardAux, [H2], SquaresBoardAux2),
        I2 is I + N,
        create_squares_aux_horizontal(Board, SquaresBoard, SquaresBoardAux2, N, Line, I2, Max).
    

    create_squares_aux2_vertical(Board, Square, Square, Column, R1, N, N).
    create_squares_aux2_vertical(Board, Square, SquareAux, Column, R1, N, Dif):-
       create_squares_aux2_horizontal(Board, Line, [], R1, Column, N, 0),
       append(SquareAux, Line, SquareAux2),
       R2 is R1 +1,
       Dif2 is Dif + 1,
       create_squares_aux2_vertical(Board, Square, SquareAux2, Column, R2,N, Dif2).

    create_squares_aux2_horizontal(Board, Square, Square, Row, C1, N, N).
    create_squares_aux2_horizontal(Board, Square,SquareAux, Row, C1, N, Dif):-
        get_value(Board, Row, C1, Value2),
        append(SquareAux,[Value2], SquareAux2),
        C2 is C1+1,
        Dif2 is Dif +1,
        create_squares_aux2_horizontal(Board, Square, SquareAux2, Row, C2, N, Dif2).

    % Returns a value in determinate coordinates
    % Board - board
    % Row - row of piece
    % Column - column of piece
    % Value - returned value
    get_value(Board, Row, Column, Value):-
        nth0(Row, Board, HelpRow),
        nth0(Column, HelpRow, Value). 

    domain_board([], Size).
    domain_board([H|T], Size):-
        domain(H,1,Size),
        domain_board(T, Size).

    restrict_lines([]).
    restrict_lines([H|T]):-
        all_distinct(H),
        restrict_lines(T).
    
    restrict_columns(Board):-
        transpose(Board, TBoard),
        restrict_lines(TBoard).

    restrict_squares(Board):-
        create_squares(Board, SquaresBoard),
        restrict_lines(SquaresBoard).

    restrict_hints(Board, LeftHints, UpHints, RightHints, DownHints):-
        [H|T] = LeftHints,
        length(H, Size),
        restrict_hints_aux(Board, LeftHints).

    restrict_hints_aux([], []).
    restrict_hints_aux([H|T], Hint):-
        list_to_fdset(Hint,FD),
        H in_set FD,
        restrict_hints_aux(T, THint).



    



        
        
        
        
        
