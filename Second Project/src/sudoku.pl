:- use_module(library(clpfd)).
:- use_module(library(lists)).

    % Starts game
    start:-
        create_board(Board, 4),
        domain_board(Board,4),
        restrict_lines(Board), restrict_columns(Board), restrict_squares(Board),
        term_variables(Board, NewBoard),
        labeling([], NewBoard),
        write(Board).
    
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
        create_squares_aux_vertical([H|T] , SquaresBoard, [], 2, 0, Size).

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


        
        
        
        
        
