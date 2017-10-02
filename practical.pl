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
