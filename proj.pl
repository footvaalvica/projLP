% bom dia

:- [codigo_comum].

%predicados meus

combinacoes_soma_helper(N, Els, Soma, Perms) :-
    combinacao(N, Els, Comb),
    setof(Comb, sum_list(Comb, Soma), [Perms | _]).

combinacoes_soma(N, Els, Soma, Combs) :-
    findall(X, combinacoes_soma_helper(N, Els, Soma, X), Combs).

% sublist(SL, L, N) - SL é uma sublista de L de comprimento N
sublist(SL, L, N) :- append([_, SL, _], L), length(SL, N).

permutacoes_soma(N, Els, Soma, Perms) :-
    permutation(Els, Perm),
    findall(X, sublist(X, Perm, N), PermTemp),
    
    writeln(PermA).
    
    
    
    