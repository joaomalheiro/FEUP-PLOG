:-consult('logic.pl').

mainMenu:-
    nl,
    write('           S U D O K U          '),
    nl,
    print_line(8),
    write('Enter board size (Must be a square root between 4 and 9 ex.: 4):'),
    readInput(Input),
    difficultyMenu(Level),
    newPuzzle(Input,Level).

testSizeInput(4).
testSizeInput(9).

difficultyMenu(Level):-
    write('           S U D O K U          '),
    nl,
    print_line(8),
    write('Difficulty: '),
    nl,
    write('1 - Easy'),
    nl,
    write('2 - Medium'),
    read(Input),
    handleInput(Input,Level).

readInput(Input):-
    catch(read(Input),_Err,fail),
    (testSizeInput(Input);
    write('Invalid input, please insert a valid number'),readInput(_)).

 handleInput(1,1).
 handleInput(2,2).