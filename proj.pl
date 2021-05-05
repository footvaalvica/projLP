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

% 3.1.3 levar esta mt a sério

% 3.1.4
% 3.1.5
% 3.1.6
% 3.1.7
% 3.1.8
% 3.1.9
% 3.1.10
% 3.1.11
numeros_comuns(Lst_Perms, Numeros_comuns) :-
    member(Numeros_comuns, Lst_Perms).

% 3.1.12
% 3.1.13
% 3.1.14
% 3.1.15