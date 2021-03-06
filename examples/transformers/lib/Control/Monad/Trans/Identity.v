(* Default settings (from HsToCoq.Coq.Preamble) *)

Generalizable All Variables.

Unset Implicit Arguments.
Set Maximal Implicit Insertion.
Unset Strict Implicit.
Unset Printing Implicit Defensive.

Require Coq.Program.Tactics.
Require Coq.Program.Wf.

(* Converted imports: *)

Require Control.Monad.Signatures.
Require Control.Monad.Trans.Class.
Require Coq.Program.Basics.
Require Data.Foldable.
Require Data.Functor.
Require Import Data.Functor.Classes.
Require Import Data.Monoid.
Require Data.Traversable.
Require GHC.Base.
Require GHC.Num.
Import Data.Functor.Notations.
Import GHC.Base.Notations.
Import GHC.Num.Notations.

(* Converted type declarations: *)

Inductive IdentityT (f : Type -> Type) a : Type
  := Mk_IdentityT : f a -> IdentityT f a.

Arguments Mk_IdentityT {_} {_} _.

Definition runIdentityT {f : Type -> Type} {a} (arg_0__ : IdentityT f a) :=
  let 'Mk_IdentityT runIdentityT := arg_0__ in
  runIdentityT.
(* Converted value declarations: *)

Local Definition Eq1__IdentityT_liftEq {inst_f} `{(Eq1 inst_f)}
   : forall {a} {b},
     (a -> b -> bool) -> (IdentityT inst_f) a -> (IdentityT inst_f) b -> bool :=
  fun {a} {b} =>
    fun arg_0__ arg_1__ arg_2__ =>
      match arg_0__, arg_1__, arg_2__ with
      | eq, Mk_IdentityT x, Mk_IdentityT y => liftEq eq x y
      end.

Program Instance Eq1__IdentityT {f} `{(Eq1 f)} : Eq1 (IdentityT f) :=
  fun _ k => k {| liftEq__ := fun {a} {b} => Eq1__IdentityT_liftEq |}.

Local Definition Ord1__IdentityT_liftCompare {inst_f} `{(Ord1 inst_f)}
   : forall {a} {b},
     (a -> b -> comparison) ->
     (IdentityT inst_f) a -> (IdentityT inst_f) b -> comparison :=
  fun {a} {b} =>
    fun arg_0__ arg_1__ arg_2__ =>
      match arg_0__, arg_1__, arg_2__ with
      | comp, Mk_IdentityT x, Mk_IdentityT y => liftCompare comp x y
      end.

Program Instance Ord1__IdentityT {f} `{(Ord1 f)} : Ord1 (IdentityT f) :=
  fun _ k => k {| liftCompare__ := fun {a} {b} => Ord1__IdentityT_liftCompare |}.

(* Translating `instance Read1__IdentityT' failed: OOPS! Cannot find information
   for class Qualified "Data.Functor.Classes" "Read1" unsupported *)

(* Translating `instance Show1__IdentityT' failed: OOPS! Cannot find information
   for class Qualified "Data.Functor.Classes" "Show1" unsupported *)

Local Definition Eq___IdentityT_op_zeze__ {inst_f} {inst_a} `{Eq1 inst_f}
  `{GHC.Base.Eq_ inst_a}
   : (IdentityT inst_f inst_a) -> (IdentityT inst_f inst_a) -> bool :=
  eq1.

Local Definition Eq___IdentityT_op_zsze__ {inst_f} {inst_a} `{Eq1 inst_f}
  `{GHC.Base.Eq_ inst_a}
   : (IdentityT inst_f inst_a) -> (IdentityT inst_f inst_a) -> bool :=
  fun x y => negb (Eq___IdentityT_op_zeze__ x y).

Program Instance Eq___IdentityT {f} {a} `{Eq1 f} `{GHC.Base.Eq_ a}
   : GHC.Base.Eq_ (IdentityT f a) :=
  fun _ k =>
    k {| GHC.Base.op_zeze____ := Eq___IdentityT_op_zeze__ ;
         GHC.Base.op_zsze____ := Eq___IdentityT_op_zsze__ |}.

Local Definition Ord__IdentityT_compare {inst_f} {inst_a} `{Ord1 inst_f}
  `{GHC.Base.Ord inst_a}
   : (IdentityT inst_f inst_a) -> (IdentityT inst_f inst_a) -> comparison :=
  compare1.

