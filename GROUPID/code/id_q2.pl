% split_nonempty(List, Left, Right)
% Splits List into two contiguous, non-empty sublists Left and Right, preserving order.
split_nonempty([X, Y|Rest], [X], [Y|Rest]).
split_nonempty([X, Y|Rest], [X|LeftTail], Right) :-
    split_nonempty([Y|Rest], LeftTail, Right).

% expression_tree(List, Tree)
% Generates all valid binary expression trees over List preserving order.
expression_tree([N], num(N)).
expression_tree(List, node(Op, LeftTree, RightTree)) :-
    split_nonempty(List, LeftList, RightList),
    expression_tree(LeftList, LeftTree),
    expression_tree(RightList, RightTree),
    member(Op, [+, -, *, /]).

