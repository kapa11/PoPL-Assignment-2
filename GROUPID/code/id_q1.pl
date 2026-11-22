:- use_module(library(lists)).

candidate_solution([
    p('Alex',  D1, L1, P1),
    p('Ben',   D2, L2, P2),
    p('Carla', D3, L3, P3),
    p('Dana',  D4, L4, P4)
]) :-
    permutation([research, development, design, testing], [D1, D2, D3, D4]),
    permutation([python, java, 'c++', javascript], [L1, L2, L3, L4]),
    permutation(['AI', web, embedded, data], [P1, P2, P3, P4]).

clue(1, Solution) :-
    member(p(Name, Dept, _, 'AI'), Solution),
    Dept \= research,
    Name \= 'Dana'.

clue(2, Solution) :-
    member(p('Alex', Dept, Lang, _), Solution),
    Dept \= development,
    Lang \= 'c++'.

clue(3, Solution) :-
    member(p(_, testing, python, _), Solution).

clue(4, Solution) :-
    member(p('Ben', Dept, _, web), Solution),
    Dept \= testing.

clue(5, Solution) :-
    member(p(_, design, java, _), Solution).

clue(6, Solution) :-
    member(p('Carla', Dept, _, Project), Solution),
    Project \= embedded,
    Dept \= development.

clue(7, Solution) :-
    member(p('Dana', Dept, Lang, _), Solution),
    Lang \= java,
    (Dept = research ; Dept = testing).

clue(8, Solution) :-
    member(p(_, research, Lang, data), Solution),
    Lang \= javascript.

% CLUE 9: The friend whose favorite language is Python prefers the AI project.
clue(9, Solution) :-
    member(p(_, _, python, 'AI'), Solution).
    
active_clues_hold([], _).
active_clues_hold([N | Rest], Solution) :-
    clue(N, Solution),
    active_clues_hold(Rest, Solution).

count_solutions(Active, N) :-
    findall(
        Solution,
        (   candidate_solution(Solution),
            active_clues_hold(Active, Solution)
        ),
        Solutions
    ),
    sort(Solutions, UniqueSolutions),
    length(UniqueSolutions, N).

