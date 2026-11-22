% Test suite for Problem 2: Form a Valid Arithmetic Equation
% Tests all public and internal predicates according to specification.

:- (   current_predicate(generate_equation/2)
   ->  true
   ;   exists_file('../code/83_q2.pl')
   ->  [ '../code/83_q2.pl' ]
   ;   exists_file('code/83_q2.pl')
   ->  [ 'code/83_q2.pl' ]
   ;   exists_file('83/code/83_q2.pl')
   ->  [ '83/code/83_q2.pl' ]
   ).

% =============================================================================
% A. Assignment-Provided Examples
% =============================================================================

test_case('A1: all_equations for [4,2,5,3] matches exact 7 canonical equations', (
    all_equations([4, 2, 5, 3], Es),
    Es == [
        "4*2-5=3",
        "4*2=5+3",
        "4-2=5-3",
        "4/2=5-3",
        "4=2*(5-3)",
        "4=2+(5-3)",
        "4=2+5-3"
    ]
)).

test_case('A2: [2,3,4] has no valid equations (fails generate, all=[], count=0)', (
    all_equations([2, 3, 4], []),
    \+ generate_equation([2, 3, 4], _),
    count_equations([2, 3, 4], 0)
)).

test_case('A3: [2,4,8] yields exactly one equation "2*4=8"', (
    all_equations([2, 4, 8], ["2*4=8"]),
    generate_equation([2, 4, 8], "2*4=8"),
    count_equations([2, 4, 8], 1)
)).

% =============================================================================
% B. Edge Cases
% =============================================================================

test_case('B1: Empty list fails generate, returns [] for all, and 0 for count', (
    all_equations([], []),
    \+ generate_equation([], _),
    count_equations([], 0)
)).

test_case('B2: Singleton list fails generate, returns [] for all, and 0 for count', (
    all_equations([5], []),
    \+ generate_equation([5], _),
    count_equations([5], 0)
)).

test_case('B3: Two-number list with equality yields single equation', (
    all_equations([3, 3], ["3=3"]),
    generate_equation([3, 3], "3=3"),
    count_equations([3, 3], 1)
)).

test_case('B4: Two-number list without equality fails', (
    all_equations([6, 2], []),
    \+ generate_equation([6, 2], _),
    count_equations([6, 2], 0)
)).

test_case('B5: Zeros in input list handled properly', (
    all_equations([0, 0], ["0=0"]),
    count_equations([0, 0], 1)
)).

test_case('B6: Zeros participating in arithmetic without division by zero', (
    all_equations([0, 5, 5], Es),
    member("0+5=5", Es),
    member("0=5-5", Es)
)).

test_case('B7: Negative intermediate expression values permitted', (
    all_equations([1, 5, 4, 0], Es),
    member("1-5+4=0", Es)
)).

% =============================================================================
% C. Arithmetic Validity
% =============================================================================

test_case('C1: Exact division accepted', (
    all_equations([12, 3, 4], Es),
    member("12/3=4", Es)
)).

test_case('C2: Non-exact division rejected cleanly', (
    all_equations([7, 2, 3], []),
    \+ generate_equation([7, 2, 3], _)
)).

test_case('C3: Division by zero rejected cleanly without exception', (
    \+ eval_expression(node(/, num(4), num(0)), _),
    all_equations([4, 0, 0], Es),
    \+ member("4/0=0", Es),
    all_equations([1, 0, 5], []),
    \+ generate_equation([1, 0, 5], _)
)).

test_case('C4: Nested division by zero rejected without exception', (
    all_equations([4, 2, 2, 0], Es),
    \+ member("4/(2-2)=0", Es)
)).

test_case('C5: Invalid intermediate division rejected even if final value matches', (
    all_equations([3, 2, 2, 3], Es),
    \+ member("3/2*2=3", Es),
    \+ member("(3/2)*2=3", Es)
)).

% =============================================================================
% D. Formatting Correctness
% =============================================================================

test_case('D1: Multiplication over addition precedence on left child gives parens', (
    format_expression(node(*, node(+, num(4), num(2)), num(3)), S),
    S == "(4+2)*3"
)).

test_case('D2: Multiplication over addition precedence on right child gives no parens', (
    format_expression(node(+, num(4), node(*, num(2), num(3))), S),
    S == "4+2*3"
)).

test_case('D3: Left-associativity of subtraction omits parens on left child', (
    format_expression(node(-, node(-, num(1), num(2)), num(3)), S),
    S == "1-2-3"
)).

test_case('D4: Left-associativity of subtraction requires parens on right child', (
    format_expression(node(-, num(1), node(-, num(2), num(3))), S),
    S == "1-(2-3)"
)).

test_case('D5: Left-associativity of division and multiplication omits left parens', (
    format_expression(node(*, node(/, num(8), num(4)), num(2)), S),
    S == "8/4*2"
)).

test_case('D6: Equal precedence on right child of division requires parens', (
    format_expression(node(/, num(8), node(*, num(4), num(2))), S),
    S == "8/(4*2)"
)).

test_case('D7: Distinct expression trees produce distinct canonical strings', (
    format_expression(node(+, num(1), node(+, num(2), num(3))), S1),
    format_expression(node(+, node(+, num(1), num(2)), num(3)), S2),
    S1 == "1+(2+3)",
    S2 == "1+2+3",
    S1 \== S2
)).

test_case('D8: Single numbers are never enclosed in parentheses', (
    format_expression(num(42), S),
    S == "42"
)).

% =============================================================================
% E. Public Predicate Consistency
% =============================================================================

test_case('E1: generate_equation returns an equation in all_equations', (
    generate_equation([4, 2, 5, 3], Eq),
    all_equations([4, 2, 5, 3], All),
    member(Eq, All)
)).

test_case('E2: count_equations equals length of all_equations', (
    count_equations([4, 2, 5, 3], Count),
    all_equations([4, 2, 5, 3], All),
    length(All, Len),
    Count =:= Len
)).

test_case('E3: all_equations returns deduplicated, sorted list', (
    all_equations([4, 2, 5, 3], All),
    sort(All, Sorted),
    All == Sorted
)).

test_case('E4: All returned equations are SWI-Prolog strings', (
    all_equations([4, 2, 5, 3], All),
    maplist(string, All)
)).

% =============================================================================
% Test Runner
% =============================================================================

run_tests :-
    findall(test_case(Name, Goal), test_case(Name, Goal), Tests),
    run_test_list(Tests, 0, 0, FailedCount),
    (   FailedCount =:= 0
    ->  format('~n==============================~nAll Problem 2 tests passed!~n==============================~n')
    ;   format('~n==============================~nFAILURE: ~w test(s) failed.~n==============================~n', [FailedCount]),
        fail
    ).

run_test_list([], Passed, Failed, Failed) :-
    Total is Passed + Failed,
    format('~nSummary: Total ~w | Passed: ~w | Failed: ~w~n', [Total, Passed, Failed]).
run_test_list([test_case(Name, Goal)|Rest], Passed, Failed, FinalFailed) :-
    (   catch(Goal, Error, (format('FAIL: ~w (Exception: ~w)~n', [Name, Error]), fail))
    ->  format('PASS: ~w~n', [Name]),
        NewPassed is Passed + 1,
        run_test_list(Rest, NewPassed, Failed, FinalFailed)
    ;   format('FAIL: ~w~n', [Name]),
        NewFailed is Failed + 1,
        run_test_list(Rest, Passed, NewFailed, FinalFailed)
    ).

main :- run_tests.