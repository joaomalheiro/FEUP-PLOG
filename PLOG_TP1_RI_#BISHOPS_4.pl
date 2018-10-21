% MAD BISHOPS
% PLOG Beatriz Mendes & João Malheiro

% board in the initial state of the game
initialBoard([[
[0,2,0,2,0,2,0,2,0,2],
[3,0,3,0,3,0,3,0,3,0],
[0,2,0,2,0,2,0,2,0,2],
[3,0,3,0,3,0,3,0,3,0],
[0,2,0,2,0,2,0,2,0,2],
[3,0,3,0,3,0,3,0,3,0],
[0,2,0,2,0,2,0,2,0,2],
[3,0,3,0,3,0,3,0,3,0],
[0,2,0,2,0,2,0,2,0,2],
[3,0,3,0,3,0,3,0,3,0]],2
]).

% board in a intermediate state of the game
mediumBoard([
[0,1,0,2,0,1,0,2,0,3],
[3,0,1,0,2,0,1,0,1,0],
[0,2,0,3,0,1,0,3,0,1],
[1,0,1,0,1,0,1,0,2,0],
[0,2,0,2,0,3,0,1,0,3],
[2,0,1,0,1,0,1,0,1,0],
[0,3,0,2,0,3,0,3,0,1],
[1,0,1,0,3,0,1,0,2,0],
[0,1,0,3,0,2,0,3,0,3],
[2,0,1,0,1,0,3,0,1,0]
]).

% example of a board in a terminal state of the game
finalBoard([
[0,1,0,1,0,1,0,1,0,1],
[1,0,1,0,2,0,1,0,1,0],
[0,1,0,1,0,1,0,1,0,1],
[1,0,1,0,1,0,1,0,1,0],
[0,1,0,2,0,1,0,1,0,1],
[1,0,1,0,1,0,1,0,1,0],
[0,1,0,1,0,1,0,1,0,1],
[1,0,1,0,1,0,1,0,1,0],
[0,1,0,1,0,1,0,2,0,1],
[1,0,1,0,1,0,1,0,1,0]
]).

% predicate used to initialize the board and pass it to the displayGame predicate
start :-
  initialBoard(X),
  displayGame(X).

% main predicate responsible for the display of the state of the game(board and the player who must play).
displayGame([]).
displayGame([T|B]) :-
  nl,
  write('           M A D  B I S H O P S          '),
  nl, nl,
  write('    PLAYER: '),                                      % conditional to see which player is going to play
  ((
    B =:= 1 -> write('blue')
  );
  (
    B =:= 2 -> write('red')
  )),
  nl,nl,
  write('    0   1   2   3   4   5   6   7   8   9'),
  printSeparation,                                            % writes to the console a separating line used to make the board more attractive
  nl,
  tablePrint(T,-1).


printSeparation :-
  nl,
  write('  |---|---|---|---|---|---|---|---|---|---|').

% predicate responsible for printing the entire board
tablePrint([], _X).
tablePrint([L|T],X) :-
  C is X+1,
  write(C),
  printList(L),
  write(' |'),
  printSeparation,
  nl,
  tablePrint(T,C).

% predicate responsible for printing an entire line
printList([]).
printList([C|L]) :-
  write(' | '),
  printCell(C),
  printList(L).

% predicate responsible for printing a single cell
printCell(X) :-
  printSymbol(X,S),
  write(S).

  printSymbol(0,S) :- S='.'.
  printSymbol(1,S) :- S=' '.
  printSymbol(2,S) :- S='R'.
  printSymbol(3,S) :- S='B'.
