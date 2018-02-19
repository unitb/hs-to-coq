Require Import GHC.Base.
Import GHC.Base.Notations.
Require Import Proofs.GHC.Base.
Require Import Data.Set.Internal.
Import GHC.Num.Notations.
Require Import OrdTactic.
Require Import Psatz.
Set Bullet Behavior "Strict Subproofs".


Section WF.
Context (e : Type) {HEq : Eq_ e} {HOrd : Ord e} {HEqLaws : EqLaws e}  {HOrdLaws : OrdLaws e}.

(* We don’t have a OrdLawful class yet. We need to introduce that,
   add it to the context, and derive all axioms from that.
 *)
Lemma compare_Eq : forall (x y : e),
  compare x y = Eq <-> x == y = true.
Proof. intuition; order e. Qed.
Lemma compare_Lt : forall (x y : e),
  compare x y = Lt <-> x < y = true.
Proof. intuition; order e. Qed.
Lemma compare_Gt : forall (x y : e),
  compare x y = Gt <-> x > y = true.
Proof. intuition; order e. Qed.

Lemma lt_eq_r : forall x y z,
  x < y = true ->
  z == y = true ->
  x < z = true.
Proof. intuition; order e. Qed.

Lemma lt_eq_l : forall x y z,
  x < y = true ->
  z == x = true ->
  z < y = true.
Proof. intuition; order e. Qed.

Lemma lt_not_eq : forall (x y : e),
  x < y = true -> x == y = false.
Proof. intuition; order e. Qed.

Lemma gt_not_eq : forall (x y : e),
 x > y = true -> x == y = false.
Proof. intuition; order e. Qed.


Lemma lt_gt : forall (x y : e), (x > y) = (y < x).
Proof. intros. rewrite eq_iff_eq_true. intuition; order e. Qed.

Lemma lt_trans : forall (x y z : e),
  x < y = true -> y < z = true -> x < z = true.
Proof. intuition; order e. Qed.


(** This is just like size, but with a type signature that does not confuse [lia] *)
Definition size (s : Set_ e) : Z :=
  match s with | Bin sz _ _ _ => sz
               | Tip => 0 end.

Lemma size_size: Internal.size = size.
Proof. reflexivity. Qed.

(* Bounds may be absent (infinity) *)
Definition bound := (option e)%type.

(** A suitable comparision operator for bounds.
   If someone feels like it, then you may introduce nice notation. *)
Definition isLB : bound -> e -> bool :=
  fun lb e => match lb with
    | Some lb => lb < e
    | None => true
  end.

Definition isUB : bound -> e -> bool :=
  fun ub e => match ub with
    | Some ub => e < ub
    | None => true
  end.

Ltac order_Bounds :=
  intros;
  simpl isUB in *;
  simpl isLB in *;
  repeat (congruence || lazymatch goal with
    | H : isUB ?ub _ = false |- _ => destruct ub; simpl isUB in *
    | |-  isUB ?ub _ = _          => destruct ub; simpl isUB in *
    | H : isLB ?lb _ = false |- _ => destruct lb; simpl isLB in *
    | |-  isLB ?lb _ = _          => destruct lb; simpl isLB in *
   end);
   order e.

Lemma isLB_lt:
  forall lb x y,
  isLB lb x = true->
  x < y = true ->
  isLB lb y = true.
Proof. order_Bounds. Qed.

Lemma isUB_lt:
  forall ub x y,
  isUB ub x = true->
  y < x = true ->
  isUB ub y = true.
Proof. order_Bounds. Qed.

(** The balancing property of a binary node *)
Definition balance_prop sz1 sz2 :=
  (sz1 + sz2 <= 1 \/ sz1 <= (delta * sz2) /\ sz2 <= delta * sz1)%Z.

(** One precondition for [balanceL]: The left tree has been inserted to (but not by too much).
    This is mechanically derived from the context in the call to [balanceL] in [link], and
    unfortunately not very educational.
 *)
Definition balance_prop_inserted sz1 sz2 :=
  (delta * sz1 < ((delta + 1)*(delta + 1) - delta) * (sz2 + 1) - delta * delta /\ sz2 <= delta * sz1)%Z.


Fixpoint sem (s : Set_ e) (i : e) : bool :=
  match s with | Bin _ x s1 s2 => sem s1 i || (i == x) || sem s2 i
               | Tip => false end.

Lemma sem_resp_eq : forall s i j,
  i == j = true -> sem s i = sem s j.
Proof.
  intros.
  induction s.
  * simpl.
    rewrite IHs1, IHs2.
    replace (j == a) with (i == a) by (apply eq_true_iff_eq; split; order e).
    reflexivity.
  * reflexivity.
Qed.

(** This inductive predicate describes when sets are well-formed within 
  (exclusive) bounds.
*)


