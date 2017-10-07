% Hendrik Werner s4549775

% node(id, label, hitting_set, [child_id])
node(1, [x1, x2], [], [2, 3]).
node(2, diagnosis, [x1], []).
node(3, [x1, a2, o1], [x2], [4, 5, 6]).
node(4, diagnosis, [x1, x2], []).
node(5, diagnosis, [x1, a2], []).
node(6, diagnosis, [x1, o1], []).

% print_tree(root_id)
print_tree(Root_id) :-
	node(Root_id, Label, Hitting_set, Children),
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
