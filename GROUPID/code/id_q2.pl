% split_nonempty(List, Left, Right)
% Splits List into two contiguous, non-empty sublists Left and Right, preserving order.
split_nonempty([X, Y|Rest], [X], [Y|Rest]).
split_nonempty([X, Y|Rest], [X|LeftTail], Right) :-
    split_nonempty([Y|Rest], LeftTail, Right).
