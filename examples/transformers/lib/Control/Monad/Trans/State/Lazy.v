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
Require Import Data.Functor.Identity.
Require Data.Tuple.
Require GHC.Base.
Import GHC.Base.Notations.

(* Converted type declarations: *)

Inductive StateT s m a : Type
  := Mk_StateT : (s -> m (a * s)%type) -> StateT s m a.

Definition State s :=
  (StateT s Identity)%type.

Arguments Mk_StateT {_} {_} {_} _.

Definition runStateT {s} {m} {a} (arg_0__ : StateT s m a) :=
  let 'Mk_StateT runStateT := arg_0__ in
  runStateT.
(* Converted value declarations: *)

Local Definition Functor__StateT_fmap {inst_m} {inst_s} `{(GHC.Base.Functor
   inst_m)}
   : forall {a} {b},
     (a -> b) -> (StateT inst_s inst_m) a -> (StateT inst_s inst_m) b :=
  fun {a} {b} =>
    fun f m =>
      Mk_StateT (fun s =>
                   GHC.Base.fmap (fun arg_0__ => let 'pair a s' := arg_0__ in pair (f a) s')
                   (runStateT m s)).

Local Definition Functor__StateT_op_zlzd__ {inst_m} {inst_s} `{(GHC.Base.Functor
   inst_m)}
   : forall {a} {b}, a -> (StateT inst_s inst_m) b -> (StateT inst_s inst_m) a :=
  fun {a} {b} => fun x => Functor__StateT_fmap (GHC.Base.const x).

Program Instance Functor__StateT {m} {s} `{(GHC.Base.Functor m)}
   : GHC.Base.Functor (StateT s m) :=
  fun _ k =>
    k {| GHC.Base.op_zlzd____ := fun {a} {b} => Functor__StateT_op_zlzd__ ;
         GHC.Base.fmap__ := fun {a} {b} => Functor__StateT_fmap |}.

Local Definition Applicative__StateT_op_zlztzg__ {inst_m} {inst_s}
  `{GHC.Base.Functor inst_m} `{GHC.Base.Monad inst_m}
   : forall {a} {b},
     (StateT inst_s inst_m) (a -> b) ->
     (StateT inst_s inst_m) a -> (StateT inst_s inst_m) b :=
  fun {a} {b} =>
    fun arg_0__ arg_1__ =>
      match arg_0__, arg_1__ with
      | Mk_StateT mf, Mk_StateT mx =>
          Mk_StateT (fun s =>
                       let cont_2__ arg_3__ :=
                         let 'pair f s' := arg_3__ in
                         let cont_4__ arg_5__ :=
                           let 'pair x s'' := arg_5__ in
                           GHC.Base.return_ (pair (f x) s'') in
                         mx s' GHC.Base.>>= cont_4__ in
                       mf s GHC.Base.>>= cont_2__)
      end.

Local Definition Applicative__StateT_pure {inst_m} {inst_s} `{GHC.Base.Functor
  inst_m} `{GHC.Base.Monad inst_m}
   : forall {a}, a -> (StateT inst_s inst_m) a :=
  fun {a} => fun a => Mk_StateT (fun s => GHC.Base.return_ (pair a s)).

Definition Applicative__StateT_op_ztzg__ {inst_m} {inst_s} `{_
   : GHC.Base.Functor inst_m} `{_ : GHC.Base.Monad inst_m}
   : forall {a} {b},
     StateT inst_s inst_m a -> StateT inst_s inst_m b -> StateT inst_s inst_m b :=
  fun {a} {b} =>
    fun m k =>
      Applicative__StateT_op_zlztzg__ (Applicative__StateT_op_zlztzg__
                                       (Applicative__StateT_pure (fun x y => x)) k) m.

Program Instance Applicative__StateT {m} {s} `{GHC.Base.Functor m}
  `{GHC.Base.Monad m}
   : GHC.Base.Applicative (StateT s m) :=
  fun _ k =>
    k {| GHC.Base.op_ztzg____ := fun {a} {b} => Applicative__StateT_op_ztzg__ ;
         GHC.Base.op_zlztzg____ := fun {a} {b} => Applicative__StateT_op_zlztzg__ ;
         GHC.Base.pure__ := fun {a} => Applicative__StateT_pure |}.

(* Translating `instance Alternative__StateT' failed: OOPS! Cannot find
   information for class Qualified "GHC.Base" "Alternative" unsupported *)

