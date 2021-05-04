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
get_not_empty_index(Fila, L) :-
    exclude(var(), Fila, N_Vazios),
    setof(Index, (nth0(Index, Fila, X), member(X, N_Vazios)), [L | _]).

nao_sei_nome(Fila, P, Dif) :-
    length(Fila, L),
    L > 1,
    Fila = [P | R],
    R = [I| _],
    Dif is I - (P + 1).

replacer(Lista1, Lista2, Ans) :-
    % para todo o X em Lista 1, obter o elem correspondente a essa index e mete lo numa lista
    nth0(X, Lista2, Elem),
    writeln(Elem).

espaco_fila_horizontal(Fila,Esp) :-
    length(Fila, Len),
    setof(L, get_not_empty_index(Fila, L), IndexList),
    sort(IndexList, SortedIndexList),
    append(SortedIndexList, [Len], SortedIndexListPlusEnd),
    nao_sei_nome(SortedIndexListPlusEnd, P, Dif),

    P_N is P + 1,
    Dif_N is Dif + P,

    nth0(P, Fila, Di),
    Di = [_ | R],

    numlist(P_N, Dif_N, Pop),
    replacer(Pop, Fila, Ans),

    R = [R_B | _ ],
    Esp = [R_B, Answer].

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