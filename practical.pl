% Hendrik Werner s4549775

% node(id, hitting_set, [child_id])
node(1, [], [2, 3]).
node(2, [x1], []).
node(3, [x2], [4, 5, 6]).
node(4, [x1, x2], []).
node(5, [x1, a2], []).
node(6, [x1, o1], []).

% label(id, label)
% label(X, Y) <-> node with id X has label Y
label(1, [x1, x2]).
label(2, diagnosis).
label(3, [x1, a2, o1]).
label(4, diagnosis).
label(5, diagnosis).
label(6, diagnosis).

% print_tree(root_id)
print_tree(Root_id) :-
	node(Root_id, Hitting_set, Children),
	label(Root_id, Label),
	write("Node "), write(Root_id), nl,
	write("\tLabel: "), write(Label), nl,
	write("\tHitting Set: "), write(Hitting_set), nl,
	!,
	member(Next_node, Children),
	print_tree(Next_node).

% nnodes([id], n)
nnodes([], N) :-
	N is 0.
nnodes([Id|Ids], N) :-
	nnodes(Id, N1),
	nnodes(Ids, N2),
	N is N1 + N2.

% nnodes(root_id, n)
nnodes(Root_id, N) :-
	node(Root_id, _, Children),
	nnodes(Children, N1),
	!,
	N is N1 + 1.
