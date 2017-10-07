% Hendrik Werner s4549775

% node(id, content, [child_id])
node(0, hendrik, [1, 2]).
node(1, alex, [3]).
node(2, conny, [4]).
node(3, mauro, []).
node(4, maurice, []).

% print_tree(root_id)
print_tree(Root_id) :-
	node(Root_id, Content, Children),
	write("Node "), write(Root_id), nl,
	write("\tContent: "), write(Content), nl,
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
