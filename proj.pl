% bom dia

:- [codigo_comum].

copiar(X,X).

split(Index,List,Left,Right) :-
    length(Left,Index),       % Actually CREATES a list of fresh variables if "Left" is unbound
    append(Left,Right,List).  % Demand that Left + Right = List.

count_occurrences(List, Occ):-
    findall([X,L], (bagof(true,member(X,List),Xs), length(Xs,L)), Occ).

% sublist(SL, L, N) - SL e uma sublista de L de comprimento N
sublista(SL, L, N) :- append([_, SL, _], L), length(SL, N).

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


% 3.1.2
permutacoes_soma_helper(N, Els, Soma, Y) :-
    combinacao(N, Els, X),
    permutation(X, Y),
    sum_list(Y, Soma).

permutacoes_soma(N, Els, Soma, Perms) :-
    setof(X, permutacoes_soma_helper(N, Els, Soma, X), Perms).

% 3.1.3 levar esta mt a serio, resolver bug estranho
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
    %R e os split points
    %Resto e o resto da lista que falta dar split
    faz_espaco(Mano, Rem, Espace),
    get_espacos_h(Resto, R, [Espace | Aux], Esp), !.

get_espacos_v(_, [], Aux, Aux). 

get_espacos_v(Fila, SplitPoints, Aux, Esp) :-
    SplitPoints = [P | R],
    split(P, Fila, Resto, Espaco),
    Espaco = [Pri | Rem],
    Pri = [Mano | _],
    %R e os split points
    %Resto e o resto da lista que falta dar split
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
    member(X, Espacos),
    numero_de(X, Soma),
    resto_de(X, El),
    length(El, L),
    permutacoes_soma(L, [1,2,3,4,5,6,7,8,9], Soma, Els),
    Perms_soma = [X, Els].

permutacoes_soma_espacos(Espacos, Perms_soma) :-
    bagof(X, permutacoes_soma_espacos_aux(Espacos, X), Perms_soma).

% 3.1.8
nth0meu(Index, Lista, Var) :-
    nth0meu(Var, Lista, 0, Index).

nth0meu(_, [], Acl, Acl).

nth0meu(Var, Lista, Acl, Index) :-
    Lista = [P | _],
    Var == P,
    Index = Acl.

nth0meu(Var, Lista, Acl, Index) :-
    Lista = [P | R],
    \+ Var == P,
    Acl_N is Acl + 1,
    nth0meu(Var, R, Acl_N, Index).

membro(E, [Q | _]) :- E == Q.
membro(E, [_| R]) :- membro(E, R).

var_comum(Lista1, Lista2, Var) :-
    bagof(X, (member(X, Lista1), member(Y, Lista2), X == Y), Var).

get_specific_perms(Esps_com, Perms_soma, Esps) :-
    bagof(X, (member(X, Perms_soma),
    X = [P | _],
    member(Y, Esps_com),
    Y == P), [Esps | _]).

permutacao_possivel_espaco_aux(Permes, Esp, Espacos, Perms_soma) :-
    % fazer debug nesta merda
    espacos_com_posicoes_comuns(Espacos, Esp, Esps_com),
    bagof(Y, get_specific_perms(Esps_com, Perms_soma, Y), Esps),
    bagof(X, (member(X, Perms_soma), X = [P | _], P == Esp), [Espi | _]),
    resto_de(Esp, Mat),
    Espi = [_ | [Coisa | _]],
    findall(F, (member(Nas, Esps),
    Nas = [A | B],
    B = [PermEspacos | _],
    flatten(PermEspacos, CompareList),
    resto_de(Esp, Mat),
    resto_de(A, Mateus),
    var_comum(Mat, Mateus, [Var | _]),
    nth0meu(Index, Mat, Var),
    member(F, Coisa),
    nth0(Index, F, Num),
    intersection([Num], CompareList, Quase),
    length(Quase, L), L > 0), Permes).

permutacao_possivel_espaco_todas(Perms, Esp, Espacos, Perms_soma) :-
    permutacao_possivel_espaco_aux(Permes, Esp, Espacos, Perms_soma),
    resto_de(Esp,Mat),
    length(Mat, L),
    count_occurrences(Permes, Occ),
    findall(I, (member(X, Occ), X = [I | [K | _]], K = L), Perms).

permutacao_possivel_espaco(Perm, Esp, Espacos, Perms_soma) :-
    permutacao_possivel_espaco_todas(Perms, Esp, Espacos, Perms_soma),
    member(Perm, Perms).

