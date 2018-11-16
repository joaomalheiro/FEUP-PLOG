starting_board([
[0,2,0,2,0,2,0,2,0,2],
[3,0,3,0,3,0,3,0,3,0],
[0,2,0,2,0,2,0,2,0,2],
[3,0,3,0,3,0,3,0,3,0],
[0,2,0,2,0,2,0,2,0,2],
[3,0,3,0,3,0,3,0,3,0],
[0,2,0,2,0,2,0,2,0,2],
[3,0,3,0,3,0,3,0,3,0],
[0,2,0,2,0,2,0,2,0,2],
[3,0,3,0,3,0,3,0,3,0]
]) :- !.

% example of a board in a terminal state of the game
final_board([
[0,1,0,1,0,1,0,1,0,1],
[1,0,1,0,1,0,1,0,1,0],
[0,1,0,1,0,1,0,1,0,1],
[1,0,1,0,1,0,1,0,1,0],
[0,1,0,1,0,1,0,1,0,1],
[1,0,1,0,2,0,1,0,1,0],
[0,1,0,1,0,1,0,1,0,1],
[1,0,1,0,1,0,1,0,1,0],
[0,1,0,1,0,3,0,1,0,1],
[1,0,1,0,1,0,1,0,1,0]
]) :- !.

initial_board(board(B, PiecesP1, PiecesP2)) :- starting_board(B), PiecesP1 is 25, PiecesP2 is 25.
initial_player(2) :- !.

initial_state(state(board(B,PiecesP1,PiecesP2), Player)) :-
    initial_board(board(B,PiecesP1,PiecesP2)),
    initial_player(Player).

start(TypeP1, TypeP2,Level) :-
    initial_state(state(board(B,PiecesP1,PiecesP2),Player)),
    displayGame(B,PiecesP1,PiecesP2,Player),
    gameLoop(state(board(B,PiecesP1,PiecesP2),Player), TypeP1, TypeP2, Level).  


gameLoop(state(board(B,PiecesP1,PiecesP2),Player), TypeP1, TypeP2,Level):-
    game_over(board(B,PiecesP1,PiecesP2),Winner),
    Winner is 1,
    printLine,
    write(' BLUE PLAYER WON!'),
    printLine.

gameLoop(state(board(B,PiecesP1,PiecesP2),Player), TypeP1, TypeP2,Level):-
    game_over(board(B,PiecesP1,PiecesP2),Winner),
    Winner is 2,
    printLine,
    write(' RED PLAYER WON!'),
    printLine.    

gameLoop(state(board(B,PiecesP1,PiecesP2),Player), TypeP1, TypeP2, Level):-
    game_over(board(B,PiecesP1,PiecesP2),Winner),
    (
        Player =:= 1 -> Type is TypeP1;
        Player =:= 2 -> Type is TypeP2
    ),
    update(state(board(B, PiecesP1, PiecesP2),Player), state(board(NewB, NewPiecesP1, NewPiecesP2), NewPlayer), Type, Level) ,
    gameLoop(state(board(NewB, NewPiecesP1, NewPiecesP2), NewPlayer),TypeP1, TypeP2, Level).

game_over(board(B,PiecesP1,PiecesP2), Winner):-
    PiecesP1 is 0, Winner is 2.

game_over(board(B,PiecesP1,PiecesP2), Winner):-
   PiecesP2 is 0, Winner is 1.
    
game_over(board(B,PiecesP1,PiecesP2), 0).

aiMedium(state(board(B,PiecesP1,PiecesP2),Player),Move):-
    findall(Value-FromX-FromY-ToX-ToY,(validPlay(B, Player, point(FromX,FromY),point(ToX,ToY)),
    move(move(point(FromX, FromY),point(ToX,ToY)),board(B,PiecesP1,PiecesP2),board(NewBoard,NewPiecesP1,NewPiecesP2),Player),
    changePlayer(Player,NewPlayer),
    value(state(board(NewBoard,NewPiecesP1,NewPiecesP2),NewPlayer),Value)),ListValues),
    choose_best_move(ListValues, Move,-100,move(0,0,0,0)).

choose_best_move([],BestMove, _CurrBestValue, BestMove).
choose_best_move([ActualValue-FromX-FromY-ToX-ToY|T],BestMove, CurrBestValue, CurrBestMove):-
    ActualValue > CurrBestValue ,choose_best_move(T,BestMove,ActualValue,move(FromX,FromY,ToX,ToY)).

