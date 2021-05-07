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

espaco_fila(Fila, Esp, h) :-
    espacos_fila(h, Fila, Espaco),
    member(Esp, Espaco).
    
espaco_fila(Fila, Esp, v) :-
    espacos_fila(v, Fila, Espaco),
    member(Esp, Espaco).

% 3.1.4
split(Index,List,Left,Right) :-
    length(Left,Index),       % Actually CREATES a list of fresh variables if "Left" is unbound
    append(Left,Right,List).  % Demand that Left + Right = List.

split_list(Fila, Y) :-
    exclude(var, Fila, Splits),
    member(X, Splits),
    nth0(Y, Fila, X).

get_split_list(Fila, SplitPoints) :-
    bagof(Y, split_list(Fila, Y), SplitPoints), !.

faz_espaco(Pri, Rem, espaco(Pri, Rem)).

resto_de(espaco(_, Rem), Rem).

resto_vazio(Esp) :- resto_de(Esp, Rem), length(Rem, 0).

get_espacos_h(_, [], Aux, Aux). 

get_espacos_h(Fila, SplitPoints, Aux, Esp) :-
    SplitPoints = [P | R],
    split(P, Fila, Resto, Espaco),
    Espaco = [Pri | Rem],
    Pri = [_ | EspacoH],
    EspacoH = [Mano | _ ],
    %R é os split points
    %Resto é o resto da lista que falta dar split
    faz_espaco(Mano, Rem, Espace),
    get_espacos_h(Resto, R, [Espace | Aux], Esp), !.

get_espacos_v(_, [], Aux, Aux). 

get_espacos_v(Fila, SplitPoints, Aux, Esp) :-
    SplitPoints = [P | R],
    split(P, Fila, Resto, Espaco),
    Espaco = [Pri | Rem],
    Pri = [Mano | _],
    %R é os split points
    %Resto é o resto da lista que falta dar split
    faz_espaco(Mano, Rem, Espace),
    get_espacos_v(Resto, R, [Espace | Aux], Esp), !.

espacos_fila(h, Fila, Esp) :-
    get_split_list(Fila,SplitPoints),
    reverse(SplitPoints, SplitPointsReversed),
    get_espacos_h(Fila, SplitPointsReversed, [], Kanye),
    exclude(resto_vazio(), Kanye, Esp), !.

espacos_fila(v, Fila, Esp) :-
    get_split_list(Fila,SplitPoints),
    reverse(SplitPoints, SplitPointsReversed),
    get_espacos_v(Fila, SplitPointsReversed, [], Kanye),
    exclude(resto_vazio(), Kanye, Esp), !.

espacos_puzzle(Puzzle, Espacos) :-

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