Local Definition Monad__StateT_op_zgzg__ {inst_m} {inst_s} `{(GHC.Base.Monad
   inst_m)}
   : forall {a} {b},
     (StateT inst_s inst_m) a ->
     (StateT inst_s inst_m) b -> (StateT inst_s inst_m) b :=
  fun {a} {b} => _GHC.Base.*>_.

Local Definition Monad__StateT_op_zgzgze__ {inst_m} {inst_s} `{(GHC.Base.Monad
   inst_m)}
   : forall {a} {b},
     (StateT inst_s inst_m) a ->
     (a -> (StateT inst_s inst_m) b) -> (StateT inst_s inst_m) b :=
  fun {a} {b} =>
    fun m k =>
      Mk_StateT (fun s =>
                   let cont_0__ arg_1__ := let 'pair a s' := arg_1__ in runStateT (k a) s' in
                   runStateT m s GHC.Base.>>= cont_0__).

Local Definition Monad__StateT_return_ {inst_m} {inst_s} `{(GHC.Base.Monad
   inst_m)}
   : forall {a}, a -> (StateT inst_s inst_m) a :=
  fun {a} => GHC.Base.pure.

Program Instance Monad__StateT {m} {s} `{(GHC.Base.Monad m)}
   : GHC.Base.Monad (StateT s m) :=
  fun _ k =>
    k {| GHC.Base.op_zgzg____ := fun {a} {b} => Monad__StateT_op_zgzg__ ;
         GHC.Base.op_zgzgze____ := fun {a} {b} => Monad__StateT_op_zgzgze__ ;
         GHC.Base.return___ := fun {a} => Monad__StateT_return_ |}.

(* Translating `instance MonadFail__StateT' failed: OOPS! Cannot find
   information for class Qualified "Control.Monad.Fail" "MonadFail" unsupported *)

(* Translating `instance MonadPlus__StateT' failed: OOPS! Cannot find
   information for class Qualified "GHC.Base" "MonadPlus" unsupported *)

(* Translating `instance MonadFix__StateT' failed: OOPS! Cannot find information
   for class Qualified "Control.Monad.Fix" "MonadFix" unsupported *)

Local Definition MonadTrans__StateT_lift {inst_s}
   : forall {m} {a} `{GHC.Base.Monad m}, m a -> (StateT inst_s) m a :=
  fun {m} {a} `{GHC.Base.Monad m} =>
    fun m =>
      Mk_StateT (fun s => m GHC.Base.>>= (fun a => GHC.Base.return_ (pair a s))).

Program Instance MonadTrans__StateT {s}
   : Control.Monad.Trans.Class.MonadTrans (StateT s) :=
  fun _ k =>
    k {| Control.Monad.Trans.Class.lift__ := fun {m} {a} `{GHC.Base.Monad m} =>
           MonadTrans__StateT_lift |}.