Local Definition Ord__IdentityT_op_zg__ {inst_f} {inst_a} `{Ord1 inst_f}
  `{GHC.Base.Ord inst_a}
   : (IdentityT inst_f inst_a) -> (IdentityT inst_f inst_a) -> bool :=
  fun x y => Ord__IdentityT_compare x y GHC.Base.== Gt.

Local Definition Ord__IdentityT_op_zgze__ {inst_f} {inst_a} `{Ord1 inst_f}
  `{GHC.Base.Ord inst_a}
   : (IdentityT inst_f inst_a) -> (IdentityT inst_f inst_a) -> bool :=
  fun x y => Ord__IdentityT_compare x y GHC.Base./= Lt.

Local Definition Ord__IdentityT_op_zl__ {inst_f} {inst_a} `{Ord1 inst_f}
  `{GHC.Base.Ord inst_a}
   : (IdentityT inst_f inst_a) -> (IdentityT inst_f inst_a) -> bool :=
  fun x y => Ord__IdentityT_compare x y GHC.Base.== Lt.

Local Definition Ord__IdentityT_op_zlze__ {inst_f} {inst_a} `{Ord1 inst_f}
  `{GHC.Base.Ord inst_a}
   : (IdentityT inst_f inst_a) -> (IdentityT inst_f inst_a) -> bool :=
  fun x y => Ord__IdentityT_compare x y GHC.Base./= Gt.

Local Definition Ord__IdentityT_max {inst_f} {inst_a} `{Ord1 inst_f}
  `{GHC.Base.Ord inst_a}
   : (IdentityT inst_f inst_a) ->
     (IdentityT inst_f inst_a) -> (IdentityT inst_f inst_a) :=
  fun x y => if Ord__IdentityT_op_zlze__ x y : bool then y else x.

Local Definition Ord__IdentityT_min {inst_f} {inst_a} `{Ord1 inst_f}
  `{GHC.Base.Ord inst_a}
   : (IdentityT inst_f inst_a) ->
     (IdentityT inst_f inst_a) -> (IdentityT inst_f inst_a) :=
  fun x y => if Ord__IdentityT_op_zlze__ x y : bool then x else y.

Program Instance Ord__IdentityT {f} {a} `{Ord1 f} `{GHC.Base.Ord a}
   : GHC.Base.Ord (IdentityT f a) :=
  fun _ k =>
    k {| GHC.Base.op_zl____ := Ord__IdentityT_op_zl__ ;
         GHC.Base.op_zlze____ := Ord__IdentityT_op_zlze__ ;
         GHC.Base.op_zg____ := Ord__IdentityT_op_zg__ ;
         GHC.Base.op_zgze____ := Ord__IdentityT_op_zgze__ ;
         GHC.Base.compare__ := Ord__IdentityT_compare ;
         GHC.Base.max__ := Ord__IdentityT_max ;
         GHC.Base.min__ := Ord__IdentityT_min |}.

(* Translating `instance Read__IdentityT' failed: OOPS! Cannot find information
   for class Qualified "GHC.Read" "Read" unsupported *)

(* Translating `instance Show__IdentityT' failed: OOPS! Cannot find information
   for class Qualified "GHC.Show" "Show" unsupported *)

Local Definition Foldable__IdentityT_foldMap {inst_f} `{(Data.Foldable.Foldable
   inst_f)}
   : forall {m} {a},
     forall `{GHC.Base.Monoid m}, (a -> m) -> (IdentityT inst_f) a -> m :=
  fun {m} {a} `{GHC.Base.Monoid m} =>
    fun arg_0__ arg_1__ =>
      match arg_0__, arg_1__ with
      | f, Mk_IdentityT a => Data.Foldable.foldMap f a
      end.

Local Definition Foldable__IdentityT_foldl {inst_f} `{(Data.Foldable.Foldable
   inst_f)}
   : forall {b} {a}, (b -> a -> b) -> b -> (IdentityT inst_f) a -> b :=
  fun {b} {a} =>
    fun arg_19__ arg_20__ arg_21__ =>
      match arg_19__, arg_20__, arg_21__ with
      | f, z, t =>
          appEndo (getDual (Foldable__IdentityT_foldMap (Coq.Program.Basics.compose
                                                         Mk_Dual (Coq.Program.Basics.compose Mk_Endo (GHC.Base.flip f)))
                            t)) z
      end.

