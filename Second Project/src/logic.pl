:- use_module(library(clpfd)).
:- use_module(library(lists)).
:- use_module(library(system)).
:- use_module(library(random)).
:- use_module(library(samsort)).
:-consult('display.pl').
:-consult('hints.pl').
:-consult('squares.pl').

    % Starts game
    newPuzzle(BoardSize,Level):-
        now(Seed),
        setrand(Seed),
         N_Hints is round(sqrt(BoardSize)),
        create_puzzle_structure(BoardSize,Board,BoardLine),
        labeling([value(mySelValores)], BoardLine),
        create_puzzle_with_hints(BoardSize,Board,N_Hints,Level).


    create_puzzle_with_hints(BoardSize,Board,N_Hints,Level):-
        create_puzzle_structure(BoardSize,NewBoard,NewBoardLine),
        getLevelRatio(Level,BoardSize,LevelRatio),
        create_puzzle_hints(Board, NewBoard, LeftHints, UpHints, RightHints, DownHints, N_Hints,LevelRatio),
        (check_single_solution(NewBoardLine);create_puzzle_with_hints(BoardSize,Board,N_Hints)),
        labeling([], NewBoardLine),
        printBoard(board(NewBoard,hints(LeftHints,UpHints,RightHints,DownHints)),BoardSize).

    getLevelRatio(1,Size,Ratio):-
        Ratio is Size*2.

    getLevelRatio(2,Size,Ratio):-
        Ratio is round(Size/sqrt(Size)). 

    getLevelRatio(3,Size,Ratio):-
        Ratio is round(Size/sqrt(Size)-1).           

    create_puzzle_structure(BoardSize,Board,BoardLine):-
        create_board(Board, BoardSize),
        domain_board(Board,BoardSize),
        restrict_lines(Board), restrict_columns(Board), restrict_squares(Board),
        term_variables(Board, BoardLine).        
  

    check_single_solution(BoardLine):-
        findall(_,labeling([], BoardLine), FinalList),
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

    