choose_best_move([_H|T], BestMove, CurrBestValue,CurrBestMove):-
    choose_best_move(T, BestMove, CurrBestValue, CurrBestMove).

value(state(board(Board,PiecesP1,PiecesP2),Player),Value):-
    valueKills(PiecesP1, PiecesP2, Player, AuxValueKills),
    valueKillable(Board, Player, AuxValueKillable),
    Value is AuxValueKills - AuxValueKillable.

valueKills(PiecesP1, PiecesP2, Player, Value):-
    Player is 1, 
    Value is PiecesP2*(PiecesP2-PiecesP1).

valueKills(PiecesP1, PiecesP2, Player, Value):-  
    Player is 2,
    Value is PiecesP1*(PiecesP1-PiecesP2).

valueKillable(Board, Player, Value):-
    findall([FromX,FromY,ToX,ToY],(checkPlayerPiece(Board, Player,point(FromX,FromY)),validKill(Board,Player,point(FromX,FromY),point(ToX,ToY))),ListKills),
    length(ListKills, ListSize),
    Value is ListSize.

valid_moves(Board, Player, ListMoves):-
    findall([FromX,FromY,ToX,ToY],validPlay(Board,Player,point(FromX,FromY),point(ToX,ToY)),ListMoves).

validPlay(Board, Player, PFrom, PTo):-
    betweenBoard(PFrom),
    betweenBoard(PTo),
    checkPlayerPiece(Board, Player,PFrom),
    validKill(Board, Player,PFrom,PTo);
    validEngage(Board, Player, PFrom,PTo).

validKill(Board, Player, PFrom, PTo):-
    checkDestinyTarget(Board,Player, PTo),
    isDiagonal(PFrom,PTo),
    emptySpaces(Board,PFrom,PTo).

validEngage(Board, Player, PFrom, PTo):-
    checkPlayerPiece(Board,Player,PFrom),
    checkDestinyEmpty(Board,PTo),
    isDiagonal(PFrom,PTo),
    emptySpaces(Board,PFrom,PTo),
    validKill(Board,Player,PTo,point(X,Y)).

emptySpaces(Board, point(FromX,FromY), point(ToX,ToY)):-
    DirX is sign(ToX - FromX),
    DirY is sign(ToY - FromY),
    X2 is FromX+DirX,
    Y2 is FromY+DirY,
    emptySpacesAux(Board, point(X2, Y2), point(ToX,ToY), DirX, DirY).

emptySpacesAux(_Board, point(X,Y), point(X, Y), _DirX, _DirY).
emptySpacesAux(Board,point(FromX,FromY), point(ToX,ToY), DirX, DirY):-
    X2 is FromX+DirX,
    Y2 is FromY+DirY,
    getPiece(Board,point(FromX,FromY),Piece),
    isEmptyPiece(Piece),
    emptySpacesAux(Board,point(X2,Y2),point(ToX,ToY),DirX,DirY).

isEmptyPiece(Piece):-
    Piece =:= 1.

isDiagonal(point(FromX,FromY), point(ToX,ToY)):-
    abs(ToX - FromX) =:= abs(ToY - FromY).

checkPlayerPiece(Board,Player,point(FromX,FromY)):-
    Player is 1,
    getPiece(Board, point(FromX,FromY), PlayerPiece) , PlayerPiece == 3.

checkPlayerPiece(Board,Player,point(FromX,FromY)):-
    Player is 2,
    getPiece(Board, point(FromX,FromY), PlayerPiece) , PlayerPiece == 2.

checkDestinyEmpty(Board, point(ToX,ToY)):-
    getPiece(Board,point(ToX,ToY),Piece),
    isEmptyPiece(Piece).

checkDestinyTarget(Board,Player, point(ToX,ToY)):-
        Player is 1,
        (getPiece(Board,point(ToX,ToY), DestinyPiece) , DestinyPiece =:= 2).

checkDestinyTarget(Board,Player, point(ToX,ToY)):-
        Player is 2,
        (getPiece(Board,point(ToX,ToY), DestinyPiece) , DestinyPiece =:= 3). 

getPiece(Board, point(Row, Column), Value):-
    nth0(Row, Board, HelpRow),
    nth0(Column, HelpRow, Value).

betweenBoard(point(X, Y)):-
        between(0, 9, X) , between(0,9,Y).

choose_move(state(board(B, PiecesP1, PiecesP2),Player), Level, move(point(FromX,FromY),point(ToX,ToY))):-
    Level is 1, aiEasy(B, Player,move(point(FromX,FromY),point(ToX,ToY))).

