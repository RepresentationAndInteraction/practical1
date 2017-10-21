% Hendrik Werner s4549775

:- ["diagnosis"].
:- ["tp"].

:- asserta(highest_id(0)).

% node(id, [child_id])
% node(X, Y) <-> node with id X has children with ids in Y
%node(1, [2, 3]).
%node(2, []).
%node(3, [4, 5, 6]).
%node(4, []).
%node(5, []).
%node(6, []).

% label(id, label)
% label(X, Y) <-> node with id X has label Y
%label(1, [x1, x2]).
%label(2, diagnosis).
%label(3, [x1, a2, o1]).
%label(4, diagnosis).
%label(5, diagnosis).
%label(6, diagnosis).

% hitting_set(id, hitting_set)
% hitting_set(X, Y) <-> node with id X has hitting set Y
%hitting_set(1, []).
%hitting_set(2, [x1]).
%hitting_set(3, [x2]).
%hitting_set(4, [x2, x1]).
%hitting_set(5, [x2, a2]).
%hitting_set(6, [x2, o1]).

% print_tree(root_id)
print_tree(Root_id) :-
	node(Root_id, Children),
	writef("Node %w\n", [Root_id]),
	writef("\tChildren: %w\n", [Children]),
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

% make_hitting_set_tree(system_description, components, observations, id)
make_hitting_set_tree(SD, COMP, OBS, Id) :-
	make_hst(SD, COMP, OBS, [], Id),
	retract(highest_id(Highest_id)),
	New_id is Highest_id + 1,
	asserta(highest_id(New_id)).

% make_hst(system_description, components, observations, hitting_set, node_id)
make_hst(SD, COMP, OBS, HS, N) :-
	asserta(hitting_set(N, HS)),
	tp(SD, COMP, OBS, HS, CS),
	!,
	asserta(label(N, CS)),
	length(CS, Nc),
	retract(highest_id(Nh)),
	Na is Nh + 1,
	Nz is Nh + Nc,
	asserta(highest_id(Nz)),
	numlist(Na, Nz, Child_ids),
	asserta(node(N, Child_ids)),
	maplist([Component, Child_id]>>(
		make_hst(SD, COMP, OBS, [Component | HS], Child_id)
	), CS, Child_ids).

make_hst(_, _, _, _, N) :-
	asserta(node(N, [])),
	asserta(label(N, diagnosis)).

% gather_diagnoses(id, diagnoses)
% gather_diagnoses(X, Y) <-> the tree rooted in X has diagnoses Y
gather_diagnoses(Id, Diagnoses) :-
	label(Id, diagnosis),
	!,
	hitting_set(Id, Diagnosis),
	Diagnoses = [Diagnosis].

gather_diagnoses(Id, Diagnoses) :-
	node(Id, Children),
	maplist(gather_diagnoses, Children, Diagnoses1),
	foldl(append, Diagnoses1, [], Diagnoses).

% minimal_diagnoses(diagnoses, minimal_diagnoses)
% Inspired by https://stackoverflow.com/a/13739185/4637060
minimal_diagnoses([], []).
minimal_diagnoses([D | Ds], MD) :-
	select(D1, Ds, Ds1),
	subset(D, D1) ->
		minimal_diagnoses([D | Ds1], MD);
	MD = [D | MD1],
	minimal_diagnoses(Ds, MD1).

% cmp_length(delta, list1, list2)
% cmp(<, X, Y) <-> list X is shorter than list Y
% cmp(>, X, Y) <-> list X is not shorter than list Y
cmp_length(D, L1, L2) :-
	length(L1, N1),
	length(L2, N2),
	N1 < N2 -> D = <; D = > .

% diagnose(system_description, components, observations, minimal_diagnoses)
% diagnose(W, X, Y, Z) <-> The diagnostic problem described by W, X, Y has minimal diagnoses Z
diagnose(SD, COMP, OBS, MD) :-
	highest_id(Id),
	asserta(tree_root(Id)),
	make_hitting_set_tree(SD, COMP, OBS, Id),
	gather_diagnoses(Id, Diagnoses),
	predsort(cmp_length, Diagnoses, Sorted_diagnoses),
	minimal_diagnoses(Sorted_diagnoses, MD).
