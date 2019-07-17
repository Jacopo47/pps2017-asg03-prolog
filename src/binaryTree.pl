% Value, Left leaf, Right leaf
%node(V, L, R).

% IsTree - Success if the input is a tree, false otherwise.
% isTree(+Tree)
isTree(null).
isTree(node(_, L, R)) :- isTree(L), isTree(R).

% Search the given value in the tree
% search(+Tree, +SearchedValue)
% Test -> search(node(1, node(10, null, node(65, null, null)), node(5, null, node(6, null, null))),1)
search(node(V, L, R), V).
search(node(V, L, R), F) :- search(L, F), !.
search(node(V, L, R), F) :- search(R, F), !.

% Build Tree - Build a tree.
% constructBalancedTree(+TotalNodes, -BuildedTree).
constructBalancedTree(0, null) :- !.
constructBalancedTree(N,node(V,L,R)) :- N > 0,
	MAX_RAND is N + 200,
	rand_int(MAX_RAND, V),
	N0 is N - 1, 
	N1 is N0//2, N2 is N0 - N1,
	constructBalancedTree(N2,L), constructBalancedTree(N1,R), !.

%Tree to list - convert the tree into a list.
%treeToList(+tree, -List).
%Test -> treeToList(node(19, null, node(10, node(23, null, node(234, node(23, null, node(2345, null, null)), null)), null)), L).
treeToList(node(V, null, null), [V]).
treeToList(node(V, L, null), K) :- treeToList(L, L1), append([V], L1, K).
treeToList(node(V, null, R), K) :- treeToList(R, R1), append([V], R1, K).
treeToList(node(V, L, R), K) :- treeToList(L, L1), treeToList(R, R1), append(L1, R1, T), append([V], T, K), !.

%Count leaves - Count the leaves in the tree.
% countLeaves(+tree, -totalLeaves).
% Test -> countLeaves(node(19, null, node(10, node(23, null, node(234, node(23, null, node(2345, null, null)), null)), null)), L).
countLeaves(null, 0).
countLeaves(node(_, null, null), 1).	
countLeaves(node(_, L, R), K) :- countLeaves(L, L1), countLeaves(R, R1), K is L1 + R1 + 1, !.

%SumAll - Sum all the values in the tree.
% sumAll(+tree, -totalValues).
% Test -> sumAll(node(19, null, node(10, node(23, null, node(234, node(23, null, node(2345, null, null)), null)), null)), L).
sumAll(null, 0).
sumAll(node(V, null, null), V).	
sumAll(node(V, L, R), K) :- sumAll(L, L1), sumAll(R, R1), K is L1 + R1 + V, !.


%addNodeFromLeft - Add the given node in the tree. Start to search the first free position always from left.
%addNodeFromLeft(+Tree, +NewNode, -NewTree).
%Test -> addNodeFromLeft(node(1, node(4, node(40, null, null), null), node(345, null, null)), node(2, null, null), L).
addNodeFromLeft(node(V, null, R), N, node(V, N, R)).
addNodeFromLeft(node(V, L, null), N, node(V, L, N)).
addNodeFromLeft(node(V, L, R), N, node(V, K, R)) :- addNodeFromLeft(L, N, K), !.
addNodeFromLeft(node(V, L, R), N, node(V, L, K)) :- addNodeFromLeft(R, N, K), !.

%addNodeFromRight - Add the given node in the tree. Start to search the first free position always from right.
%addNodeFromRight(+Tree, +NewNode, -NewTree).
%Test -> addNodeFromRight(node(1, node(4, node(40, null, null), null), node(345, null, null)), node(2, null, null), L).
addNodeFromRight(node(V, L, null), N, node(V, L, N)).
addNodeFromRight(node(V, null, R), N, node(V, N, R)).
addNodeFromRight(node(V, L, R), N, node(V, L, K)) :- addNodeFromRight(R, N, K), !.
addNodeFromRight(node(V, L, R), N, node(V, K, R)) :- addNodeFromRight(L, N, K), !.


%TruncateFirst - Truncate the tree at the first occurence of the given value.
%truncateFirst(+Tree, +Value, -NewTree).
%Test -> truncateFirst(node(1, null, node(5, null, node(10, null, null))), 10, L).
truncateFirst(node(V, _, _), V, null).
truncateFirst(node(V, L, R), N, node(V, K, R)) :- truncateFirst(L, N, K),!.
truncateFirst(node(V, L, R), N, node(V, L, K)) :- truncateFirst(R, N, K),!.


%TreeHeight - Return the given tree's height.
%treeHeigh(+Tree, -Height).
%Test -> treeHeight(node(1, node(2, null, node(3, null, node(23, node(304, null, null),null))), node(5, null, node(10, null, null))), L).
treeHeight(null, 0).
treeHeight(node(_, null, null), 1).	
treeHeight(node(_, L, R), H) :- treeHeight(L, LH), treeHeight(R, RH), (LH > RH -> H is LH + 1; H is RH + 1), !.


%Max - Return the max value inside the tree.
%max(+Tree, -Max).
%max(node(1, node(2, null, node(3, null, node(23, node(304, null, null),null))), node(5, null, node(10, null, null))), L).
max(node(V, L, R), M) :- max(node(V, L, R), M, V).
max(null, Max, MTmp) :- Max is MTmp.
max(node(V, L, R), Max, MTmp) :- 
	(V > MTmp -> 
		max(L, ML, V), max(R, MR, V), (ML > MR -> Max is ML; Max is MR);
		max(L, ML, MTmp), max(R, MR, MTmp), (ML > MR -> Max is ML; Max is MR)
	).

%Min - Return the min value inside the tree.
%min(+Tree, -Min).
%min(node(1, node(2, null, node(3, null, node(23, node(304, null, null),null))), node(5, null, node(10, null, null))), L).
min(node(V, L, R), M) :- min(node(V, L, R), M, V).
min(null, Min, MTmp) :- Min is MTmp.
min(node(V, L, R), Min, MTmp) :- 
	(V < MTmp -> 
		min(L, ML, V), min(R, MR, V), (ML < MR -> Min is ML; Min is MR);
		min(L, ML, MTmp), min(R, MR, MTmp), (ML < MR -> Min is ML; Min is MR)
	).