choose_move(state(board(B, PiecesP1, PiecesP2),Player), Level, move(point(FromX,FromY),point(ToX,ToY))):-
    Level is 2, aiMedium(state(board(B,PiecesP1,PiecesP2),Player),move(FromX,FromY,ToX,ToY)).
    
aiEasy(B, Player, move(point(FromX,FromY),point(ToX,ToY))):-
    valid_moves(B, Player, ListMoves),
    length(ListMoves, _ListSize),
    generateRandomNum(0,_ListSize,RandomNum),
    nth0(RandomNum, ListMoves, Movement),
    listToMove(Movement,move(point(FromX,FromY),point(ToX,ToY))).

listToMove(A, move(point(FromX,FromY),point(ToX,ToY))):-
    nth0(0,A,FromX),
    nth0(1,A,FromY),
    nth0(2,A,ToX), 
    nth0(3,A,ToY). 
    
generateRandomNum(D,U,RandomNum):-
    random(D, U, RandomNum).

update(state(board(B, PiecesP1, PiecesP2),Player), state(board(NewB, NewPiecesP1, NewPiecesP2), NewPlayer), TypePlayer, Level):-
    getMove(state(board(B, PiecesP1, PiecesP2),Player),point(FromX,FromY), point(ToX,ToY),TypePlayer, Level),
    move(move(point(FromX,FromY), point(ToX,ToY)), board(B,PiecesP1,PiecesP2), board(NewB,NewPiecesP1,NewPiecesP2), Player),
    changePlayer(Player,NewPlayer),
    nl,
    displayGame(NewB,NewPiecesP1,NewPiecesP2,NewPlayer). 

getMove(state(board(B, PiecesP1, PiecesP2),Player),point(FromX,FromY), point(ToX,ToY),TypePlayer,Level):-
    TypePlayer is 1,
    choose_move(state(board(B, PiecesP1, PiecesP2),Player), Level, move(point(FromX,FromY),point(ToX,ToY))),
    write('\n Bot made move: '),
    write(point(FromX,FromY)),
    write(' -> '),
    write(point(ToX,ToY)), nl. 

getMove(state(board(B, PiecesP1, PiecesP2),Player),point(FromX,FromY), point(ToX,ToY),TypePlayer,Level):-
    TypePlayer is 0,
    getUserMove(state(board(B, PiecesP1, PiecesP2),Player),point(FromX,FromY), point(ToX,ToY)).       

getUserMove(state(board(B, PiecesP1, PiecesP2),Player),point(FromX,FromY), point(ToX,ToY)):-
    askForMove(point(FromX,FromY), point(ToX,ToY)),
    validPlay(B, Player, point(FromX,FromY), point(ToX,ToY));
    (write('\nInvalid move. Try again\n\n'), 
    getUserMove(state(board(B, PiecesP1, PiecesP2),Player),point(FromX,FromY), point(ToX,ToY))).


changePlayer(Player, NewPlayer):-
    Player is 1, NewPlayer is 2.
    
changePlayer(Player, NewPlayer):-
    Player is 2, NewPlayer is 1.

move(move(point(FromX, FromY),point(ToX,ToY)),board(B,PiecesP1,PiecesP2),board(NewBoard,NewPiecesP1,NewPiecesP2),Player):-
    getPiece(B,point(FromX, FromY), Piece),
    replaceInTable(B,FromX,FromY,1,TempBoard),
    replaceInTable(TempBoard,ToX,ToY,Piece, NewBoard),
    (
        checkDestinyTarget(B,Player,point(ToX,ToY)), Player =:= 2 -> (NewPiecesP1 is (PiecesP1-1), NewPiecesP2 is PiecesP2); 
        checkDestinyTarget(B,Player,point(ToX,ToY)), Player =:= 1 -> (NewPiecesP2 is (PiecesP2-1), NewPiecesP1 is PiecesP1);
        NewPiecesP1 is PiecesP1, NewPiecesP2 is PiecesP2
    ).


same(L1,L2):-
    append(L1,[],L2).        
        
replaceInLine([_|T], 0, V, [V|T]).
replaceInLine([H|T], Y, V, [H|R]) :-
    Y > 0,
    Y1 is Y - 1,
    replaceInLine(T, Y1, V, R).

replaceInTable([H|T], X, Y, V, [U|R]):-
    X is 0,
    replaceInLine(H,Y,V,U),
    same(T,R).
    
replaceInTable([H|T], X, Y, V, [U|R]):-
    same(H,U),
    X1 is X-1,
    replaceInTable(T,X1,Y,V,R).
