:- use_module(library(lists)).

run_p1_tests :-
    all_tests(Tests),
    run_tests(Tests, 0, Passed, 0, Failed),
    Total is Passed + Failed,
    format('~nP1 test summary: ~d/~d passed, ~d failed.~n', [Passed, Total, Failed]),
    Failed =:= 0.

run_tests([], Passed, Passed, Failed, Failed).
run_tests([test(Name, Goal) | Rest], P0, P, F0, F) :-
    (   call(Goal)
    ->  format('[PASS] ~w~n', [Name]),
        P1 is P0 + 1,
        F1 = F0
    ;   format('[FAIL] ~w~n', [Name]),
        P1 = P0,
        F1 is F0 + 1
    ),
    run_tests(Rest, P1, P, F1, F).

valid_candidate_shape([
    p('Alex',  D1, L1, P1),
    p('Ben',   D2, L2, P2),
    p('Carla', D3, L3, P3),
    p('Dana',  D4, L4, P4)
]) :-
    same_domain([D1, D2, D3, D4], [research, development, design, testing]),
    same_domain([L1, L2, L3, L4], [python, java, 'c++', javascript]),
    same_domain([P1, P2, P3, P4], ['AI', web, embedded, data]).

same_domain(Values, Domain) :-
    sort(Values, Sorted),
    sort(Domain, Sorted).

all_valid_candidates([]).
all_valid_candidates([S | Rest]) :-
    valid_candidate_shape(S),
    all_valid_candidates(Rest).

retained_solution([
    p('Alex',  design,      java,       embedded),
    p('Ben',   development, javascript, web),
    p('Carla', testing,     python,     'AI'),
    p('Dana',  research,    'c++',      data)
]).

other_pre_clue9_solution_1([
    p('Alex',  design,      java,       'AI'),
    p('Ben',   development, javascript, web),
    p('Carla', research,    'c++',      data),
    p('Dana',  testing,     python,     embedded)
]).

other_pre_clue9_solution_3([
    p('Alex',  testing,     python,     embedded),
    p('Ben',   development, javascript, web),
    p('Carla', design,      java,       'AI'),
    p('Dana',  research,    'c++',      data)
]).