% 3.1.9
permutacoes_possiveis_espaco(Espacos, Perms_soma, Esp, Perms_poss) :-
    permutacao_possivel_espaco_todas(Perms, Esp, Espacos, Perms_soma),
    resto_de(Esp, Mat),
    append([Mat], [Perms], Perms_poss).

% 3.1.10
permutacoes_possiveis_espacos(Espacos, Perms_poss_esps) :-
    bagof(X, permutacoes_possiveis_espacos_aux(Espacos, X), Perms_poss_esps).

permutacoes_possiveis_espacos_aux(Espacos, Perms_poss) :-
    permutacoes_soma_espacos(Espacos, Perms_soma),
    member(Esp, Espacos), permutacoes_possiveis_espaco(Espacos, Perms_soma, Esp, Perms_poss).

% 3.1.11
length_one(List) :-
    length(List, 1).

numeros_comuns(Lst_Perms, Numeros_comuns) :-
    numeros_comuns_aux2(Lst_Perms, [], Processor),
    include(length_one(), Processor, Almost),
    flatten(Almost, LookupList),
    Lst_Perms = [P | _],
    findall((X,Y), (member(Y, LookupList), nth1(X, P, Y)), Numeros_comuns).

numeros_comuns_aux2(Lst_Perms, Acl, Numeros_comuns) :-
    numeros_comuns_aux(Lst_Perms, Acl, Numeros_comuns), !.

numeros_comuns_aux([], Acl, Acl).

numeros_comuns_aux(Lst_Perms, Acl, Numeros_comuns) :-
    findall(P, (member(X, Lst_Perms), X = [P | R]), Lista),
    findall(R, (member(X, Lst_Perms), X = [P | R]), NewLstPerms),
    list_to_set(Lista, ListaSet),
    append(Acl, [ListaSet], JayZ),
    numeros_comuns_aux(NewLstPerms, JayZ, Numeros_comuns).

% 3.1.12
substitui_comuns(_, []).

substitui_comuns(Esp, [(Indice, Numero) | R]) :-
    nth1(Indice, Esp, Numero),
    substitui_comuns(Esp, R).

atribui_comuns([Lst|R]) :-
    Lst = [Esp, Perms],
    numeros_comuns(Perms, Lst_Comuns),
    substitui_comuns(Esp, Lst_Comuns), atribui_comuns(R), !.
  
atribui_comuns([]).

% 3.1.13
se_unifica(Lista1, Lista2) :-
    subsumes_term(Lista1, Lista2).

retira_impossiveis_aux([Lst|R], Acl, Output) :-
    Lst = [Fir, Sec],
    findall(X, (member(X, Sec), subsumes_term(Fir, X)), Out),
    retira_impossiveis_aux(R, [Out | Acl], Output).

retira_impossiveis_aux([], Acl, Acl).

retira_impossiveis_auxL(Perms_Possiveis, Pri, X) :-
    retira_impossiveis_aux(Perms_Possiveis, [], Output),
    reverse(Output, Useful),
    member(X, Useful),
    nth0(Index, Useful, X),
    nth0(Index, Perms_Possiveis, Var),
    Var = [Pri, _].

retira_impossiveis(Perms_Possiveis, Novas_Perms_Possiveis) :-
    bagof([Pri, X], retira_impossiveis_auxL(Perms_Possiveis, Pri, X), Novas_Perms_Possiveis).

% 3.1.14
simplifica(Perms_Possiveis, Novas_Perms_Possiveis) :-
    atribui_comuns(Perms_Possiveis),
    retira_impossiveis(Perms_Possiveis, A),
    (\+(Perms_Possiveis == A) -> simplifica(A, Novas_Perms_Possiveis); Novas_Perms_Possiveis = A).

% 3.1.15
inicializa(Puzzle, Perms_Possiveis) :-
    espacos_puzzle(Puzzle, Espacos),
    permutacoes_possiveis_espacos(Espacos, Perms_poss_esps),
    simplifica(Perms_poss_esps, Perms_Possiveis).

% 3.2.1
descobrir_menor_comprimento(Perms_Possiveis, L) :-
    findall(L, (member(X, Perms_Possiveis), X = [_, R], length(R, L)), LengthList),
    exclude(=(1), LengthList, Mateus),
    min_list(Mateus, L).

escolhe_menos_alternativas(Perms_Possiveis, X) :-
    descobrir_menor_comprimento(Perms_Possiveis, K),
    member(X, Perms_Possiveis),
    X = [_, R],
    length(R, L),
    L == K, !.