:-consult('logic.pl').

mainMenu:-
    nl,
    write('           S U D O K U          '),
    nl,
    print_line(8),
    write('Enter board size (Must be a square root between 4 and 9 ex.: 4):'),
    readInput(Input),
    newPuzzle(Input).

testSizeInput(4).
testSizeInput(9).

readInput(Input):-
    catch(read(Input),_Err,fail),
    (testSizeInput(Input);
    write('Invalid input, please insert a valid number'),readInput(_)).