Inductive Bounded : Set_ e -> bound -> bound -> Prop :=
  | BoundedTip : forall lb ub,
    Bounded Tip lb ub
  | BoundedBin :
    forall lb ub,
    forall s1,
    forall s2,
    forall x sz,
    Bounded s1 lb (Some x) ->
    Bounded s2 (Some x) ub ->
    isLB lb x = true ->
    isUB ub x = true ->
    sz = (1 + size s1 + size s2)%Z ->
    balance_prop (size s1) (size s2) ->
    Bounded (Bin sz x s1 s2) lb ub.

(** There are no values outside the bounds *)
Lemma sem_outside_below:
  forall {s lb ub i},
  Bounded s lb ub ->
  isLB lb i = false ->
  sem s i = false.
Proof.
  intros ???? HD ?.
  induction HD; intros; subst; simpl in *; intuition.
  rewrite H2.
  rewrite IHHD2 by order_Bounds.
  rewrite orb_false_l. rewrite orb_false_r. order_Bounds.
Qed.

Lemma sem_outside_above:
  forall {s lb ub i},
  Bounded s lb ub ->
  isUB ub i = false ->
  sem s i = false.
Proof.
  intros ???? HD ?.
  induction HD; intros; subst; simpl in *; intuition.
  rewrite H2.
  rewrite IHHD1 by order_Bounds.
  rewrite orb_false_l. rewrite orb_false_r. order_Bounds.
Qed.

Lemma sem_inside:
  forall {s lb ub i},
  Bounded s lb ub ->
  sem s i = true ->
  isLB lb i = true /\ isUB ub i = true.
Proof.
  intros ???? HD ?.
  induction HD; intros; subst; simpl in *; rewrite ?orb_true_iff in *; intuition;
  order_Bounds.  
Qed.


(* We use this as a rewrite rule because
   [simpl (size (Bin _ _ _ _ ))]
   simplifies the [ 1 + _ ] which is annoying. *)
Lemma size_Bin: forall sz x (s1 s2 : Set_ e),
  size (Bin sz x s1 s2) = sz.
Proof. intros. reflexivity. Qed.

(* Pose the proof [prf], unless it already exists. *)
Ltac pose_new prf :=
  let prop := type of prf in
  match goal with 
    | [ H : prop |- _] => fail 1
    | _ => pose proof prf
  end.

(* Pose the [prop], using [prf], unless it already exists. *)
Ltac assert_new prop prf :=
  match goal with 
    | [ H : prop |- _] => fail 1
    | _ => assert prop by prf
  end.

Lemma size_nonneg:
  forall {s lb ub},
  Bounded s lb ub -> (0 <= size s)%Z.
Proof.
  intros ??? HD.
  induction HD.
  * simpl. lia.
  * simpl. lia.
Qed.


Ltac postive_sizes :=
  repeat match goal with [ H : Bounded ?s _ _ |- _ ] => pose_new (size_nonneg H) end.

Lemma size_0_iff_tip:
  forall {s lb ub},
  Bounded s lb ub -> (size s = 0)%Z <-> s = Tip.
Proof.
  intros.
  induction H.
  * intuition.
  * postive_sizes;
    rewrite ?size_Bin in *.
    intuition try (congruence || lia).
Qed.

