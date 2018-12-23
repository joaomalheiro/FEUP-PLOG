:- use_module(library(clpfd)).
:- use_module(library(lists)).
:- use_module(library(system)).
:- use_module(library(random)).
:- use_module(library(samsort)).
:-consult('display.pl').
:-consult('hints.pl').
:-consult('squares.pl').
%:-consult('statistics.pl').

leftHints4([[4,3],[2],[2,1],[4,3]]) :- !.
rightHints4([[2,1],[3,4],[3],[2,1]]) :- !.
topHints4([[1,3],[2,4],[2,3],[1,4]]) :- !.
downHints4([[2,4],[3],[1,4],[2,3]]) :- !.

leftHints9([[8,3,2],[7,6,5],[9,4,1],[8,6],[7],[5,4],[6,5,1],[7,4,3],[]]) :- !.
rightHints9([[7,5],[9,4,2],[8,6],[],[8,4,2],[6,3,1],[7,2],[9,6,5],[4,3,1]]) :- !.
topHints9([[9],[1,3,6],[4,7],[2,4,8],[3,5,6],[1,7],[1,9],[4,5],[2,6,7]]) :- !.
downHints9([[1,2],[4,9],[],[1,5,9],[4,8],[3,6],[2,5],[1,6],[3,8,9]]) :- !.

initHints4(LeftHints,RightHints,TopHints,DownHints):-
    leftHints4(LeftHints), rightHints4(RightHints),topHints4(TopHints),downHints4(DownHints).

initHints9(LeftHints,RightHints,TopHints,DownHints):-
    leftHints9(LeftHints), rightHints9(RightHints),topHints9(TopHints),downHints9(DownHints).    

    % Starts game
    newPuzzle(BoardSize,Level,1):-
        now(Seed),
        setrand(Seed),
        N_Hints is round(sqrt(BoardSize)),
        create_puzzle_structure(BoardSize,Board,BoardLine),
        labeling([value(mySelValores)], BoardLine),
        create_puzzle_with_hints(BoardSize,Board,N_Hints,Level).

    newPuzzle(BoardSize,Level,2):-
        now(Seed),
        setrand(Seed),
        N_Hints is round(sqrt(BoardSize)),
        initHints9(LeftHints,RightHints,TopHints,DownHints),
        create_puzzle_structure(BoardSize,NewBoard,NewBoardLine),
        restrict_hints(NewBoard, LeftHints,TopHints,RightHints,DownHints, N_Hints),
        labeling([], NewBoardLine),
        printBoard(board(NewBoard,hints(LeftHints,TopHints,RightHints,DownHints)),BoardSize).


    create_puzzle_with_hints(BoardSize,Board,N_Hints,Level):-
        create_puzzle_structure(BoardSize,NewBoard,NewBoardLine),
        getLevelRatio(Level,BoardSize,LevelRatio),
        create_puzzle_hints(Board, NewBoard, LeftHints, UpHints, RightHints, DownHints, N_Hints,LevelRatio),
        (check_single_solution(NewBoardLine);create_puzzle_with_hints(BoardSize,Board,N_Hints,Level)),
        labeling([], NewBoardLine), !,
        printBoard(board(NewBoard,hints(LeftHints,UpHints,RightHints,DownHints)),BoardSize).

    getLevelRatio(1,Size,Ratio):-
        Ratio is Size*2.

    getLevelRatio(2,Size,Ratio):-
        Ratio is round(Size*0.8). 

    getLevelRatio(3,Size,Ratio):-
        Ratio is round(Size*0.4).           

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

    