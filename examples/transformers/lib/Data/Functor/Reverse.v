(* Default settings (from HsToCoq.Coq.Preamble) *)

Generalizable All Variables.

Unset Implicit Arguments.
Set Maximal Implicit Insertion.
Unset Strict Implicit.
Unset Printing Implicit Defensive.

Require Coq.Program.Tactics.
Require Coq.Program.Wf.

(* Converted imports: *)

Require Import Data.Functor.Classes.
Require GHC.Base.
Import GHC.Base.Notations.

(* Converted type declarations: *)

Inductive Reverse (f : Type -> Type) (a : Type) : Type
  := Mk_Reverse : f a -> Reverse f a.

Arguments Mk_Reverse {_} {_} _.

Definition getReverse {f : Type -> Type} {a : Type} (arg_0__ : Reverse f a) :=
  let 'Mk_Reverse getReverse := arg_0__ in
  getReverse.
(* Converted value declarations: *)

Local Definition Eq1__Reverse_liftEq {inst_f} `{(Eq1 inst_f)}
   : forall {a} {b},
     (a -> b -> bool) -> (Reverse inst_f) a -> (Reverse inst_f) b -> bool :=
  fun {a} {b} =>
    fun arg_0__ arg_1__ arg_2__ =>
      match arg_0__, arg_1__, arg_2__ with
      | eq, Mk_Reverse x, Mk_Reverse y => liftEq eq x y
      end.

Program Instance Eq1__Reverse {f} `{(Eq1 f)} : Eq1 (Reverse f) :=
  fun _ k => k {| liftEq__ := fun {a} {b} => Eq1__Reverse_liftEq |}.

Local Definition Ord1__Reverse_liftCompare {inst_f} `{(Ord1 inst_f)}
   : forall {a} {b},
     (a -> b -> comparison) ->
     (Reverse inst_f) a -> (Reverse inst_f) b -> comparison :=
  fun {a} {b} =>
    fun arg_0__ arg_1__ arg_2__ =>
      match arg_0__, arg_1__, arg_2__ with
      | comp, Mk_Reverse x, Mk_Reverse y => liftCompare comp x y
      end.

Program Instance Ord1__Reverse {f} `{(Ord1 f)} : Ord1 (Reverse f) :=
  fun _ k => k {| liftCompare__ := fun {a} {b} => Ord1__Reverse_liftCompare |}.

(* Translating `instance Read1__Reverse' failed: OOPS! Cannot find information
   for class Qualified "Data.Functor.Classes" "Read1" unsupported *)

(* Translating `instance Show1__Reverse' failed: OOPS! Cannot find information
   for class Qualified "Data.Functor.Classes" "Show1" unsupported *)

Local Definition Eq___Reverse_op_zeze__ {inst_f} {inst_a} `{Eq1 inst_f}
  `{GHC.Base.Eq_ inst_a}
   : (Reverse inst_f inst_a) -> (Reverse inst_f inst_a) -> bool :=
  eq1.

Local Definition Eq___Reverse_op_zsze__ {inst_f} {inst_a} `{Eq1 inst_f}
  `{GHC.Base.Eq_ inst_a}
   : (Reverse inst_f inst_a) -> (Reverse inst_f inst_a) -> bool :=
  fun x y => negb (Eq___Reverse_op_zeze__ x y).

Program Instance Eq___Reverse {f} {a} `{Eq1 f} `{GHC.Base.Eq_ a}
   : GHC.Base.Eq_ (Reverse f a) :=
  fun _ k =>
    k {| GHC.Base.op_zeze____ := Eq___Reverse_op_zeze__ ;
         GHC.Base.op_zsze____ := Eq___Reverse_op_zsze__ |}.

Local Definition Ord__Reverse_compare {inst_f} {inst_a} `{Ord1 inst_f}
  `{GHC.Base.Ord inst_a}
   : (Reverse inst_f inst_a) -> (Reverse inst_f inst_a) -> comparison :=
  compare1.

Local Definition Ord__Reverse_op_zg__ {inst_f} {inst_a} `{Ord1 inst_f}
  `{GHC.Base.Ord inst_a}
   : (Reverse inst_f inst_a) -> (Reverse inst_f inst_a) -> bool :=
  fun x y => Ord__Reverse_compare x y GHC.Base.== Gt.

Local Definition Ord__Reverse_op_zgze__ {inst_f} {inst_a} `{Ord1 inst_f}
  `{GHC.Base.Ord inst_a}
   : (Reverse inst_f inst_a) -> (Reverse inst_f inst_a) -> bool :=
  fun x y => Ord__Reverse_compare x y GHC.Base./= Lt.

Local Definition Ord__Reverse_op_zl__ {inst_f} {inst_a} `{Ord1 inst_f}
  `{GHC.Base.Ord inst_a}
   : (Reverse inst_f inst_a) -> (Reverse inst_f inst_a) -> bool :=
  fun x y => Ord__Reverse_compare x y GHC.Base.== Lt.

Local Definition Ord__Reverse_op_zlze__ {inst_f} {inst_a} `{Ord1 inst_f}
  `{GHC.Base.Ord inst_a}
   : (Reverse inst_f inst_a) -> (Reverse inst_f inst_a) -> bool :=
  fun x y => Ord__Reverse_compare x y GHC.Base./= Gt.

