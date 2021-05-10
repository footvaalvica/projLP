% bom dia

:- [codigo_comum].

% código da net
split(Index,List,Left,Right) :-
    length(Left,Index),       % Actually CREATES a list of fresh variables if "Left" is unbound
    append(Left,Right,List).  % Demand that Left + Right = List.

% tad espaco
faz_espaco(Pri, Rem, espaco(Pri, Rem)).
numero_de(espaco(Num, _), Num).
resto_de(espaco(_, Rem), Rem).
resto_vazio(Esp) :- resto_de(Esp, Rem), length(Rem, 0).

%3.1.1

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

% 3.1.3 levar esta mt a sério, resolver bug estranho
espaco_fila(Fila, Esp, h) :-
    espacos_fila(h, Fila, Espaco),
    member(Esp, Espaco).
    
espaco_fila(Fila, Esp, v) :-
    espacos_fila(v, Fila, Espaco),
    member(Esp, Espaco).

% 3.1.4
split_list(Fila, Y) :-
    exclude(var, Fila, Splits),
    member(X, Splits),
    nth0(Y, Fila, X).

get_split_list(Fila, SplitPoints) :-
    bagof(Y, split_list(Fila, Y), SplitPoints), !.

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
    list_to_set(SplitPoints, SplitPointsSet),
    reverse(SplitPointsSet, SplitPointsReversed),
    get_espacos_h(Fila, SplitPointsReversed, [], Kanye),
    exclude(resto_vazio(), Kanye, Esp), !.

espacos_fila(v, Fila, Esp) :-
    get_split_list(Fila,SplitPoints),
    list_to_set(SplitPoints, SplitPointsSet),
    reverse(SplitPointsSet, SplitPointsReversed),
    get_espacos_v(Fila, SplitPointsReversed, [], Kanye),
    exclude(resto_vazio(), Kanye, Esp), !.

% 3.1.5
espacos_puzzle_aux(Puzzle, Espaco_V, Espaco_H) :-
    mat_transposta(Puzzle, Esp),
    member(X, Puzzle),
    member(Y, Esp),
    espacos_fila(h, X, Espaco_H),
    espacos_fila(v, Y, Espaco_V).

espacos_puzzle(Puzzle, Espacos) :-
    bagof(Espaco_V, espacos_puzzle_aux(Puzzle, Espaco_V, _), Espacos_V),
    bagof(Espaco_H, espacos_puzzle_aux(Puzzle, _, Espaco_H), Espacos_H),
    append([], Espacos_H, EspacosMenosV),
    append(EspacosMenosV, Espacos_V, EspacosLista),
    flatten(EspacosLista, Espacos), !.

% 3.1.6
espacos_com_posicoes_comuns_aux(Espacos, Esp, Esps_com) :-
    bagof(Espaco, 
    (resto_de(Esp, RestoEsp), 
    member(Espaco, Espacos), 
    resto_de(Espaco, RestoEspaco),
    member(X, RestoEsp),
    member(Y, RestoEspaco),
    X == Y), 
    [Esps_com | _]).

espacos_com_posicoes_comuns(Espacos, Esp, Esps_com) :-
    bagof(Espaco, espacos_com_posicoes_comuns_aux(Espacos, Esp, Espaco), Esps_com_pred),
    exclude(=(Esp), Esps_com_pred, Esps_com).

% 3.1.7
permutacoes_soma_espacos_aux(Espacos, Perms_soma) :-
    bagof(Perms_soma_member,(
    member(X, Espacos),
    numero_de(X, Soma),
    resto_de(X, Resto),
    length(Resto, L),
    permutacoes_soma(L, [1,2,3,4,5,6,7,8,9], Soma, Perms),
    Perms_soma_member = [X, Perms]),
    Perms_soma).
    
permutacoes_soma_espacos(Espacos, Perms_soma) :-
    bagof(Perm, permutacoes_soma_espacos_aux(Espacos, Perm), Perms_soma).

% 3.1.8
permutacao_possivel_espaco(Perm, Esp, Espacos, Perms_soma) :-
    writeln(piroca).

% 3.1.9
% 3.1.10
% 3.1.11

numeros_comuns(Lst_Perms, Numeros_comuns) :-
    member(Numeros_comuns, Lst_Perms).

% 3.1.12
% 3.1.13
% 3.1.14
% 3.1.15