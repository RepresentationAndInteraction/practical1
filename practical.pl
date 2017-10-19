% Hendrik Werner s4549775

:- ["diagnosis"].
:- ["tp"].

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
	maplist(print_tree, Children).

% nnodes(root_id, n)
% nnodes(X, Y) <-> the tree rooted in node with id X has Y nodes
nnodes(Root_id, N) :-
	node(Root_id, Children),
	maplist(nnodes, Children, Nodes),
	sumlist(Nodes, N1),
	!,
	N is N1 + 1.

% is_hitting_set_tree(root_id)
% is_hitting_set_tree(X) <-> the tree rooted in node with id X is a hitting set tree
is_hitting_set_tree(Root_id) :-
	is_hst([], Root_id).

% is_hst(id, previous_hitting_set)
is_hst(Previous_hitting_set, Id) :-
	% the node has a valid hitting set defined
	hitting_set(Id, Hitting_set),
	(
		Hitting_set = [];
		subtract(Hitting_set, Previous_hitting_set, [_])
	),
	!,
	% the node has a valid label
	label(Id, Label),
	(
		Label = diagnosis;
		is_list(Label)
	),
	!,
	% the node either has no children, or the children are HSTs
	node(Id, Children),
	maplist(is_hst(Hitting_set), Children),
	!.

% make_hitting_set_tree(system_description, components, observations)