(* Translating `instance MonadIO__StateT' failed: OOPS! Cannot find information
   for class Qualified "Control.Monad.IO.Class" "MonadIO" unsupported *)

Definition evalStateT {m} {s} {a} `{(GHC.Base.Monad m)}
   : StateT s m a -> s -> m a :=
  fun m s =>
    let cont_0__ arg_1__ := let 'pair a _ := arg_1__ in GHC.Base.return_ a in
    runStateT m s GHC.Base.>>= cont_0__.

Definition execStateT {m} {s} {a} `{(GHC.Base.Monad m)}
   : StateT s m a -> s -> m s :=
  fun m s =>
    let cont_0__ arg_1__ := let 'pair _ s' := arg_1__ in GHC.Base.return_ s' in
    runStateT m s GHC.Base.>>= cont_0__.

Definition liftCallCC {m} {a} {s} {b}
   : Control.Monad.Signatures.CallCC m (a * s)%type (b * s)%type ->
     Control.Monad.Signatures.CallCC (StateT s m) a b :=
  fun callCC f =>
    Mk_StateT (fun s =>
                 callCC (fun c =>
                           runStateT (f (fun a => Mk_StateT (fun arg_0__ => c (pair a s)))) s)).

Definition liftCallCC' {m} {a} {s} {b}
   : Control.Monad.Signatures.CallCC m (a * s)%type (b * s)%type ->
     Control.Monad.Signatures.CallCC (StateT s m) a b :=
  fun callCC f =>
    Mk_StateT (fun s =>
                 callCC (fun c =>
                           runStateT (f (fun a => Mk_StateT (fun s' => c (pair a s')))) s)).

Definition liftListen {m} {w} {a} {s} `{(GHC.Base.Monad m)}
   : Control.Monad.Signatures.Listen w m (a * s)%type ->
     Control.Monad.Signatures.Listen w (StateT s m) a :=
  fun listen m =>
    Mk_StateT (fun s =>
                 let cont_0__ arg_1__ :=
                   let 'pair (pair a s') w := arg_1__ in
                   GHC.Base.return_ (pair (pair a w) s') in
                 listen (runStateT m s) GHC.Base.>>= cont_0__).

Definition liftPass {m} {w} {a} {s} `{(GHC.Base.Monad m)}
   : Control.Monad.Signatures.Pass w m (a * s)%type ->
     Control.Monad.Signatures.Pass w (StateT s m) a :=
  fun pass m =>
    Mk_StateT (fun s =>
                 pass (let cont_0__ arg_1__ :=
                         let 'pair (pair a f) s' := arg_1__ in
                         GHC.Base.return_ (pair (pair a s') f) in
                       runStateT m s GHC.Base.>>= cont_0__)).

Definition mapStateT {m} {a} {s} {n} {b}
   : (m (a * s)%type -> n (b * s)%type) -> StateT s m a -> StateT s n b :=
  fun f m => Mk_StateT (f GHC.Base.∘ runStateT m).

Definition mapState {a} {s} {b}
   : ((a * s)%type -> (b * s)%type) -> State s a -> State s b :=
  fun f => mapStateT (Mk_Identity GHC.Base.∘ (f GHC.Base.∘ runIdentity)).

Definition runState {s} {a} : State s a -> s -> (a * s)%type :=
  fun m => runIdentity GHC.Base.∘ runStateT m.

Definition execState {s} {a} : State s a -> s -> s :=
  fun m s => Data.Tuple.snd (runState m s).

Definition evalState {s} {a} : State s a -> s -> a :=
  fun m s => Data.Tuple.fst (runState m s).

Definition state {m} {s} {a} `{(GHC.Base.Monad m)}
   : (s -> (a * s)%type) -> StateT s m a :=
  fun f => Mk_StateT (GHC.Base.return_ GHC.Base.∘ f).

Definition put {m} {s} `{(GHC.Base.Monad m)} : s -> StateT s m unit :=
  fun s => state (fun arg_0__ => pair tt s).

Definition modify {m} {s} `{(GHC.Base.Monad m)} : (s -> s) -> StateT s m unit :=
  fun f => state (fun s => pair tt (f s)).

Definition gets {m} {s} {a} `{(GHC.Base.Monad m)} : (s -> a) -> StateT s m a :=
  fun f => state (fun s => pair (f s) s).

Definition get {m} {s} `{(GHC.Base.Monad m)} : StateT s m s :=
  state (fun s => pair s s).

Definition modify' {m} {s} `{(GHC.Base.Monad m)}
   : (s -> s) -> StateT s m unit :=
  fun f => get GHC.Base.>>= (fun s => put (f s)).

Definition withStateT {s} {m} {a} : (s -> s) -> StateT s m a -> StateT s m a :=
  fun f m => Mk_StateT (runStateT m GHC.Base.∘ f).

Definition withState {s} {a} : (s -> s) -> State s a -> State s a :=
  withStateT.

(* Unbound variables:
     Identity Mk_Identity op_zt__ pair runIdentity tt unit
     Control.Monad.Signatures.CallCC Control.Monad.Signatures.Listen
     Control.Monad.Signatures.Pass Control.Monad.Trans.Class.MonadTrans
     Data.Tuple.fst Data.Tuple.snd GHC.Base.Applicative GHC.Base.Functor
     GHC.Base.Monad GHC.Base.const GHC.Base.fmap GHC.Base.op_z2218U__
     GHC.Base.op_zgzgze__ GHC.Base.op_ztzg__ GHC.Base.pure GHC.Base.return_
*)
