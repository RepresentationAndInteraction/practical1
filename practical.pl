% Hendrik Werner s4549775

% node(id, [child_id])
% node(X, Y) <-> node with id X has children with ids in Y
node(1, [2, 3]).
node(2, []).
node(3, [4, 5, 6]).
node(4, []).
node(5, []).
node(6, []).

% label(id, label)
% label(X, Y) <-> node with id X has label Y
label(1, [x1, x2]).
label(2, diagnosis).
label(3, [x1, a2, o1]).
label(4, diagnosis).
label(5, diagnosis).
label(6, diagnosis).

% hitting_set(id, hitting_set)
% hitting_set(X, Y) <-> node with id X has hitting set Y
hitting_set(1, []).
hitting_set(2, [x1]).
hitting_set(3, [x2]).
hitting_set(4, [x2, x1]).
hitting_set(5, [x2, a2]).
hitting_set(6, [x2, o1]).

% print_tree(root_id)
print_tree(Root_id) :-
	node(Root_id, Children),
	writef("Node %w\n", [Root_id]),
	label(Root_id, Label),
	writef("\tLabel: %w\n", [Label]),
	hitting_set(Root_id, Hitting_set),
	writef("\tHitting Set: %w\n", [Hitting_set]),
	!,
	member(Child, Children),
	print_tree(Child).

% nnodes([id], n)
% nnodes(X, Y) <-> the number of all nodes of trees rooted in nodes with ids in X is Y
nnodes([], N) :-
	N is 0.
nnodes([Id|Ids], N) :-
	nnodes(Id, N1),
	nnodes(Ids, N2),
	!,
	N is N1 + N2.

% nnodes(root_id, n)
% nnodes(X, Y) <-> the tree rooted in node with id X has Y nodes
nnodes(Root_id, N) :-
	node(Root_id, Children),
	nnodes(Children, N1),
	!,
	N is N1 + 1.