all_tests([
    % --- 1. candidate_solution/1 structure, domains, uniqueness, negative cases ---
    test(candidate_structure_and_domains, (
        findall(S, candidate_solution(S), Sols),
        Sols \= [],
        all_valid_candidates(Sols)
    )),
    test(candidate_no_duplicates, (
        findall(S, candidate_solution(S), Sols),
        length(Sols, Total),
        sort(Sols, Unique),
        length(Unique, Total)
    )),
    test(candidate_rejects_duplicate_attribute, (
        \+ candidate_solution([
            p('Alex',  research,    python,     'AI'),
            p('Ben',   research,    java,       web),
            p('Carla', design,      'c++',      embedded),
            p('Dana',  testing,     javascript, data)
        ])
    )),
    test(candidate_rejects_wrong_name_order, (
        \+ candidate_solution([
            p('Ben',   research,    python,     'AI'),
            p('Alex',  development, java,       web),
            p('Carla', design,      'c++',      embedded),
            p('Dana',  testing,     javascript, data)
        ])
    )),
    test(candidate_rejects_invalid_atom, (
        \+ candidate_solution([
            p('Alex',  research,    ruby,       'AI'),
            p('Ben',   development, java,       web),
            p('Carla', design,      'c++',      embedded),
            p('Dana',  testing,     javascript, data)
        ])
    )),

    % --- 2. Candidate count with no active clues ---
    test(count_no_active_clues_13824, (
        count_solutions([], 13824)
    )),

    % --- 3. Individual clues 1 through 8 (positive and negative) ---
    test(clue_1_pass, (
        clue(1, [
            p('Alex',  design,      python,     'AI'),
            p('Ben',   development, java,       web),
            p('Carla', testing,     'c++',      embedded),
            p('Dana',  research,    javascript, data)
        ])
    )),
    test(clue_1_fail_research_and_dana, (
        \+ clue(1, [
            p('Alex',  research,    python,     'AI'),
            p('Ben',   development, java,       web),
            p('Carla', design,      'c++',      embedded),
            p('Dana',  testing,     javascript, data)
        ]),
        \+ clue(1, [
            p('Alex',  research,    python,     data),
            p('Ben',   development, java,       web),
            p('Carla', design,      'c++',      embedded),
            p('Dana',  testing,     javascript, 'AI')
        ])
    )),

    test(clue_2_pass, (
        clue(2, [
            p('Alex',  research,    python,     'AI'),
            p('Ben',   development, java,       web),
            p('Carla', design,      'c++',      embedded),
            p('Dana',  testing,     javascript, data)
        ])
    )),
    test(clue_2_fail_dev_and_cpp, (
        \+ clue(2, [
            p('Alex',  development, python,     'AI'),
            p('Ben',   research,    java,       web),
            p('Carla', design,      'c++',      embedded),
            p('Dana',  testing,     javascript, data)
        ]),
        \+ clue(2, [
            p('Alex',  research,    'c++',      'AI'),
            p('Ben',   development, java,       web),
            p('Carla', design,      python,     embedded),
            p('Dana',  testing,     javascript, data)
        ])
    )),

    test(clue_3_pass, (
        clue(3, [
            p('Alex',  research,    javascript, 'AI'),
            p('Ben',   development, java,       web),
            p('Carla', design,      'c++',      embedded),
            p('Dana',  testing,     python,     data)
        ])
    )),
    test(clue_3_fail_mismatch, (
        \+ clue(3, [
            p('Alex',  research,    python,     'AI'),
            p('Ben',   development, java,       web),
            p('Carla', design,      'c++',      embedded),
            p('Dana',  testing,     javascript, data)
        ])
    )),

    test(clue_4_pass, (
        clue(4, [
            p('Alex',  research,    python,     'AI'),
            p('Ben',   development, java,       web),
            p('Carla', design,      'c++',      embedded),
            p('Dana',  testing,     javascript, data)
        ])
    )),
    test(clue_4_fail_testing_and_non_web, (
        \+ clue(4, [
            p('Alex',  research,    python,     'AI'),
            p('Ben',   testing,     java,       web),
            p('Carla', design,      'c++',      embedded),
            p('Dana',  development, javascript, data)
        ]),
        \+ clue(4, [
            p('Alex',  research,    python,     web),
            p('Ben',   development, java,       'AI'),
            p('Carla', design,      'c++',      embedded),
            p('Dana',  testing,     javascript, data)
        ])
    )),

    test(clue_5_pass, (
        clue(5, [
            p('Alex',  research,    python,     'AI'),
            p('Ben',   development, 'c++',      web),
            p('Carla', design,      java,       embedded),
            p('Dana',  testing,     javascript, data)
        ])
    )),
    test(clue_5_fail_mismatch, (
        \+ clue(5, [
            p('Alex',  research,    python,     'AI'),
            p('Ben',   development, java,       web),
            p('Carla', design,      'c++',      embedded),
            p('Dana',  testing,     javascript, data)
        ])
    )),

    test(clue_6_pass, (
        clue(6, [
            p('Alex',  research,    python,     'AI'),
            p('Ben',   development, java,       web),
            p('Carla', design,      'c++',      data),
            p('Dana',  testing,     javascript, embedded)
        ])
    )),
    test(clue_6_fail_embedded_and_dev, (
        \+ clue(6, [
            p('Alex',  research,    python,     'AI'),
            p('Ben',   development, java,       web),
            p('Carla', design,      'c++',      embedded),
            p('Dana',  testing,     javascript, data)
        ]),
        \+ clue(6, [
            p('Alex',  research,    python,     'AI'),
            p('Ben',   design,      java,       web),
            p('Carla', development, 'c++',      data),
            p('Dana',  testing,     javascript, embedded)
        ])
    )),

    test(clue_7_pass_research_and_testing, (
        clue(7, [
            p('Alex',  testing,     python,     'AI'),
            p('Ben',   development, java,       web),
            p('Carla', design,      'c++',      embedded),
            p('Dana',  research,    javascript, data)
        ]),
        clue(7, [
            p('Alex',  research,    python,     'AI'),
            p('Ben',   development, java,       web),
            p('Carla', design,      'c++',      embedded),
            p('Dana',  testing,     javascript, data)
        ])
    )),
    test(clue_7_fail_java_and_design, (
        \+ clue(7, [
            p('Alex',  testing,     python,     'AI'),
            p('Ben',   development, javascript, web),
            p('Carla', design,      'c++',      embedded),
            p('Dana',  research,    java,       data)
        ]),
        \+ clue(7, [
            p('Alex',  research,    python,     'AI'),
            p('Ben',   development, java,       web),
            p('Carla', testing,     'c++',      embedded),
            p('Dana',  design,      javascript, data)
        ])
    )),

    test(clue_8_pass, (
        clue(8, [
            p('Alex',  research,    python,     data),
            p('Ben',   development, java,       web),
            p('Carla', design,      'c++',      embedded),
            p('Dana',  testing,     javascript, 'AI')
        ])
    )),
    test(clue_8_fail_js_and_non_research, (
        \+ clue(8, [
            p('Alex',  research,    javascript, data),
            p('Ben',   development, java,       web),
            p('Carla', design,      'c++',      embedded),
            p('Dana',  testing,     python,     'AI')
        ]),
        \+ clue(8, [
            p('Alex',  research,    javascript, 'AI'),
            p('Ben',   development, java,       web),
            p('Carla', design,      'c++',      embedded),
            p('Dana',  testing,     python,     data)
        ])
    )),

    % --- 4. active_clues_hold/2 ---
    test(active_clues_empty_list, (
        active_clues_hold([], [
            p('Alex',  development, 'c++',      'AI'),
            p('Ben',   testing,     java,       data),
            p('Carla', research,    python,     embedded),
            p('Dana',  design,      javascript, web)
        ])
    )),
    test(active_clues_single_clue, (
        S = [
            p('Alex',  development, 'c++',      'AI'),
            p('Ben',   research,    javascript, data),
            p('Carla', design,      java,       web),
            p('Dana',  testing,     python,     embedded)
        ],
        active_clues_hold([3], S),
        \+ active_clues_hold([2], S)
    )),
    test(active_clues_multiple_clues, (
        S = [
            p('Alex',  development, 'c++',      'AI'),
            p('Ben',   research,    javascript, data),
            p('Carla', design,      java,       web),
            p('Dana',  testing,     python,     embedded)
        ],
        active_clues_hold([3, 5], S),
        \+ active_clues_hold([3, 2, 5], S)
    )),
    test(active_clues_undefined_clue_fails, (
        retained_solution(S),
        \+ active_clues_hold([99], S)
    )),

    % --- 5. count_solutions/2 (single clue, clues 1..8, edge case) ---
    test(count_single_clue_3, (
        count_solutions([3], 3456)
    )),
    test(count_clues_1_to_8_is_3, (
        count_solutions([1,2,3,4,5,6,7,8], 3)
    )),
    test(count_undefined_clue_is_0, (
        count_solutions([99], 0)
    )),

    % --- 6. Clue 9 isolates exactly one solution ---
    test(clue_9_discriminates_solutions, (
        retained_solution(S2),
        other_pre_clue9_solution_1(S1),
        other_pre_clue9_solution_3(S3),
        clue(9, S2),
        \+ clue(9, S1),
        \+ clue(9, S3)
    )),
    test(count_clues_1_to_9_is_1, (
        count_solutions([1,2,3,4,5,6,7,8,9], 1)
    )),

    % --- 7. Retained solution satisfies all nine clues and is uniquely derived ---
    test(retained_solution_satisfies_all_9_clues, (
        retained_solution(Expected),
        findall(
            S,
            (   candidate_solution(S),
                active_clues_hold([1,2,3,4,5,6,7,8,9], S)
            ),
            [Derived]
        ),
        Derived == Expected,
        active_clues_hold([1,2,3,4,5,6,7,8,9], Derived)
    ))
]).