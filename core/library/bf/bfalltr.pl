:- module(_, [bfalltr/3],[assertions]).

:- data bf_pred_all/3.

bfalltr(end_of_file, end_of_file, M) :- !,
        retractall_fact(bf_pred_all(M,_,_)).
bfalltr(:-(H,B), TrCls, M) :- !,
        clausetr(H, B, M, TrCls).
bfalltr((H), TrCls, M) :- !,
        clausetr(H, true, M, TrCls).

clausetr(Head, Body, M, TrCls) :-
        functor(Head, F, A),
        ( bf_pred_all(M, F, A) -> TrCls = TrCl
        ; asserta_fact(bf_pred_all(M, F, A)),
          functor(P, F, A),
          TrCls = ['$bfpred'(P),(P :- '$bf'([u([P],P)|L],L,P))| TrCl]
        ),
        body_to_dl(Body, Bodylist, Bodyrest),
        TrCl = ['$bfcl'(Head, Bodylist, Bodyrest)].
        
body_to_dl((A, B), [A|Bs], R):- !, body_to_dl(B, Bs, R).
body_to_dl(true, R, R) :- !.
body_to_dl(A, [A|R], R).