Local Definition Foldable__IdentityT_foldr' {inst_f} `{(Data.Foldable.Foldable
   inst_f)}
   : forall {a} {b}, (a -> b -> b) -> b -> (IdentityT inst_f) a -> b :=
  fun {a} {b} =>
    fun arg_9__ arg_10__ arg_11__ =>
      match arg_9__, arg_10__, arg_11__ with
      | f, z0, xs =>
          let f' :=
            fun arg_12__ arg_13__ arg_14__ =>
              match arg_12__, arg_13__, arg_14__ with
              | k, x, z => k GHC.Base.$! f x z
              end in
          Foldable__IdentityT_foldl f' GHC.Base.id xs z0
      end.

Local Definition Foldable__IdentityT_foldr {inst_f} `{(Data.Foldable.Foldable
   inst_f)}
   : forall {a} {b}, (a -> b -> b) -> b -> (IdentityT inst_f) a -> b :=
  fun {a} {b} =>
    fun arg_4__ arg_5__ arg_6__ =>
      match arg_4__, arg_5__, arg_6__ with
      | f, z, t =>
          appEndo (Foldable__IdentityT_foldMap (Data.Foldable.hash_compose Mk_Endo f) t) z
      end.

Local Definition Foldable__IdentityT_foldl' {inst_f} `{(Data.Foldable.Foldable
   inst_f)}
   : forall {b} {a}, (b -> a -> b) -> b -> (IdentityT inst_f) a -> b :=
  fun {b} {a} =>
    fun arg_24__ arg_25__ arg_26__ =>
      match arg_24__, arg_25__, arg_26__ with
      | f, z0, xs =>
          let f' :=
            fun arg_27__ arg_28__ arg_29__ =>
              match arg_27__, arg_28__, arg_29__ with
              | x, k, z => k GHC.Base.$! f z x
              end in
          Foldable__IdentityT_foldr f' GHC.Base.id xs z0
      end.

Local Definition Foldable__IdentityT_length {inst_f} `{(Data.Foldable.Foldable
   inst_f)}
   : forall {a}, (IdentityT inst_f) a -> GHC.Num.Int :=
  fun {a} =>
    Foldable__IdentityT_foldl' (fun arg_64__ arg_65__ =>
                                  match arg_64__, arg_65__ with
                                  | c, _ => c GHC.Num.+ #1
                                  end) #0.

Local Definition Foldable__IdentityT_null {inst_f} `{(Data.Foldable.Foldable
   inst_f)}
   : forall {a}, (IdentityT inst_f) a -> bool :=
  fun {a} => Foldable__IdentityT_foldr (fun arg_61__ arg_62__ => false) true.

Local Definition Foldable__IdentityT_toList {inst_f} `{(Data.Foldable.Foldable
   inst_f)}
   : forall {a}, (IdentityT inst_f) a -> list a :=
  fun {a} =>
    fun arg_54__ =>
      let 't := arg_54__ in
      GHC.Base.build (fun _ arg_55__ arg_56__ =>
                        match arg_55__, arg_56__ with
                        | c, n => Foldable__IdentityT_foldr c n t
                        end).

Local Definition Foldable__IdentityT_product {inst_f} `{(Data.Foldable.Foldable
   inst_f)}
   : forall {a}, forall `{GHC.Num.Num a}, (IdentityT inst_f) a -> a :=
  fun {a} `{GHC.Num.Num a} =>
    Data.Foldable.hash_compose getProduct (Foldable__IdentityT_foldMap Mk_Product).

Local Definition Foldable__IdentityT_sum {inst_f} `{(Data.Foldable.Foldable
   inst_f)}
   : forall {a}, forall `{GHC.Num.Num a}, (IdentityT inst_f) a -> a :=
  fun {a} `{GHC.Num.Num a} =>
    Data.Foldable.hash_compose getSum (Foldable__IdentityT_foldMap Mk_Sum).

Local Definition Foldable__IdentityT_fold {inst_f} `{(Data.Foldable.Foldable
   inst_f)}
   : forall {m}, forall `{GHC.Base.Monoid m}, (IdentityT inst_f) m -> m :=
  fun {m} `{GHC.Base.Monoid m} => Foldable__IdentityT_foldMap GHC.Base.id.