Lemma Bounded_change_ub:
  forall s lb ub ub',
  Bounded s lb (Some ub) ->
  ub <= ub' = true ->
  Bounded s lb (Some ub').
Proof.
  intros ???? HD Heq.
  remember (Some ub) as ubo.
  induction HD; subst.
  * apply BoundedTip; auto.
  * intuition.
    eapply BoundedBin; try eassumption; try reflexivity.
    simpl in *.
    order_Bounds.
Qed.

Lemma Bounded_change_lb:
  forall s lb lb' ub,
  Bounded s (Some lb) ub ->
  lb' <= lb = true ->
  Bounded s (Some lb') ub.
Proof.
  intros ???? HD Heq.
  remember (Some lb) as lbo.
  induction HD; subst.
  * apply BoundedTip; reflexivity.
  * intuition.
    eapply BoundedBin; try eassumption; try reflexivity.
    order_Bounds.
Qed.

(* Bounded_change_ub and Bounded_relax_ub could be united with
   a isNonStrictUB predicate *)
Lemma Bounded_relax_ub:
  forall s lb ub ub',
  Bounded s lb (Some ub) ->
  isUB ub' ub = true ->
  Bounded s lb ub'.
Proof.
  intros ???? HD Heq.
  remember (Some ub) as ubo.
  induction HD; subst.
  * apply BoundedTip; auto.
  * intuition.
    eapply BoundedBin; try eassumption; try reflexivity.
    simpl in *.
    order_Bounds.
Qed.

Lemma Bounded_relax_lb:
  forall s lb lb' ub,
  Bounded s (Some lb) ub ->
  isLB lb' lb = true ->
  Bounded s lb' ub.
Proof.
  intros ???? HD Heq.
  remember (Some lb) as lbo.
  induction HD; subst.
  * apply BoundedTip; reflexivity.
  * intuition.
    eapply BoundedBin; try eassumption; try reflexivity.
    order_Bounds.
Qed.

Lemma Bounded_relax_ub_None:
  forall s lb ub,
  Bounded s lb ub ->
  Bounded s lb None.
Proof.
  intros ??? HD.
  induction HD; subst.
  * apply BoundedTip; reflexivity.
  * eapply BoundedBin; try eassumption; try reflexivity.
Qed.

Lemma Bounded_relax_lb_None:
  forall s lb ub,
  Bounded s lb ub ->
  Bounded s None ub.
Proof.
  intros ??? HD.
  induction HD; subst.
  * apply BoundedTip; reflexivity.
  * eapply BoundedBin; try eassumption; try reflexivity.
Qed.


(** In order to stay sane and speed things up, here is
 a tactic that solves [Bounded] goals, which runs 
 the right auxillary tactic on the corresponding goals. *)

Ltac expand_pairs :=
  match goal with
    |- context[let (_,_) := ?e in _] =>
    rewrite (surjective_pairing e)
  end.


(** Learns bounds of values found in some set in the context *)
Ltac inside_bounds :=
  repeat lazymatch goal with
    | H : Bounded ?s _ _, H2 : sem ?s ?i = true |- _ =>
       apply (sem_inside H) in H2; destruct H2
  end.

(** Solve [isLB] and [isUB] goals.  *)
Ltac solve_Bounds := first
  [ eassumption
  | solve [inside_bounds; order_Bounds]
  | idtac "solve_Bounds gave up"
  ].

(* Solve equations of the form
     forall i, f i = f0 i || f1 i
   possibly using equations from the context.
   Fails if it does not start with [forall i,], but may leave a partially solve goal.
    *)
Ltac f_solver_simple  :=
  let i := fresh "i" in 
  intro i;
  try reflexivity; (* for when we have an existential variable *)
  repeat match goal with [ H : ?f = _ |- context [?f i] ] => rewrite H in *; clear H end;
  repeat match goal with [ H : (forall i, ?f i = _) |- context [?f i] ] => rewrite H; clear H end;
  simpl sem; rewrite ?orb_assoc, ?orb_false_r, ?orb_false_l;
  try reflexivity.


(** This auxillary tactic destructs one boolean atom in the argument *)

Ltac split_bool_go expr :=
  lazymatch expr with 
    | true       => fail
    | false      => fail
    | Some _     => fail
    | None       => fail
    | match ?x with _ => _ end => split_bool_go x || (simpl x; cbv match)
    | negb ?x    => split_bool_go x
    | ?x && ?y   => split_bool_go x || split_bool_go y
    | ?x || ?y   => split_bool_go x || split_bool_go y
    | xorb ?x ?y => split_bool_go x || split_bool_go y
    | ?bexpr     => destruct bexpr eqn:?
  end.

(** This auxillary tactic destructs one boolean or option atom in the goal *)

Ltac split_bool :=
  match goal with 
    | [ |- ?lhs = ?rhs] => split_bool_go lhs || split_bool_go rhs
  end.

Ltac f_solver := f_solver_simple;
  repeat (try solve [exfalso; inside_bounds; order_Bounds];
          rewrite ?andb_true_r, ?andb_true_l, ?andb_false_r, ?andb_false_l,
                  ?orb_true_r, ?orb_true_l, ?orb_false_r, ?orb_false_l,
                  ?orb_assoc, ?and_assoc;
          try reflexivity;
          try lazymatch goal with
            |  H1 : (?i == ?j) = true , H2 : sem ?s ?i = true, H3 : sem ?s ?j = false |- _
              => exfalso; rewrite (sem_resp_eq s i j H1) in H2; congruence
            |  H1 : (?i == ?j) = true , H2 : sem ?s ?i = false, H3 : sem ?s ?j = true |- _
              => exfalso; rewrite (sem_resp_eq s i j H1) in H2; congruence
          end;
          split_bool || exfalso
          ).

(** A variant of [lia] that unfolds a few specific things and knows that
   the size of a well-formed tree is positive. *)
Ltac lia_sizes :=
  postive_sizes;
  unfold balance_prop, balance_prop_inserted, delta, ratio in *;
  unfold fromInteger, op_zg__, op_zl__, op_zt__, op_zp__,
                      Num_Integer__, Ord_Integer___,
                      op_zg____, op_zl____ in *;
  rewrite ?size_size in *;
  rewrite ?size_Bin in *; simpl (size Tip) in *;
  lia.

(** A tactic to solve questions about size. *)
Ltac solve_size := first
  [ assumption
  | reflexivity
  | lia_sizes
  | idtac "solve_size gave up"
  ].

(** Solve goals of Bounded. Should be back-tracking free, I think. *)
Ltac solve_Bounded := eassumption || lazymatch goal with
  | [ |- Bounded Tip _ _ ]
    => apply BoundedTip
  | [ H : Bounded ?s ?lb (Some ?ub) |- Bounded ?s ?lb (Some ?ub') ]
    => apply (Bounded_change_ub _ _ _ _ H); solve_Bounds
  | [ H : Bounded ?s (Some ?lb) ?ub  |- Bounded ?s (Some ?lb') ?ub ]
    => apply (Bounded_change_lb _ _ _ _ H); solve_Bounds
  | [ H : Bounded ?s ?lb (Some ?ub) |- Bounded ?s ?lb ?ub' ]
    => apply (Bounded_relax_ub _ _ _ _ H); solve_Bounds
  | [ H : Bounded ?s (Some ?lb) ?ub  |- Bounded ?s ?lb' ?ub ]
    => apply (Bounded_relax_lb _ _ _ _ H); solve_Bounds
  | [ |- Bounded (Bin _ _ _ _) _ _ ]
    => apply BoundedBin;
        [ solve_Bounded
        | solve_Bounded
        | solve_Bounds
        | solve_Bounds
        | solve_size
        | solve_size
        ]
  | |- ?H => fail "solve_Bounded gave up on" H
  end.

(** We now have special tactics for the three kinds of preconditions most
    our lemmas below have. So we can write a tactic that correctly chooses the
    right tactic.
    Why not simply use [first [solve_Bounded|solve_Bounds|solve_size]]?
    Because that would involve backtracking which hides error messages from us,
    and is possibly too slow.
  *)

Ltac solve_Precondition := lazymatch goal with
  | |- Bounded _ _ _          => solve_Bounded
  | |- isLB _ _ = true        => solve_Bounds
  | |- isUB _ _ = true        => solve_Bounds
  | |- context [set_size]     => simpl; lia    (* in well-founded recursion *)
  | |- _ = _                  => solve_size
  | |- context [balance_prop] => solve_size
  | |- ?H                     => fail "solve_Precondition does not recognize this goal: " H
  end.


(** A proposition of the form [Desc s lb ub sz f] tells us
  everything we need to know about [s].

  Therefore, it is phrased as an induction lemma which replaces
  the concrete Set (e.g. [insert y s]) with a fresh variable [s'],
  and adds all interesting bits about it to the context.

  To prove a [Desc] statement, use [apply showDesc].

  To use a [Desc] statement, use [applyDesc HD] or [apply foo_Desc].
  *)

Definition Desc s lb ub sz f : Prop :=
  forall (P : Set_ e -> Prop),
  (forall s,
    Bounded s lb ub ->
    size s = sz ->
    sem s = f ->
    P s) ->
  P s.

Local Inductive HIDE (P : Prop) := unhide : P -> HIDE P.
Local Lemma hide : forall {P : Prop},  HIDE P -> P. Proof. intros. inversion H. assumption. Qed.

Ltac applyDesc lem :=
  apply hide;
  eapply lem;
  [ solve_Precondition ..
  | let s := fresh "s" in 
    let HB := fresh "HB" in
    let Hsz := fresh "Hsz" in
    let Hsem := fresh "Hsem" in
    intros s HB Hsz Hsem;
    apply unhide;
    try replace (size s) in *;
    try replace (sem s) in *;
    try assumption
  ].

Require Import Coq.Logic.PropExtensionality.
Require Import Coq.Logic.FunctionalExtensionality.
Lemma showDesc :
  forall s lb ub sz f,
  Bounded s lb ub /\ size s = sz /\ (forall i, sem s i = f i) ->
  Desc s lb ub sz f.
Proof.
  intros. intros P HP.
  enough (Bounded s lb ub  /\ size s = sz /\ sem s = f ) by intuition.
  destruct H as [HB [Hsz Hf]].
  rewrite Hsz.
  replace (sem s) with f by (symmetry; extensionality i; apply Hf).
  replace (Bounded s lb ub) with True by (apply propositional_extensionality; tauto).
  intuition.
Qed.

Ltac solve_Desc := apply showDesc; split; [solve_Bounded | split; [solve_size | simpl sem; try solve [f_solver]]].

Lemma Desc_change_f:
  forall s lb ub sz f f',
  (forall i, f' i = f i) ->
  Desc s lb ub sz f' <-> Desc s lb ub sz f.
Proof.
  intros.
  split; intro HD; applyDesc HD; solve_Desc; intuition.
Qed.

(** A variant that does not indicate anything about [size]. *)

Definition Desc' s lb ub f : Prop :=
  forall (P : Set_ e -> Prop),
  (forall s,
    Bounded s lb ub ->
    True ->             (* So that we can still use [applyDesc] here *)
    sem s = f ->
    P s) ->
  P s.

Lemma showDesc' :
  forall s lb ub f,
  Bounded s lb ub /\ (forall i, sem s i = f i) ->
  Desc' s lb ub f.
Proof.
  intros. intros P HP.
  enough (Bounded s lb ub /\ sem s = f ) by intuition.
  destruct H as [HB Hf].
  replace (sem s) with f by (symmetry; extensionality i; apply Hf).
  replace (Bounded s lb ub) with True by (apply propositional_extensionality; tauto).
  intuition.
Qed.


(** And any set that has a bounds is well-formed *)
Definition WF (s : Set_ e) : Prop := Bounded s None None.

Lemma Desc_WF:
  forall s sz f,
  Desc s None None sz f -> WF s.
Proof.
  intros ??? HD.
  unfold WF.
  (* Unfortunately, [apply HD] does not work unless we have [size s] and [sem s]
     in the context. *)
  assert (Bounded s None None /\ size s = size s /\ sem s = sem s) by (apply HD; auto).
  intuition.
Qed.


(** For every set in the context, try to see if [lia] knows it is empty. *)
Ltac find_Tip :=
  match goal with [ H : Bounded ?s _ _ |- _ ] =>
    assert_new (size s = 0)%Z lia_sizes;
    rewrite (size_0_iff_tip H) in *;
    subst s;
    inversion H;
    clear H;
    subst
  end.

Require Import Coq.Program.Tactics.

Open Scope Z_scope.

(* verification of singleton *)

Lemma singleton_Desc:
  forall x lb ub,
  isLB lb x = true ->
  isUB ub x = true ->
  Desc (singleton x) lb ub 1 (fun i => i == x).
Proof.
  intros.

  unfold singleton.
  unfold fromInteger, Num_Integer__.
  solve_Desc.
Qed.


Lemma singleton_WF:
  forall y, WF (singleton y).
Proof. intros. eapply Desc_WF. eapply singleton_Desc; reflexivity. Qed.

(** ** Verifying the various balancing operations *)

Lemma balanceL_Desc:
    forall x s1 s2 lb ub,
    Bounded s1 lb (Some x) ->
    Bounded s2 (Some x) ub  ->
    isLB lb x = true ->
    isUB ub x = true->
    balance_prop (size s1) (size s2) \/
    balance_prop_inserted (size s1) (size s2) \/
    balance_prop (size s1)%Z (size s2 + 1) ->
    Desc (balanceL x s1 s2) lb ub (1 + size s1 + size s2) (fun i => sem s1 i || (i == x) || sem s2 i).
Proof.
  intros.

  unfold balanceL.
  unfold op_zg__, op_zl__, Ord_Integer___, op_zg____, op_zl____.

  repeat lazymatch goal with [ H : Bounded ?s _ _ |- context [match ?s with _ => _ end] ] => inversion H; subst; clear H end;
  repeat lazymatch goal with [ |- context [if (?x <? ?y)%Z then _ else _] ] => destruct (Z.ltb_spec x y) end;
  rewrite ?size_Bin in *; simpl (size Tip) in *; simpl sem;
  simpl isLB in *;
  simpl isUB in *.
  all: try solve [exfalso; lia_sizes]. (* Some are simply impossible *)
  all: repeat find_Tip.
  all: try solve [solve_Desc].
Qed.

Lemma balanceR_Desc:
    forall x s1 s2 lb ub,
    Bounded s1 lb (Some x) ->
    Bounded s2 (Some x) ub ->
    isLB lb x = true ->
    isUB ub x = true->
    balance_prop (size s1) (size s2) \/
    balance_prop_inserted (size s2) (size s1) \/
    balance_prop (size s1 + 1) (size s2) ->
    Desc (balanceR x s1 s2) lb ub (1 + size s1 + size s2) (fun i => sem s1 i || (i == x) || sem s2 i).
Proof.
  intros.

  unfold balanceR.
  unfold op_zg__, op_zl__, Ord_Integer___, op_zg____, op_zl____.

  repeat lazymatch goal with [ H : Bounded ?s _ _ |- context [match ?s with _ => _ end] ] => inversion H; subst; clear H end;
  repeat lazymatch goal with [ |- context [if (?x <? ?y)%Z then _ else _] ] => destruct (Z.ltb_spec x y) end;
  rewrite ?size_Bin in *; simpl (size Tip) in *; simpl sem;
  simpl isLB in *;
  simpl isUB in *.
  all: try solve [exfalso; lia_sizes]. (* Some are simply impossible *)
  all: repeat find_Tip.
  all: try solve [solve_Desc].
Qed.


Lemma insertMax_Desc:
    forall x s1 lb ub,
    Bounded s1 lb (Some x) ->
    isLB lb x = true ->
    isUB ub x = true->
    Desc (insertMax x s1) lb ub (1 + size s1) (fun i => sem s1 i || (i == x)).
Proof.
  intros.
  
  remember (Some x) as ub'. revert dependent x.
  induction H; intros; subst; cbn - [Z.add].
  * applyDesc singleton_Desc.
    solve_Desc.
  * clear IHBounded1.
    applyDesc IHBounded2.
    applyDesc balanceR_Desc.
    solve_Desc.
Qed.

Lemma insertMin_Desc:
    forall x s2 lb ub,
    Bounded s2 (Some x) ub ->
    isLB lb x = true ->
    isUB ub x = true->
    Desc (insertMin x s2) lb ub (1 + size s2) (fun i => (i == x) || sem s2 i).
Proof.
  intros.
  remember (Some x) as ub'. revert dependent x.
  induction H; intros; subst; cbn - [Z.add].
  * applyDesc singleton_Desc.
    solve_Desc.
  * clear IHBounded2.
    applyDesc IHBounded1.
    applyDesc balanceL_Desc.
    solve_Desc.
Qed.

Lemma link_eq (x : e) (s1: Set_ e)  (s2: Set_ e) :
  link x s1 s2 =
       match s1, s2 with
          | Tip , r => insertMin x r
          | l , Tip => insertMax x l
          | (Bin sizeL y ly ry as l) , (Bin sizeR z lz rz as r) =>
            if Sumbool.sumbool_of_bool ((delta GHC.Num.* sizeL) GHC.Base.< sizeR)
            then balanceL z (link x l lz) rz
            else if Sumbool.sumbool_of_bool  ((delta GHC.Num.* sizeR) GHC.Base.< sizeL)
                 then balanceR y ly (link x ry r)
                 else bin x l r
        end.
Proof.
  unfold link at 1, link_func at 1.
  rewrite Wf.WfExtensionality.fix_sub_eq_ext.
  unfold projT1, projT2.
  destruct s1, s2; reflexivity.
Qed.

(* [program_simpl] calls [simpl], which is very confusing due to [1 + _]. So
ask [Next Obligation] to use this only when it solves the goal completely. *)
Local Obligation Tactic := try solve [program_simpl].

Program Fixpoint link_Desc (x : e) (s1: Set_ e)  (s2: Set_ e)
  {measure (set_size s1 + set_size s2)} :
    forall lb ub,
    Bounded s1 lb (Some x) ->
    Bounded s2 (Some x) ub  ->
    isLB lb x = true ->
    isUB ub x = true->
    Desc (link x s1 s2) lb ub (1 + size s1 + size s2) (fun i => sem s1 i || (i == x) || sem s2 i)
    := _.
Next Obligation.
  intros.
  rewrite link_eq. 
  inversion H; subst; clear H;
  inversion H0; subst; clear H0.
  * simpl insertMin.
    applyDesc singleton_Desc.
    solve_Desc.
  * applyDesc insertMin_Desc.
    solve_Desc.
  * applyDesc insertMax_Desc.
    solve_Desc.
  * destruct (Sumbool.sumbool_of_bool _);
    only 2: destruct (Sumbool.sumbool_of_bool _);
    rewrite ?Z.ltb_lt, ?Z.ltb_ge in *.
    - applyDesc link_Desc.
      applyDesc balanceL_Desc.
      solve_Desc.
    - applyDesc link_Desc.
      applyDesc balanceR_Desc.
      solve_Desc.
    - clear link_Desc.
      unfold bin.
      solve_Desc.
Qed.

(* verification of member *)

Lemma member_spec:
 forall {s lb ub i}, Bounded s lb ub -> member i s = sem s i.
Proof.
  intros ???? HB.
  induction HB.
  * simpl. reflexivity.
  * subst; simpl.
    destruct (compare i x) eqn:?.
    + replace (i == x) with true by order_Bounds.
      rewrite orb_true_r.
      reflexivity.
    + replace (i == x) with false by order_Bounds.
      rewrite IHHB1.
      rewrite (sem_outside_below HB2) by order_Bounds.
      rewrite !orb_false_r.
      reflexivity.
    + replace (i == x) with false by order_Bounds.
      rewrite IHHB2.
      rewrite (sem_outside_above HB1) by order_Bounds.
      rewrite orb_false_l.
      reflexivity.
Qed.


(** ** verification of [insert] *)

(* The [orig] passing and the local fixpoint in insert is plain ugly, so let’s to this instead *)

Fixpoint insert' (x : e) (s : Set_ e ) : Set_ e :=
  match s with 
    | Tip => singleton x
    | Bin sz y l r => match compare x y with
      | Lt =>
        let l' := insert' x l in
        if PtrEquality.ptrEq l' l then s else balanceL y l' r
      | Gt =>
        let r' := insert' x r in 
        if PtrEquality.ptrEq r' r then s else balanceR y l r'
      | Eq =>
        if PtrEquality.ptrEq x y then s else Bin sz x l r
     end
  end.

Lemma insert_insert' : forall x s, insert x s = insert' x s.
Proof.
  intros.
  unfold insert.
  induction s; simpl.
  * destruct (compare x a); try reflexivity.
    - rewrite IHs1. reflexivity.
    - rewrite IHs2. reflexivity.
  * reflexivity.
Qed.

Lemma insert_Desc:
  forall y s lb ub,
  Bounded s lb ub ->
  isLB lb y = true ->
  isUB ub y = true ->
  Desc (insert y s) lb ub (if sem s y then size s else (1 + size s)%Z) (fun i => (i == y) || sem s i).
Proof.
  intros ???? HB HLB HUB.

  rewrite insert_insert'.
  induction HB; intros.
  * simpl.
    applyDesc singleton_Desc; try eassumption; solve_Desc.
  * subst; cbn -[Z.add].
    destruct (compare y x) eqn:?.
    + rewrite compare_Eq in *.
      rewrite Heqc.
      rewrite ?orb_true_r, ?orb_true_l.
      destruct (PtrEquality.ptrEq _ _) eqn:Hpe; [| clear Hpe]. 
      - apply PtrEquality.ptrEq_eq in Hpe; subst.
        solve_Desc.
      - unfold Datatypes.id.
        solve_Desc.
    + clear IHHB2.
      applyDesc IHHB1.

      rewrite (sem_outside_below HB2) by order_Bounds.
      replace (y == x) with false by order_Bounds.
      rewrite ?orb_false_r, ?orb_false_l.

      (* worth having a tactic that combines destruct and ptrEq_eq? *)
      destruct (PtrEquality.ptrEq _ _) eqn:Hpe; only 2: clear Hpe.
      - apply PtrEquality.ptrEq_eq in Hpe; subst.
        replace (sem s1 y) with true
           by (destruct (sem s1 y) eqn:?; auto; exfalso; lia).
        solve_Desc.
      - destruct (sem s1 y);
        applyDesc balanceL_Desc;
        solve_Desc.
    + (* more or less a copy-n-paste from above *)
      clear IHHB1.
      applyDesc IHHB2.

      rewrite (sem_outside_above HB1) by order_Bounds.
      replace (y == x) with false by order_Bounds.
      rewrite ?orb_false_r, ?orb_false_l.

      destruct (PtrEquality.ptrEq _ _) eqn:Hpe; only 2: clear Hpe.
      - apply PtrEquality.ptrEq_eq in Hpe; subst.
        replace (sem s2 y) with true
           by (destruct (sem s2 y) eqn:?; auto; exfalso; lia).
        solve_Desc.
      - destruct (sem s2 y);
        applyDesc balanceR_Desc;
        solve_Desc.
Qed.

(** For our purposes, [insertR] and [insert] are equivalent (the sets 
    are equal up to [==] of elements. *)
Lemma insertR_Desc:
  forall y s lb ub,
  Bounded s lb ub ->
  isLB lb y = true ->
  isUB ub y = true ->
  Desc (insertR y s) lb ub (if sem s y then size s else (1 + size s)%Z) (fun i => (i == y) || sem s i).
Admitted.

Lemma insert_WF:
  forall y s, WF s -> WF (insert y s).
Proof. intros. eapply Desc_WF. eapply insert_Desc; try reflexivity; try assumption. Qed.

(** ** Verification of [maxViewSure] *)

Lemma maxViewSure_Desc:
  forall sz' x s1 s2 lb ub,
    Bounded (Bin sz' x s1 s2) lb ub ->
    forall P,
    (forall y r,
      ((y == x) = true \/ sem s2 y = true) /\
      Desc r lb (Some y) (size s1 + size s2)
                         (fun i => (sem s1 i || (i == x) || sem s2 i) && negb (i == y)) ->
      P (y, r)) ->
    P (maxViewSure x s1 s2).
    (* we know that y is in the input, and we actually know more: it is x or in s2 *)
Proof.
  intros ?????? HB.
  revert sz' x s1 lb ub HB.
  induction s2; intros sz' x s1 lb ub HB;subst.
  - clear IHs2_1.
    simpl.
    intros X HX; rewrite (surjective_pairing (maxViewSure _ _ _)). apply HX; clear X HX.

    inversion HB; subst; clear HB.
    inversion H4; subst.

    eapply IHs2_2; only 1: solve_Bounded; intros y r H; destruct H as [Hthere IHD]; clear IHs2_2.
    cbn -[Z.add size] in *; rewrite size_Bin in *.

    applyDesc IHD; clear IHD.

    split.
    + rewrite <- !orb_assoc. right. destruct Hthere as [H|H]; rewrite H;
      rewrite ?orb_true_r, ?orb_true_r; reflexivity.
    + destruct Hthere; applyDesc balanceL_Desc; solve_Desc.
  - intros X HX; rewrite (surjective_pairing (maxViewSure _ _ _)). apply HX; clear X HX.
    cbn -[Z.add size] in *.
    inversion HB; subst; clear HB.
    rewrite Eq_refl.
    split; [left; reflexivity | solve_Desc].
Qed.

(** ** Verification of [minViewSure] *)

Lemma minViewSure_Desc:
  forall sz' x s1 s2 lb ub,
    Bounded (Bin sz' x s1 s2) lb ub ->
    forall P,
    (forall y r,
      ((y == x) = true \/ sem s1 y = true) /\
      Desc r (Some y) ub (size s1 + size s2)
                         (fun i => (sem s1 i || (i == x) || sem s2 i) && negb (i == y)) ->
      P (y, r)) ->
    P (minViewSure x s1 s2).
    (* we know that y is in the input, and we actually know more: it is x or in s2 *)
Proof.
  intros ?????? HB.
  revert sz' x s2 lb ub HB.
  induction s1; intros sz' x s2 lb ub HB;subst.
  - clear IHs1_2.
    simpl.
    intros X HX; rewrite (surjective_pairing (minViewSure _ _ _)). apply HX; clear X HX.

    inversion HB; subst; clear HB.
    inversion H3; subst.

    eapply IHs1_1; only 1: solve_Bounded; intros y r [Hthere IHD]; clear IHs1_1.
    cbn -[Z.add size] in *; rewrite size_Bin in *.

    applyDesc IHD; clear IHD.

    split.
    + rewrite <- !orb_assoc. right. destruct Hthere as [H|H]; rewrite H;
      rewrite ?orb_true_r, ?orb_true_r; reflexivity.
    + destruct Hthere; applyDesc balanceR_Desc; solve_Desc.
  - intros X HX; rewrite (surjective_pairing (minViewSure _ _ _)). apply HX; clear X HX.
    cbn -[Z.add size] in *.
    inversion HB; subst; clear HB.
    rewrite Eq_refl.
    split; [left; reflexivity | solve_Desc].
Qed.

(** ** Verification of [glue] *)

Lemma glue_Desc:
  forall s1 s2 lb ub x,
  Bounded s1 lb (Some x) ->
  Bounded s2 (Some x) ub ->
  isLB lb x = true ->
  isUB ub x = true ->
  balance_prop (size s1) (size s2) ->
  Desc (glue s1 s2) lb ub ((size s1 + size s2)%Z) (fun i => sem s1 i || sem s2 i).
Proof.
  intros ????? HB1 HB2 ???.

  inversion HB1; inversion HB2; subst; cbn -[Z.add]; clear HB1 HB2.
  1-3: solve [solve_Desc|solve_size].
  destruct (Z.ltb_spec (1 + size s4 + size s5) (1 + size s0 + size s3)).
  - eapply maxViewSure_Desc; only 1: solve_Bounded.
    intros y r [Hthere HD].
    applyDesc HD.
    destruct Hthere; applyDesc balanceR_Desc; solve_Desc.
  - eapply minViewSure_Desc; only 1: solve_Bounded.
    intros y r [Hthere HD].
    applyDesc HD.
    destruct Hthere; applyDesc balanceL_Desc; solve_Desc.
Qed.

(** ** Verification of [delete] *)

Lemma delete_Desc :
  forall x s lb ub,
  Bounded s lb ub ->
  Desc (delete x s) lb ub (if sem s x then (size s - 1) else size s) (fun i => sem s i && negb (i == x)).
Proof.
  intros ???? HB.
  induction HB; intros; subst.
  - simpl. solve_Desc.
  - cbn -[Z.add].
    destruct (compare x x0) eqn:Heq.
    + applyDesc glue_Desc.
      solve_Desc.
      simpl sem.
      replace (x == x0) with true by solve_Bounds.
      rewrite orb_true_r. cbn -[Z.add]. solve_size.
    + applyDesc IHHB1; clear IHHB1 IHHB2.
      replace (x == x0) with false by solve_Bounds.
      rewrite -> (sem_outside_below HB2) by solve_Bounds.
      rewrite ?orb_false_r.
      destruct (PtrEquality.ptrEq s s1) eqn:Heq0.
      * apply PtrEquality.ptrEq_eq in Heq0; subst.
        replace (sem s1 x) with false by (destruct (sem s1 x); try congruence; lia).
        solve_Desc.
      * destruct (sem s1 x); applyDesc balanceR_Desc; solve_Desc.
    + applyDesc IHHB2; clear IHHB1 IHHB2.
      replace (x == x0) with false by solve_Bounds.
      rewrite -> (sem_outside_above HB1) by solve_Bounds.
      rewrite ?orb_false_l.
      destruct (PtrEquality.ptrEq s s2) eqn:Heq0.
      * apply PtrEquality.ptrEq_eq in Heq0; subst.
        replace (sem s2 x) with false by (destruct (sem s2 x); try congruence; lia).
        solve_Desc.
      * destruct (sem s2 x); applyDesc balanceL_Desc; solve_Desc.
Qed.

(** ** Verification of [union] *)

Lemma splitS_Desc :
  forall x s lb ub,
  Bounded s lb ub ->
  forall P,
  (forall s1 s2,
    Bounded s1 lb (Some x) ->
    Bounded s2 (Some x) ub ->
    (forall i, sem s i = sem s1 i || sem s2 i) ->
    P (s1, s2)) ->
  P (splitS x s).
Admitted.


Lemma union_Desc :
  forall s1 s2 lb ub,
  Bounded s1 lb ub ->
  Bounded s2 lb ub ->
  Desc' (union s1 s2) lb ub (fun i => sem s1 i || sem s2 i).
Admitted.
(* We use [Desc'] here, because the result of [union] is passed to [link], which
   does a full rebalance, and hence does not need to know anything about the size.
   If it turns out we need [size (union s1 s2)], we can still add it.
*)


End WF.
