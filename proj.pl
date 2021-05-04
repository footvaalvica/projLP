% bom dia

:- [codigo_comum].

copiar(X,X).

combinacoes_soma_helper(N, Els, Soma, Combs) :-
    combinacao(N, Els, Comb),
    setof(Comb, sum_list(Comb, Soma), [Combs | _]).

combinacoes_soma(N, Els, Soma, Combs) :-
    findall(X, combinacoes_soma_helper(N, Els, Soma, X), Combs).

% sublist(SL, L, N) - SL é uma sublista de L de comprimento N
sublist(SL, L, N) :- append([_, SL, _], L), length(SL, N).

% 3.1.2
permutacoes_soma_helper(N, Els, Soma, Perms) :-
    combinacao(N, Els, X),
    permutation(X, Y),
    setof(Y, sum_list(Y, Soma), [Perms | _]).

permutacoes_soma(N, Els, Soma, Perms) :-
    findall(X, permutacoes_soma_helper(N, Els, Soma, X), Perms).

% 3.1.3

is_not_adjacent(X, Y) :-
    Y =\= X + 1.

get_not_empty_index(Fila, L) :-
    exclude(=(a), Fila, N_Vazios),
    setof(Index, (nth0(Index, Fila, X), member(X, N_Vazios)), [L | _]).

split_points(Fila, Result) :-
    length(Fila, L),
    split_points_aux(Fila, L, Result).

split_points_aux(Fila, Len, Result) :-
    Fila = [P | R], 
    nth1(Index, Fila, P),
    Index < Len,
    R = [Imp | _],
    (is_not_adjacent(R,Imp) ->
        append(Result, [Index], Result_N),
        Len_N is Len - 1,
        split_points_aux(R, Len_N, Result_N) 
    ; Len_N is Len - 1, split_points_aux(R, Len_N, Result_N)).

espaco_fila_general(Fila, Esp) :-
    length(Fila, Len),
    setof(L, get_not_empty_index(Fila, L), IndexList),
    sort(IndexList, SortedIndexList),
    append(SortedIndexList, [Len], SortedIndexListPlusEnd),
    writeln(SortedIndexListPlusEnd),
    numlist(0,Len,L),
    subtract(L, SortedIndexListPlusEnd, Result),
    writeln(Result).
    
espaco_fila_horizontal(Fila,Esp) :-
    espaco_fila_general(Fila,Esp).

espaco_fila(Fila, Esp, H_V) :-
    espaco_fila_horizontal(Fila, Esp).

% 3.1.4
% 3.1.5
% 3.1.6
% 3.1.7
% 3.1.8
% 3.1.9
% 3.1.10
% 3.1.11
% 3.1.12
% 3.1.13
% 3.1.14
% 3.1.15