Local Definition Foldable__IdentityT_elem {inst_f} `{(Data.Foldable.Foldable
   inst_f)}
   : forall {a}, forall `{GHC.Base.Eq_ a}, a -> (IdentityT inst_f) a -> bool :=
  fun {a} `{GHC.Base.Eq_ a} =>
    Coq.Program.Basics.compose (fun arg_69__ =>
                                  let 'p := arg_69__ in
                                  Coq.Program.Basics.compose getAny (Foldable__IdentityT_foldMap
                                                              (Coq.Program.Basics.compose Mk_Any p))) _GHC.Base.==_.

Program Instance Foldable__IdentityT {f} `{(Data.Foldable.Foldable f)}
   : Data.Foldable.Foldable (IdentityT f) :=
  fun _ k =>
    k {| Data.Foldable.elem__ := fun {a} `{GHC.Base.Eq_ a} =>
           Foldable__IdentityT_elem ;
         Data.Foldable.fold__ := fun {m} `{GHC.Base.Monoid m} =>
           Foldable__IdentityT_fold ;
         Data.Foldable.foldMap__ := fun {m} {a} `{GHC.Base.Monoid m} =>
           Foldable__IdentityT_foldMap ;
         Data.Foldable.foldl__ := fun {b} {a} => Foldable__IdentityT_foldl ;
         Data.Foldable.foldl'__ := fun {b} {a} => Foldable__IdentityT_foldl' ;
         Data.Foldable.foldr__ := fun {a} {b} => Foldable__IdentityT_foldr ;
         Data.Foldable.foldr'__ := fun {a} {b} => Foldable__IdentityT_foldr' ;
         Data.Foldable.length__ := fun {a} => Foldable__IdentityT_length ;
         Data.Foldable.null__ := fun {a} => Foldable__IdentityT_null ;
         Data.Foldable.product__ := fun {a} `{GHC.Num.Num a} =>
           Foldable__IdentityT_product ;
         Data.Foldable.sum__ := fun {a} `{GHC.Num.Num a} => Foldable__IdentityT_sum ;
         Data.Foldable.toList__ := fun {a} => Foldable__IdentityT_toList |}.

Local Definition Traversable__IdentityT_traverse {inst_f}
  `{(Data.Traversable.Traversable inst_f)}
   : forall {f} {a} {b},
     forall `{GHC.Base.Applicative f},
     (a -> f b) -> (IdentityT inst_f) a -> f ((IdentityT inst_f) b) :=
  fun {f} {a} {b} `{GHC.Base.Applicative f} =>
    fun arg_0__ arg_1__ =>
      match arg_0__, arg_1__ with
      | f, Mk_IdentityT a =>
          Mk_IdentityT Data.Functor.<$> Data.Traversable.traverse f a
      end.

Local Definition Traversable__IdentityT_sequenceA {inst_f}
  `{(Data.Traversable.Traversable inst_f)}
   : forall {f} {a},
     forall `{GHC.Base.Applicative f},
     (IdentityT inst_f) (f a) -> f ((IdentityT inst_f) a) :=
  fun {f} {a} `{GHC.Base.Applicative f} =>
    Traversable__IdentityT_traverse GHC.Base.id.

Local Definition Traversable__IdentityT_sequence {inst_f}
  `{(Data.Traversable.Traversable inst_f)}
   : forall {m} {a},
     forall `{GHC.Base.Monad m},
     (IdentityT inst_f) (m a) -> m ((IdentityT inst_f) a) :=
  fun {m} {a} `{GHC.Base.Monad m} => Traversable__IdentityT_sequenceA.

Local Definition Traversable__IdentityT_mapM {inst_f}
  `{(Data.Traversable.Traversable inst_f)}
   : forall {m} {a} {b},
     forall `{GHC.Base.Monad m},
     (a -> m b) -> (IdentityT inst_f) a -> m ((IdentityT inst_f) b) :=
  fun {m} {a} {b} `{GHC.Base.Monad m} => Traversable__IdentityT_traverse.

Local Definition Applicative__IdentityT_pure {inst_m} `{(GHC.Base.Applicative
   inst_m)}
   : forall {a}, a -> (IdentityT inst_m) a :=
  fun {a} => fun x => Mk_IdentityT (GHC.Base.pure x).

(* Translating `instance Alternative__IdentityT' failed: OOPS! Cannot find
   information for class Qualified "GHC.Base" "Alternative" unsupported *)

Local Definition Monad__IdentityT_op_zgzgze__ {inst_m} `{(GHC.Base.Monad
   inst_m)}
   : forall {a} {b},
     (IdentityT inst_m) a -> (a -> (IdentityT inst_m) b) -> (IdentityT inst_m) b :=
  fun {a} {b} =>
    fun m k =>
      Mk_IdentityT ((runIdentityT GHC.Base.∘ k) GHC.Base.=<< runIdentityT m).

(* Translating `instance MonadFail__IdentityT' failed: OOPS! Cannot find
   information for class Qualified "Control.Monad.Fail" "MonadFail" unsupported *)

(* Translating `instance MonadPlus__IdentityT' failed: OOPS! Cannot find
   information for class Qualified "GHC.Base" "MonadPlus" unsupported *)

(* Translating `instance MonadFix__IdentityT' failed: OOPS! Cannot find
   information for class Qualified "Control.Monad.Fix" "MonadFix" unsupported *)

(* Translating `instance MonadIO__IdentityT' failed: OOPS! Cannot find
   information for class Qualified "Control.Monad.IO.Class" "MonadIO"
   unsupported *)

(* Translating `instance MonadZip__IdentityT' failed: OOPS! Cannot find
   information for class Qualified "Control.Monad.Zip" "MonadZip" unsupported *)

Local Definition MonadTrans__IdentityT_lift
   : forall {m} {a} `{GHC.Base.Monad m}, m a -> IdentityT m a :=
  fun {m} {a} `{GHC.Base.Monad m} => Mk_IdentityT.

Program Instance MonadTrans__IdentityT
   : Control.Monad.Trans.Class.MonadTrans IdentityT :=
  fun _ k =>
    k {| Control.Monad.Trans.Class.lift__ := fun {m} {a} `{GHC.Base.Monad m} =>
           MonadTrans__IdentityT_lift |}.

Definition lift2IdentityT {m} {a} {n} {b} {p} {c}
   : (m a -> n b -> p c) -> IdentityT m a -> IdentityT n b -> IdentityT p c :=
  fun f a b => Mk_IdentityT (f (runIdentityT a) (runIdentityT b)).

Local Definition Applicative__IdentityT_op_zlztzg__ {inst_m}
  `{(GHC.Base.Applicative inst_m)}
   : forall {a} {b},
     (IdentityT inst_m) (a -> b) -> (IdentityT inst_m) a -> (IdentityT inst_m) b :=
  fun {a} {b} => lift2IdentityT _GHC.Base.<*>_.

Definition liftCallCC {m} {a} {b}
   : Control.Monad.Signatures.CallCC m a b ->
     Control.Monad.Signatures.CallCC (IdentityT m) a b :=
  fun callCC f =>
    Mk_IdentityT (callCC (fun c => runIdentityT (f (Mk_IdentityT GHC.Base.∘ c)))).

Definition mapIdentityT {m} {a} {n} {b}
   : (m a -> n b) -> IdentityT m a -> IdentityT n b :=
  fun f => Mk_IdentityT GHC.Base.∘ (f GHC.Base.∘ runIdentityT).

Local Definition Functor__IdentityT_fmap {inst_m} `{(GHC.Base.Functor inst_m)}
   : forall {a} {b}, (a -> b) -> (IdentityT inst_m) a -> (IdentityT inst_m) b :=
  fun {a} {b} => fun f => mapIdentityT (GHC.Base.fmap f).

Local Definition Functor__IdentityT_op_zlzd__ {inst_m} `{(GHC.Base.Functor
   inst_m)}
   : forall {a} {b}, a -> (IdentityT inst_m) b -> (IdentityT inst_m) a :=
  fun {a} {b} => fun x => Functor__IdentityT_fmap (GHC.Base.const x).

Program Instance Functor__IdentityT {m} `{(GHC.Base.Functor m)}
   : GHC.Base.Functor (IdentityT m) :=
  fun _ k =>
    k {| GHC.Base.op_zlzd____ := fun {a} {b} => Functor__IdentityT_op_zlzd__ ;
         GHC.Base.fmap__ := fun {a} {b} => Functor__IdentityT_fmap |}.

Local Definition Applicative__IdentityT_op_ztzg__ {inst_m}
  `{(GHC.Base.Applicative inst_m)}
   : forall {a} {b},
     (IdentityT inst_m) a -> (IdentityT inst_m) b -> (IdentityT inst_m) b :=
  fun {a} {b} =>
    fun x y =>
      Applicative__IdentityT_op_zlztzg__ (GHC.Base.fmap (GHC.Base.const GHC.Base.id)
                                                        x) y.

Program Instance Applicative__IdentityT {m} `{(GHC.Base.Applicative m)}
   : GHC.Base.Applicative (IdentityT m) :=
  fun _ k =>
    k {| GHC.Base.op_ztzg____ := fun {a} {b} => Applicative__IdentityT_op_ztzg__ ;
         GHC.Base.op_zlztzg____ := fun {a} {b} => Applicative__IdentityT_op_zlztzg__ ;
         GHC.Base.pure__ := fun {a} => Applicative__IdentityT_pure |}.

Local Definition Monad__IdentityT_op_zgzg__ {inst_m} `{(GHC.Base.Monad inst_m)}
   : forall {a} {b},
     (IdentityT inst_m) a -> (IdentityT inst_m) b -> (IdentityT inst_m) b :=
  fun {a} {b} => _GHC.Base.*>_.

Local Definition Monad__IdentityT_return_ {inst_m} `{(GHC.Base.Monad inst_m)}
   : forall {a}, a -> (IdentityT inst_m) a :=
  fun {a} => GHC.Base.pure.

Program Instance Monad__IdentityT {m} `{(GHC.Base.Monad m)}
   : GHC.Base.Monad (IdentityT m) :=
  fun _ k =>
    k {| GHC.Base.op_zgzg____ := fun {a} {b} => Monad__IdentityT_op_zgzg__ ;
         GHC.Base.op_zgzgze____ := fun {a} {b} => Monad__IdentityT_op_zgzgze__ ;
         GHC.Base.return___ := fun {a} => Monad__IdentityT_return_ |}.

Program Instance Traversable__IdentityT {f} `{(Data.Traversable.Traversable f)}
   : Data.Traversable.Traversable (IdentityT f) :=
  fun _ k =>
    k {| Data.Traversable.mapM__ := fun {m} {a} {b} `{GHC.Base.Monad m} =>
           Traversable__IdentityT_mapM ;
         Data.Traversable.sequence__ := fun {m} {a} `{GHC.Base.Monad m} =>
           Traversable__IdentityT_sequence ;
         Data.Traversable.sequenceA__ := fun {f} {a} `{GHC.Base.Applicative f} =>
           Traversable__IdentityT_sequenceA ;
         Data.Traversable.traverse__ := fun {f} {a} {b} `{GHC.Base.Applicative f} =>
           Traversable__IdentityT_traverse |}.

(* Unbound variables:
     Eq1 Gt Lt Mk_Any Mk_Dual Mk_Endo Mk_Product Mk_Sum Ord1 Type appEndo bool
     compare1 comparison eq1 false getAny getDual getProduct getSum liftCompare
     liftEq list negb true Control.Monad.Signatures.CallCC
     Control.Monad.Trans.Class.MonadTrans Coq.Program.Basics.compose
     Data.Foldable.Foldable Data.Foldable.foldMap Data.Foldable.hash_compose
     Data.Functor.op_zlzdzg__ Data.Traversable.Traversable Data.Traversable.traverse
     GHC.Base.Applicative GHC.Base.Eq_ GHC.Base.Functor GHC.Base.Monad
     GHC.Base.Monoid GHC.Base.Ord GHC.Base.build GHC.Base.const GHC.Base.flip
     GHC.Base.fmap GHC.Base.id GHC.Base.op_z2218U__ GHC.Base.op_zdzn__
     GHC.Base.op_zeze__ GHC.Base.op_zezlzl__ GHC.Base.op_zlztzg__ GHC.Base.op_zsze__
     GHC.Base.op_ztzg__ GHC.Base.pure GHC.Num.Int GHC.Num.Num GHC.Num.fromInteger
     GHC.Num.op_zp__
*)
