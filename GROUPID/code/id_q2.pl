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

% eval_expression(Tree, Value)
% Evaluates Tree to its integer Value. Fails if division is non-exact or by zero.
eval_expression(num(N), N).
eval_expression(node(+, Left, Right), Value) :-
    eval_expression(Left, LVal),
    eval_expression(Right, RVal),
    Value is LVal + RVal.
eval_expression(node(-, Left, Right), Value) :-
    eval_expression(Left, LVal),
    eval_expression(Right, RVal),
    Value is LVal - RVal.
eval_expression(node(*, Left, Right), Value) :-
    eval_expression(Left, LVal),
    eval_expression(Right, RVal),
    Value is LVal * RVal.
eval_expression(node(/, Left, Right), Value) :-
    eval_expression(Left, LVal),
    eval_expression(Right, RVal),
    RVal =\= 0,
    LVal rem RVal =:= 0,
    Value is LVal // RVal.

% equation_tree(List, EquationTree)
% Generates valid equation trees eq(LeftTree, RightTree) where both sides evaluate to the same integer.
equation_tree(List, eq(LeftTree, RightTree)) :-
    split_nonempty(List, LeftList, RightList),
    expression_tree(LeftList, LeftTree),
    eval_expression(LeftTree, Val),
    expression_tree(RightList, RightTree),
    eval_expression(RightTree, Val).