Local Definition Ord__Reverse_max {inst_f} {inst_a} `{Ord1 inst_f}
  `{GHC.Base.Ord inst_a}
   : (Reverse inst_f inst_a) ->
     (Reverse inst_f inst_a) -> (Reverse inst_f inst_a) :=
  fun x y => if Ord__Reverse_op_zlze__ x y : bool then y else x.

Local Definition Ord__Reverse_min {inst_f} {inst_a} `{Ord1 inst_f}
  `{GHC.Base.Ord inst_a}
   : (Reverse inst_f inst_a) ->
     (Reverse inst_f inst_a) -> (Reverse inst_f inst_a) :=
  fun x y => if Ord__Reverse_op_zlze__ x y : bool then x else y.

Program Instance Ord__Reverse {f} {a} `{Ord1 f} `{GHC.Base.Ord a}
   : GHC.Base.Ord (Reverse f a) :=
  fun _ k =>
    k {| GHC.Base.op_zl____ := Ord__Reverse_op_zl__ ;
         GHC.Base.op_zlze____ := Ord__Reverse_op_zlze__ ;
         GHC.Base.op_zg____ := Ord__Reverse_op_zg__ ;
         GHC.Base.op_zgze____ := Ord__Reverse_op_zgze__ ;
         GHC.Base.compare__ := Ord__Reverse_compare ;
         GHC.Base.max__ := Ord__Reverse_max ;
         GHC.Base.min__ := Ord__Reverse_min |}.

(* Translating `instance Read__Reverse' failed: OOPS! Cannot find information
   for class Qualified "GHC.Read" "Read" unsupported *)

(* Translating `instance Show__Reverse' failed: OOPS! Cannot find information
   for class Qualified "GHC.Show" "Show" unsupported *)

Local Definition Functor__Reverse_fmap {inst_f} `{(GHC.Base.Functor inst_f)}
   : forall {a} {b}, (a -> b) -> (Reverse inst_f) a -> (Reverse inst_f) b :=
  fun {a} {b} =>
    fun arg_0__ arg_1__ =>
      match arg_0__, arg_1__ with
      | f, Mk_Reverse a => Mk_Reverse (GHC.Base.fmap f a)
      end.

Local Definition Functor__Reverse_op_zlzd__ {inst_f} `{(GHC.Base.Functor
   inst_f)}
   : forall {a} {b}, a -> (Reverse inst_f) b -> (Reverse inst_f) a :=
  fun {a} {b} => fun x => Functor__Reverse_fmap (GHC.Base.const x).

Program Instance Functor__Reverse {f} `{(GHC.Base.Functor f)}
   : GHC.Base.Functor (Reverse f) :=
  fun _ k =>
    k {| GHC.Base.op_zlzd____ := fun {a} {b} => Functor__Reverse_op_zlzd__ ;
         GHC.Base.fmap__ := fun {a} {b} => Functor__Reverse_fmap |}.

Local Definition Applicative__Reverse_op_zlztzg__ {inst_f}
  `{(GHC.Base.Applicative inst_f)}
   : forall {a} {b},
     (Reverse inst_f) (a -> b) -> (Reverse inst_f) a -> (Reverse inst_f) b :=
  fun {a} {b} =>
    fun arg_0__ arg_1__ =>
      match arg_0__, arg_1__ with
      | Mk_Reverse f, Mk_Reverse a => Mk_Reverse (f GHC.Base.<*> a)
      end.

Local Definition Applicative__Reverse_op_ztzg__ {inst_f} `{(GHC.Base.Applicative
   inst_f)}
   : forall {a} {b},
     (Reverse inst_f) a -> (Reverse inst_f) b -> (Reverse inst_f) b :=
  fun {a} {b} =>
    fun x y =>
      Applicative__Reverse_op_zlztzg__ (GHC.Base.fmap (GHC.Base.const GHC.Base.id) x)
                                       y.

Local Definition Applicative__Reverse_pure {inst_f} `{(GHC.Base.Applicative
   inst_f)}
   : forall {a}, a -> (Reverse inst_f) a :=
  fun {a} => fun a => Mk_Reverse (GHC.Base.pure a).

Program Instance Applicative__Reverse {f} `{(GHC.Base.Applicative f)}
   : GHC.Base.Applicative (Reverse f) :=
  fun _ k =>
    k {| GHC.Base.op_ztzg____ := fun {a} {b} => Applicative__Reverse_op_ztzg__ ;
         GHC.Base.op_zlztzg____ := fun {a} {b} => Applicative__Reverse_op_zlztzg__ ;
         GHC.Base.pure__ := fun {a} => Applicative__Reverse_pure |}.

(* Translating `instance Alternative__Reverse' failed: OOPS! Cannot find
   information for class Qualified "GHC.Base" "Alternative" unsupported *)

(* Translating `instance Foldable__Reverse' failed: Giving up on mutual
   recursion[Qualified "Data.Foldable" "foldl",Qualified "Data.Foldable" "foldr"]
   unsupported *)

(* Skipping instance Traversable__Reverse *)

(* Unbound variables:
     Eq1 Gt Lt Ord1 Type bool compare1 comparison eq1 liftCompare liftEq negb
     GHC.Base.Applicative GHC.Base.Eq_ GHC.Base.Functor GHC.Base.Ord GHC.Base.const
     GHC.Base.fmap GHC.Base.id GHC.Base.op_zeze__ GHC.Base.op_zlztzg__
     GHC.Base.op_zsze__ GHC.Base.pure
*)
