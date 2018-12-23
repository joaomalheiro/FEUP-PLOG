:- use_module(library(clpfd)).

problem(Vars) :-
	length(Vars,10),
	domain(Vars,1,100),
	
	all_distinct(Vars),
	
	Vars = [V|Vs],
	maximum(V,Vars),
	sum(Vs,#=,V),
	
	reset_timer,
	labeling([],Vars),
%	labeling([down],Vars),
	print_time,
	fd_statistics.



reset_timer :- statistics(walltime,_).	
print_time :-
	statistics(walltime,[_,T]),
	nl, write('Time: '), write(T), write('s'), nl, nl.


test_solve_options(Board):-
	Vars = [leftmost,min,max,first_fail,anti_first_fail,occurrence, most_constrained, max_regret],
	Choice = [step,enum,bisect,median,middle],
	Direction = [up,down],
	test_solve_var(Board,Vars,Choice,Direction).

test_solve_var(_,[],_,_).
test_solve_var(Board,[H|T],Choice,Direction):-
	test_solve_choice(Board,H,Choice,Direction),
	test_solve_var(Board,T,Choice,Direction).

test_solve_choice(_,_,[],_).
test_solve_choice(Board,Var,[H|T],Direction):-
	test_solve_direction(Board,Var,H,Direction),
	test_solve_choice(Board,Var,T,Direction).

test_solve_direction(_,_,_,[]).
test_solve_direction(Board,Var,Choice,[H|T]):-
	test_solve(Board,Var,Choice,H),
	test_solve_direction(Board,Var,Choice,T).

test_solve(Board,Var,Choice,Direction):-
	BoardSize is 4,
	N_Hints is round(sqrt(BoardSize)),
	initHints4(LeftHints,RightHints,TopHints,DownHints),
    create_puzzle_structure(4,NewBoard,NewBoardLine),
    restrict_hints(NewBoard, LeftHints,TopHints,RightHints,DownHints, N_Hints),
	write('\n'),write(Var),write('-'),write(Choice),write('-'),write(Direction),write(':'),
	reset_timer,
    labeling([Var,Choice,Direction], NewBoardLine),
	print_time, fd_statistics.
