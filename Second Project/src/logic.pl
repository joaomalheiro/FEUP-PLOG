:- use_module(library(clpfd)).
:- use_module(library(lists)).
:- use_module(library(system)).
:- use_module(library(random)).
:- use_module(library(samsort)).
:-consult('display.pl').

    % Starts game
    newPuzzle(BoardSize):-
        now(Seed),
        setrand(Seed),
        N_Hints is round(sqrt(BoardSize)),
        
        create_puzzle_structure(BoardSize,Board,BoardLine),
        labeling([value(mySelValores)], BoardLine),
        printBoard(board(Board,hints([],[],[],[])),BoardSize),

        create_puzzle_hints(Board, LeftHints, UpHints, RightHints, DownHints, N_Hints),
        check_single_solution(BoardLine),
        printBoard(board(Board,hints(LeftHints,UpHints,RightHints,DownHints)),BoardSize).

    create_puzzle_structure(BoardSize,Board,BoardLine):-
        create_board(Board, BoardSize),
        domain_board(Board,BoardSize),
        restrict_lines(Board), restrict_columns(Board), restrict_squares(Board),
        term_variables(Board, BoardLine).        
  

    check_single_solution(BoardLine):-
        findall(X,labeling([], BoardLine), FinalList),
        length(FinalList, Size),
        Size is 1.

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
    
    
    % Generates random number in interval D-U
    % D - lower limit 
    % U - higher limit 
    % RandomNum - number generated
    generate_random_num(D,U,RandomNum):-
        random(D, U, RandomNum).

        
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

    create_squares_aux_vertical(_, SquaresBoard, SquaresBoard, _, Max, Max).
    create_squares_aux_vertical(Board, SquaresBoard, SquaresBoardAux, N, I, Max):-
        create_squares_aux_horizontal(Board, SquaresBoardLine, [], N, I, 0, Max),
        append(SquaresBoardAux, SquaresBoardLine, SquaresBoardAux2),
        I2 is I + N,
        create_squares_aux_vertical(Board, SquaresBoard, SquaresBoardAux2, N, I2, Max).
        
    create_squares_aux_horizontal(_, SquaresBoard, SquaresBoard, _, _, Max, Max).
    create_squares_aux_horizontal(Board, SquaresBoard, SquaresBoardAux, N, Line, I, Max):-
        create_squares_aux2_vertical(Board, H2, [], I, Line, N, 0),
        append(SquaresBoardAux, [H2], SquaresBoardAux2),
        I2 is I + N,
        create_squares_aux_horizontal(Board, SquaresBoard, SquaresBoardAux2, N, Line, I2, Max).
    

    create_squares_aux2_vertical(_, Square, Square, _, _, N, N).
    create_squares_aux2_vertical(Board, Square, SquareAux, Column, R1, N, Dif):-
       create_squares_aux2_horizontal(Board, Line, [], R1, Column, N, 0),
       append(SquareAux, Line, SquareAux2),
       R2 is R1 +1,
       Dif2 is Dif + 1,
       create_squares_aux2_vertical(Board, Square, SquareAux2, Column, R2,N, Dif2).

    create_squares_aux2_horizontal(_, Square, Square, _, _, N, N).
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

    domain_board([], _).
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