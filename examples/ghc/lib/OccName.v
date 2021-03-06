(* Default settings (from HsToCoq.Coq.Preamble) *)

Generalizable All Variables.

Unset Implicit Arguments.
Set Maximal Implicit Insertion.
Unset Strict Implicit.
Unset Printing Implicit Defensive.

Require Coq.Program.Tactics.
Require Coq.Program.Wf.

(* Converted imports: *)

Require Coq.Init.Datatypes.
Require Data.Foldable.
Require FastString.
Require GHC.Base.
Require GHC.Num.
Require Module.
Require UniqFM.
Require UniqSet.
Require Util.
Import GHC.Base.Notations.
Import GHC.Num.Notations.

(* Converted type declarations: *)

Definition TidyOccEnv :=
  (UniqFM.UniqFM GHC.Num.Int)%type.

Inductive OccEnv a : Type := A : (UniqFM.UniqFM a) -> OccEnv a.

Inductive NameSpace : Type
  := VarName : NameSpace
  |  DataName : NameSpace
  |  TvName : NameSpace
  |  TcClsName : NameSpace.

Inductive OccName : Type
  := Mk_OccName : NameSpace -> FastString.FastString -> OccName.

Definition OccSet :=
  (UniqSet.UniqSet OccName)%type.

Record HasOccName__Dict name := HasOccName__Dict_Build {
  occName__ : name -> OccName }.

Definition HasOccName name :=
  forall r, (HasOccName__Dict name -> r) -> r.

Existing Class HasOccName.

Definition occName `{g : HasOccName name} : name -> OccName :=
  g _ (occName__ name).

Arguments A {_} _.

Definition occNameFS (arg_0__ : OccName) :=
  let 'Mk_OccName _ occNameFS := arg_0__ in
  occNameFS.

Definition occNameSpace (arg_1__ : OccName) :=
  let 'Mk_OccName occNameSpace _ := arg_1__ in
  occNameSpace.
(* Midamble *)

(* records field accesses are not fully qualified. *)
Require Import Module.

Instance Uniquable_OccName : Unique.Uniquable OccName := {}.
Admitted.


Definition compare_Namespace : NameSpace -> NameSpace -> comparison :=
  fun x y => match x , y with
          | VarName   , VarName   => Eq
          | VarName   , _         => Lt
          | _         , VarName   => Gt
          | DataName  , DataName  => Eq
          | _         , DataName  => Lt
          | DataName  , _         => Gt
          | TvName    , TvName    => Eq
          | _         , TvName    => Lt
          | TvName    , _         => Gt
          | TcClsName , TcClsName => Eq
          end.

Local Definition NameSpace_op_zg__ : NameSpace -> NameSpace -> bool :=
  fun x y => match compare_Namespace x y with
            | Gt => true
            | _  => false
          end.

Local Definition NameSpace_op_zgze__ : NameSpace -> NameSpace -> bool :=
  fun x y => match compare_Namespace x y with
            | Gt => true
            | Eq => true
            | _  => false
          end.

Local Definition NameSpace_op_zl__ : NameSpace -> NameSpace -> bool :=
  fun x y => match compare_Namespace x y with
            | Lt => true
            | _  => false
          end.
Local Definition NameSpace_op_zlze__ : NameSpace -> NameSpace -> bool :=
  fun x y => match compare_Namespace x y with
            | Lt => true
            | Eq => true
            | _  => false
          end.

(* Axioms for operations that we cannot yet translate *)

Axiom isDataSymOcc : OccName -> bool.
Axiom isSymOcc : OccName -> bool.
Axiom chooseUniqueOcc : NameSpace -> GHC.Base.String -> OccSet -> OccName.
Axiom startsWithUnderscore : OccName -> bool.
Axiom isDerivedOccName : OccName -> bool.
Axiom mkGenS : Module.Module -> OccName -> GHC.Num.Int -> GHC.Num.Int -> OccName.
Axiom mkGenC : Module.Module -> OccName -> GHC.Num.Int -> OccName .
Axiom tidyOccName : TidyOccEnv -> OccName -> (TidyOccEnv * OccName)%type.
Axiom mkSuperDictAuxOcc : GHC.Num.Int -> OccName -> OccName.
Axiom mkSuperDictSelOcc : GHC.Num.Int -> OccName -> OccName.
Axiom mkLocalOcc : Unique.Unique -> OccName -> OccName.

(* Default values *)
Require Import GHC.Err.
Instance Default_NameSpace : Default NameSpace := Build_Default _ VarName.
Instance Default_OccName : Default OccName := Build_Default _ (Mk_OccName default default).

(* Converted value declarations: *)

(* Translating `instance Data__OccName' failed: OOPS! Cannot find information
   for class Qualified "Data.Data" "Data" unsupported *)

Local Definition HasOccName__OccName_occName : OccName -> OccName :=
  GHC.Base.id.

Program Instance HasOccName__OccName : HasOccName OccName :=
  fun _ k => k {| occName__ := HasOccName__OccName_occName |}.

(* Translating `instance NFData__OccName' failed: OOPS! Cannot find information
   for class Qualified "Control.DeepSeq" "NFData" unsupported *)

(* Translating `instance Outputable__OccName' failed: OOPS! Cannot find
   information for class Qualified "Outputable" "Outputable" unsupported *)

(* Translating `instance OutputableBndr__OccName' failed: OOPS! Cannot find
   information for class Qualified "Outputable" "OutputableBndr" unsupported *)

(* Translating `instance Uniquable__OccName' failed: OOPS! Cannot find
   information for class Qualified "Unique" "Uniquable" unsupported *)

(* Translating `instance Outputable__OccEnv' failed: OOPS! Cannot find
   information for class Qualified "Outputable" "Outputable" unsupported *)

(* Translating `instance Binary__NameSpace' failed: OOPS! Cannot find
   information for class Qualified "Binary" "Binary" unsupported *)

(* Translating `instance Binary__OccName' failed: OOPS! Cannot find information
   for class Qualified "Binary" "Binary" unsupported *)

(* Translating `instance Data__OccEnv' failed: OOPS! Cannot find information for
   class Qualified "Data.Data" "Data" unsupported *)

Local Definition Ord__NameSpace_compare
   : NameSpace -> NameSpace -> comparison :=
  compare_Namespace.

Local Definition Ord__NameSpace_op_zg__ :=
  NameSpace_op_zg__.

Local Definition Ord__NameSpace_op_zgze__ :=
  NameSpace_op_zgze__.

Local Definition Ord__NameSpace_op_zl__ :=
  NameSpace_op_zl__.

Local Definition Ord__NameSpace_op_zlze__ :=
  NameSpace_op_zlze__.

Local Definition Ord__NameSpace_min : NameSpace -> NameSpace -> NameSpace :=
  fun x y => if Ord__NameSpace_op_zlze__ x y : bool then x else y.

Local Definition Ord__NameSpace_max : NameSpace -> NameSpace -> NameSpace :=
  fun x y => if Ord__NameSpace_op_zlze__ x y : bool then y else x.

Local Definition Eq___NameSpace_op_zeze__ : NameSpace -> NameSpace -> bool :=
  fun arg_0__ arg_1__ =>
    match arg_0__, arg_1__ with
    | VarName, VarName => true
    | DataName, DataName => true
    | TvName, TvName => true
    | TcClsName, TcClsName => true
    | _, _ => false
    end.

Local Definition Eq___NameSpace_op_zsze__ : NameSpace -> NameSpace -> bool :=
  fun a b => negb (Eq___NameSpace_op_zeze__ a b).

Program Instance Eq___NameSpace : GHC.Base.Eq_ NameSpace :=
  fun _ k =>
    k {| GHC.Base.op_zeze____ := Eq___NameSpace_op_zeze__ ;
         GHC.Base.op_zsze____ := Eq___NameSpace_op_zsze__ |}.

Program Instance Ord__NameSpace : GHC.Base.Ord NameSpace :=
  fun _ k =>
    k {| GHC.Base.op_zl____ := Ord__NameSpace_op_zl__ ;
         GHC.Base.op_zlze____ := Ord__NameSpace_op_zlze__ ;
         GHC.Base.op_zg____ := Ord__NameSpace_op_zg__ ;
         GHC.Base.op_zgze____ := Ord__NameSpace_op_zgze__ ;
         GHC.Base.compare__ := Ord__NameSpace_compare ;
         GHC.Base.max__ := Ord__NameSpace_max ;
         GHC.Base.min__ := Ord__NameSpace_min |}.

Local Definition Eq___OccName_op_zeze__ : OccName -> OccName -> bool :=
  fun arg_0__ arg_1__ =>
    match arg_0__, arg_1__ with
    | Mk_OccName sp1 s1, Mk_OccName sp2 s2 =>
        andb (s1 GHC.Base.== s2) (sp1 GHC.Base.== sp2)
    end.

Local Definition Eq___OccName_op_zsze__ : OccName -> OccName -> bool :=
  fun x y => negb (Eq___OccName_op_zeze__ x y).

Program Instance Eq___OccName : GHC.Base.Eq_ OccName :=
  fun _ k =>
    k {| GHC.Base.op_zeze____ := Eq___OccName_op_zeze__ ;
         GHC.Base.op_zsze____ := Eq___OccName_op_zsze__ |}.

Local Definition Ord__OccName_compare : OccName -> OccName -> comparison :=
  fun arg_0__ arg_1__ =>
    match arg_0__, arg_1__ with
    | Mk_OccName sp1 s1, Mk_OccName sp2 s2 =>
        Util.thenCmp (GHC.Base.compare s1 s2) (GHC.Base.compare sp1 sp2)
    end.

Local Definition Ord__OccName_op_zg__ : OccName -> OccName -> bool :=
  fun x y => Ord__OccName_compare x y GHC.Base.== Gt.

Local Definition Ord__OccName_op_zgze__ : OccName -> OccName -> bool :=
  fun x y => Ord__OccName_compare x y GHC.Base./= Lt.

Local Definition Ord__OccName_op_zl__ : OccName -> OccName -> bool :=
  fun x y => Ord__OccName_compare x y GHC.Base.== Lt.

Local Definition Ord__OccName_op_zlze__ : OccName -> OccName -> bool :=
  fun x y => Ord__OccName_compare x y GHC.Base./= Gt.

Local Definition Ord__OccName_max : OccName -> OccName -> OccName :=
  fun x y => if Ord__OccName_op_zlze__ x y : bool then y else x.

Local Definition Ord__OccName_min : OccName -> OccName -> OccName :=
  fun x y => if Ord__OccName_op_zlze__ x y : bool then x else y.

Program Instance Ord__OccName : GHC.Base.Ord OccName :=
  fun _ k =>
    k {| GHC.Base.op_zl____ := Ord__OccName_op_zl__ ;
         GHC.Base.op_zlze____ := Ord__OccName_op_zlze__ ;
         GHC.Base.op_zg____ := Ord__OccName_op_zg__ ;
         GHC.Base.op_zgze____ := Ord__OccName_op_zgze__ ;
         GHC.Base.compare__ := Ord__OccName_compare ;
         GHC.Base.max__ := Ord__OccName_max ;
         GHC.Base.min__ := Ord__OccName_min |}.

Definition alterOccEnv {elt}
   : (option elt -> option elt) -> OccEnv elt -> OccName -> OccEnv elt :=
  fun arg_0__ arg_1__ arg_2__ =>
    match arg_0__, arg_1__, arg_2__ with
    | fn, A y, k => A (UniqFM.alterUFM fn y k)
    end.

Definition clsName : NameSpace :=
  TcClsName.

Definition dataName : NameSpace :=
  DataName.

Definition delFromOccEnv {a} : OccEnv a -> OccName -> OccEnv a :=
  fun arg_0__ arg_1__ =>
    match arg_0__, arg_1__ with
    | A x, y => A (UniqFM.delFromUFM x y)
    end.

Definition delListFromOccEnv {a} : OccEnv a -> list OccName -> OccEnv a :=
  fun arg_0__ arg_1__ =>
    match arg_0__, arg_1__ with
    | A x, y => A (UniqFM.delListFromUFM x y)
    end.

Definition demoteNameSpace : NameSpace -> option NameSpace :=
  fun arg_0__ =>
    match arg_0__ with
    | VarName => None
    | DataName => None
    | TvName => None
    | TcClsName => Some DataName
    end.

Definition demoteOccName : OccName -> option OccName :=
  fun arg_0__ =>
    let 'Mk_OccName space name := arg_0__ in
    demoteNameSpace space GHC.Base.>>=
    (fun space' => GHC.Base.return_ (Mk_OccName space' name)).

Definition elemOccEnv {a} : OccName -> OccEnv a -> bool :=
  fun arg_0__ arg_1__ =>
    match arg_0__, arg_1__ with
    | x, A y => UniqFM.elemUFM x y
    end.

Definition elemOccSet : OccName -> OccSet -> bool :=
  UniqSet.elementOfUniqSet.

Definition emptyOccEnv {a} : OccEnv a :=
  A UniqFM.emptyUFM.

Definition emptyOccSet : OccSet :=
  UniqSet.emptyUniqSet.

Definition emptyTidyOccEnv : TidyOccEnv :=
  UniqFM.emptyUFM.

Definition extendOccEnv {a} : OccEnv a -> OccName -> a -> OccEnv a :=
  fun arg_0__ arg_1__ arg_2__ =>
    match arg_0__, arg_1__, arg_2__ with
    | A x, y, z => A (UniqFM.addToUFM x y z)
    end.

Definition extendOccEnvList {a}
   : OccEnv a -> list (OccName * a)%type -> OccEnv a :=
  fun arg_0__ arg_1__ =>
    match arg_0__, arg_1__ with
    | A x, l => A (UniqFM.addListToUFM x l)
    end.

Definition extendOccEnv_Acc {a} {b}
   : (a -> b -> b) -> (a -> b) -> OccEnv b -> OccName -> a -> OccEnv b :=
  fun arg_0__ arg_1__ arg_2__ arg_3__ arg_4__ =>
    match arg_0__, arg_1__, arg_2__, arg_3__, arg_4__ with
    | f, g, A x, y, z => A (UniqFM.addToUFM_Acc f g x y z)
    end.

Definition extendOccEnv_C {a}
   : (a -> a -> a) -> OccEnv a -> OccName -> a -> OccEnv a :=
  fun arg_0__ arg_1__ arg_2__ arg_3__ =>
    match arg_0__, arg_1__, arg_2__, arg_3__ with
    | f, A x, y, z => A (UniqFM.addToUFM_C f x y z)
    end.

Definition extendOccSet : OccSet -> OccName -> OccSet :=
  UniqSet.addOneToUniqSet.

Definition extendOccSetList : OccSet -> list OccName -> OccSet :=
  UniqSet.addListToUniqSet.

Definition filterOccEnv {elt} : (elt -> bool) -> OccEnv elt -> OccEnv elt :=
  fun arg_0__ arg_1__ =>
    match arg_0__, arg_1__ with
    | x, A y => A (UniqFM.filterUFM x y)
    end.

Definition filterOccSet : (OccName -> bool) -> OccSet -> OccSet :=
  UniqSet.filterUniqSet.

Definition foldOccEnv {a} {b} : (a -> b -> b) -> b -> OccEnv a -> b :=
  fun arg_0__ arg_1__ arg_2__ =>
    match arg_0__, arg_1__, arg_2__ with
    | a, b, A c => UniqFM.foldUFM a b c
    end.

Definition foldOccSet {b} : (OccName -> b -> b) -> b -> OccSet -> b :=
  UniqSet.foldUniqSet.

Definition initTidyOccEnv : list OccName -> TidyOccEnv :=
  let add :=
    fun arg_0__ arg_1__ =>
      match arg_0__, arg_1__ with
      | env, Mk_OccName _ fs => UniqFM.addToUFM env fs #1
      end in
  Data.Foldable.foldl add UniqFM.emptyUFM.

Definition intersectOccSet : OccSet -> OccSet -> OccSet :=
  UniqSet.intersectUniqSets.

Definition isDataConNameSpace : NameSpace -> bool :=
  fun arg_0__ => match arg_0__ with | DataName => true | _ => false end.

Definition isDataOcc : OccName -> bool :=
  fun arg_0__ =>
    match arg_0__ with
    | Mk_OccName DataName _ => true
    | _ => false
    end.

Definition isEmptyOccSet : OccSet -> bool :=
  UniqSet.isEmptyUniqSet.

Definition intersectsOccSet : OccSet -> OccSet -> bool :=
  fun s1 s2 => negb (isEmptyOccSet (intersectOccSet s1 s2)).

Definition isTcClsNameSpace : NameSpace -> bool :=
  fun arg_0__ => match arg_0__ with | TcClsName => true | _ => false end.

Definition isTcOcc : OccName -> bool :=
  fun arg_0__ =>
    match arg_0__ with
    | Mk_OccName TcClsName _ => true
    | _ => false
    end.

Definition isTvNameSpace : NameSpace -> bool :=
  fun arg_0__ => match arg_0__ with | TvName => true | _ => false end.

Definition isTvOcc : OccName -> bool :=
  fun arg_0__ =>
    match arg_0__ with
    | Mk_OccName TvName _ => true
    | _ => false
    end.

Definition isValNameSpace : NameSpace -> bool :=
  fun arg_0__ =>
    match arg_0__ with
    | DataName => true
    | VarName => true
    | _ => false
    end.

Definition isValOcc : OccName -> bool :=
  fun arg_0__ =>
    match arg_0__ with
    | Mk_OccName VarName _ => true
    | Mk_OccName DataName _ => true
    | _ => false
    end.

Definition isVarNameSpace : NameSpace -> bool :=
  fun arg_0__ =>
    match arg_0__ with
    | TvName => true
    | VarName => true
    | _ => false
    end.

Definition isVarOcc : OccName -> bool :=
  fun arg_0__ =>
    match arg_0__ with
    | Mk_OccName VarName _ => true
    | _ => false
    end.

Definition lookupOccEnv {a} : OccEnv a -> OccName -> option a :=
  fun arg_0__ arg_1__ =>
    match arg_0__, arg_1__ with
    | A x, y => UniqFM.lookupUFM x y
    end.

Definition mapOccEnv {a} {b} : (a -> b) -> OccEnv a -> OccEnv b :=
  fun arg_0__ arg_1__ =>
    match arg_0__, arg_1__ with
    | f, A x => A (UniqFM.mapUFM f x)
    end.

Definition minusOccSet : OccSet -> OccSet -> OccSet :=
  UniqSet.minusUniqSet.

Definition mkDFunOcc : GHC.Base.String -> bool -> OccSet -> OccName :=
  fun info_str is_boot set =>
    let prefix :=
      if is_boot : bool then GHC.Base.hs_string__ "$fx" else
      GHC.Base.hs_string__ "$f" in
    chooseUniqueOcc VarName (Coq.Init.Datatypes.app prefix info_str) set.

Definition mkModPrefix : Module.Module -> GHC.Base.String :=
  fun mod_ =>
    let mn := Module.moduleNameString (Module.moduleName mod_) in
    let pk := Module.unitIdString (Module.moduleUnitId mod_) in
    Coq.Init.Datatypes.app pk (Coq.Init.Datatypes.app (GHC.Base.hs_string__ "_")
                                                      mn).

Definition mkOccEnv {a} : list (OccName * a)%type -> OccEnv a :=
  fun l => A (UniqFM.listToUFM l).

Definition mkOccEnv_C {a}
   : (a -> a -> a) -> list (OccName * a)%type -> OccEnv a :=
  fun comb l => A (UniqFM.addListToUFM_C comb UniqFM.emptyUFM l).

Definition mkOccName : NameSpace -> GHC.Base.String -> OccName :=
  fun occ_sp str => Mk_OccName occ_sp (FastString.mkFastString str).

Definition mk_deriv
   : NameSpace -> GHC.Base.String -> GHC.Base.String -> OccName :=
  fun occ_sp sys_prefix str =>
    mkOccName occ_sp (Coq.Init.Datatypes.app sys_prefix str).

Definition mkDataOcc : GHC.Base.String -> OccName :=
  mkOccName dataName.

Definition mkClsOcc : GHC.Base.String -> OccName :=
  mkOccName clsName.

Definition mkOccNameFS : NameSpace -> FastString.FastString -> OccName :=
  fun occ_sp fs => Mk_OccName occ_sp fs.

Definition mkDataOccFS : FastString.FastString -> OccName :=
  mkOccNameFS dataName.

Definition mkClsOccFS : FastString.FastString -> OccName :=
  mkOccNameFS clsName.

Definition mkOccSet : list OccName -> OccSet :=
  UniqSet.mkUniqSet.

Definition occEnvElts {a} : OccEnv a -> list a :=
  fun arg_0__ => let 'A x := arg_0__ in UniqFM.eltsUFM x.

Definition occNameString : OccName -> GHC.Base.String :=
  fun arg_0__ => let 'Mk_OccName _ s := arg_0__ in FastString.unpackFS s.

Definition mk_simple_deriv
   : NameSpace -> GHC.Base.String -> OccName -> OccName :=
  fun sp px occ => mk_deriv sp px (occNameString occ).

Definition mkClassDataConOcc : OccName -> OccName :=
  mk_simple_deriv dataName (GHC.Base.hs_string__ "C:").

Definition mk_simple_deriv_with
   : NameSpace ->
     GHC.Base.String -> option GHC.Base.String -> OccName -> OccName :=
  fun arg_0__ arg_1__ arg_2__ arg_3__ =>
    match arg_0__, arg_1__, arg_2__, arg_3__ with
    | sp, px, None, occ => mk_deriv sp px (occNameString occ)
    | sp, px, Some with_, occ =>
        mk_deriv sp (Coq.Init.Datatypes.app px (Coq.Init.Datatypes.app with_
                                                                       (GHC.Base.hs_string__ "_"))) (occNameString occ)
    end.

Definition mkPDataDataConOcc : option GHC.Base.String -> OccName -> OccName :=
  mk_simple_deriv_with dataName (GHC.Base.hs_string__ "VPD:").

Definition mkPDatasDataConOcc : option GHC.Base.String -> OccName -> OccName :=
  mk_simple_deriv_with dataName (GHC.Base.hs_string__ "VPDs:").

Definition mkVectDataConOcc : option GHC.Base.String -> OccName -> OccName :=
  mk_simple_deriv_with dataName (GHC.Base.hs_string__ "VD:").

Definition occSetElts : OccSet -> list OccName :=
  UniqSet.uniqSetToList.

Definition otherNameSpace : NameSpace -> NameSpace :=
  fun arg_0__ =>
    match arg_0__ with
    | VarName => DataName
    | DataName => VarName
    | TvName => TcClsName
    | TcClsName => TvName
    end.

Definition nameSpacesRelated : NameSpace -> NameSpace -> bool :=
  fun ns1 ns2 => orb (ns1 GHC.Base.== ns2) (otherNameSpace ns1 GHC.Base.== ns2).

Definition plusOccEnv {a} : OccEnv a -> OccEnv a -> OccEnv a :=
  fun arg_0__ arg_1__ =>
    match arg_0__, arg_1__ with
    | A x, A y => A (UniqFM.plusUFM x y)
    end.

Definition plusOccEnv_C {a}
   : (a -> a -> a) -> OccEnv a -> OccEnv a -> OccEnv a :=
  fun arg_0__ arg_1__ arg_2__ =>
    match arg_0__, arg_1__, arg_2__ with
    | f, A x, A y => A (UniqFM.plusUFM_C f x y)
    end.

Definition setOccNameSpace : NameSpace -> OccName -> OccName :=
  fun arg_0__ arg_1__ =>
    match arg_0__, arg_1__ with
    | sp, Mk_OccName _ occ => Mk_OccName sp occ
    end.

Definition srcDataName : NameSpace :=
  DataName.

Definition tcClsName : NameSpace :=
  TcClsName.

Definition tcName : NameSpace :=
  TcClsName.

Definition mkTcOccFS : FastString.FastString -> OccName :=
  mkOccNameFS tcName.

Definition mkTcOcc : GHC.Base.String -> OccName :=
  mkOccName tcName.

Definition mkPDataTyConOcc : option GHC.Base.String -> OccName -> OccName :=
  mk_simple_deriv_with tcName (GHC.Base.hs_string__ "VP:").

Definition mkPDatasTyConOcc : option GHC.Base.String -> OccName -> OccName :=
  mk_simple_deriv_with tcName (GHC.Base.hs_string__ "VPs:").

Definition mkPReprTyConOcc : option GHC.Base.String -> OccName -> OccName :=
  mk_simple_deriv_with tcName (GHC.Base.hs_string__ "VR:").

Definition mkVectTyConOcc : option GHC.Base.String -> OccName -> OccName :=
  mk_simple_deriv_with tcName (GHC.Base.hs_string__ "V:").

Definition mkNewTyCoOcc : OccName -> OccName :=
  mk_simple_deriv tcName (GHC.Base.hs_string__ "N:").

Definition mkInstTyTcOcc : GHC.Base.String -> OccSet -> OccName :=
  fun str set =>
    chooseUniqueOcc tcName (cons (GHC.Char.hs_char__ "R") (cons (GHC.Char.hs_char__
                                                                 ":") str)) set.

Definition mkInstTyCoOcc : OccName -> OccName :=
  mk_simple_deriv tcName (GHC.Base.hs_string__ "D:").

Definition mkGenRCo : OccName -> OccName :=
  mk_simple_deriv tcName (GHC.Base.hs_string__ "CoRep_").

Definition mkGenR : OccName -> OccName :=
  mk_simple_deriv tcName (GHC.Base.hs_string__ "Rep_").

Definition mkGenD : Module.Module -> OccName -> OccName :=
  fun mod_ =>
    mk_simple_deriv tcName (Coq.Init.Datatypes.app (GHC.Base.hs_string__ "D1_")
                                                   (Coq.Init.Datatypes.app (mkModPrefix mod_) (GHC.Base.hs_string__
                                                                            "_"))).

Definition mkGen1R : OccName -> OccName :=
  mk_simple_deriv tcName (GHC.Base.hs_string__ "Rep1_").

Definition mkEqPredCoOcc : OccName -> OccName :=
  mk_simple_deriv tcName (GHC.Base.hs_string__ "$co").

Definition tvName : NameSpace :=
  TvName.

Definition mkTyVarOccFS : FastString.FastString -> OccName :=
  fun fs => mkOccNameFS tvName fs.

Definition mkTyVarOcc : GHC.Base.String -> OccName :=
  mkOccName tvName.

Definition mkRepEqOcc : OccName -> OccName :=
  mk_simple_deriv tvName (GHC.Base.hs_string__ "$r").

Definition unionManyOccSets : list OccSet -> OccSet :=
  UniqSet.unionManyUniqSets.

Definition unionOccSets : OccSet -> OccSet -> OccSet :=
  UniqSet.unionUniqSets.

Definition unitOccEnv {a} : OccName -> a -> OccEnv a :=
  fun x y => A (UniqFM.unitUFM x y).

Definition unitOccSet : OccName -> OccSet :=
  UniqSet.unitUniqSet.

Definition varName : NameSpace :=
  VarName.

Definition mkVarOccFS : FastString.FastString -> OccName :=
  fun fs => mkOccNameFS varName fs.

Definition mkVarOcc : GHC.Base.String -> OccName :=
  fun s => mkOccName varName s.

Definition mkRecFldSelOcc : GHC.Base.String -> OccName :=
  mk_deriv varName (GHC.Base.hs_string__ "$sel").

Definition mkSpecOcc : OccName -> OccName :=
  mk_simple_deriv varName (GHC.Base.hs_string__ "$s").

Definition mkTag2ConOcc : OccName -> OccName :=
  mk_simple_deriv varName (GHC.Base.hs_string__ "$tag2con_").

Definition mkWorkerOcc : OccName -> OccName :=
  mk_simple_deriv varName (GHC.Base.hs_string__ "$w").

Definition mkPADFunOcc : option GHC.Base.String -> OccName -> OccName :=
  mk_simple_deriv_with varName (GHC.Base.hs_string__ "$pa").

Definition mkVectIsoOcc : option GHC.Base.String -> OccName -> OccName :=
  mk_simple_deriv_with varName (GHC.Base.hs_string__ "$vi").

Definition mkVectOcc : option GHC.Base.String -> OccName -> OccName :=
  mk_simple_deriv_with varName (GHC.Base.hs_string__ "$v").

Definition mkMethodOcc : OccName -> OccName :=
  fun arg_0__ =>
    match arg_0__ with
    | (Mk_OccName VarName _ as occ) => occ
    | occ => mk_simple_deriv varName (GHC.Base.hs_string__ "$m") occ
    end.

Definition mkMaxTagOcc : OccName -> OccName :=
  mk_simple_deriv varName (GHC.Base.hs_string__ "$maxtag_").

Definition mkMatcherOcc : OccName -> OccName :=
  mk_simple_deriv varName (GHC.Base.hs_string__ "$m").

Definition mkIPOcc : OccName -> OccName :=
  mk_simple_deriv varName (GHC.Base.hs_string__ "$i").

Definition mkForeignExportOcc : OccName -> OccName :=
  mk_simple_deriv varName (GHC.Base.hs_string__ "$f").

Definition mkDictOcc : OccName -> OccName :=
  mk_simple_deriv varName (GHC.Base.hs_string__ "$d").

Definition mkDefaultMethodOcc : OccName -> OccName :=
  mk_simple_deriv varName (GHC.Base.hs_string__ "$dm").

Definition mkDataTOcc : OccName -> OccName :=
  mk_simple_deriv varName (GHC.Base.hs_string__ "$t").

Definition mkDataConWrapperOcc : OccName -> OccName :=
  mk_simple_deriv varName (GHC.Base.hs_string__ "$W").

Definition mkDataConWorkerOcc : OccName -> OccName :=
  fun datacon_occ => setOccNameSpace varName datacon_occ.

Definition mkDataCOcc : OccName -> OccName :=
  mk_simple_deriv varName (GHC.Base.hs_string__ "$c").

Definition mkCon2TagOcc : OccName -> OccName :=
  mk_simple_deriv varName (GHC.Base.hs_string__ "$con2tag_").

Definition mkClassOpAuxOcc : OccName -> OccName :=
  mk_simple_deriv varName (GHC.Base.hs_string__ "$c").

Definition mkBuilderOcc : OccName -> OccName :=
  mk_simple_deriv varName (GHC.Base.hs_string__ "$b").

Definition mkTyConRepOcc : OccName -> OccName :=
  fun occ =>
    let prefix :=
      if isDataOcc occ : bool then GHC.Base.hs_string__ "$tc'" else
      GHC.Base.hs_string__ "$tc" in
    mk_simple_deriv varName prefix occ.

(* Unbound variables:
     Gt Lt NameSpace_op_zg__ NameSpace_op_zgze__ NameSpace_op_zl__
     NameSpace_op_zlze__ None Some andb bool chooseUniqueOcc compare_Namespace
     comparison cons false list negb op_zt__ option orb true Coq.Init.Datatypes.app
     Data.Foldable.foldl FastString.FastString FastString.mkFastString
     FastString.unpackFS GHC.Base.Eq_ GHC.Base.Ord GHC.Base.String GHC.Base.compare
     GHC.Base.id GHC.Base.op_zeze__ GHC.Base.op_zgzgze__ GHC.Base.op_zsze__
     GHC.Base.return_ GHC.Num.Int GHC.Num.fromInteger Module.Module Module.moduleName
     Module.moduleNameString Module.moduleUnitId Module.unitIdString UniqFM.UniqFM
     UniqFM.addListToUFM UniqFM.addListToUFM_C UniqFM.addToUFM UniqFM.addToUFM_Acc
     UniqFM.addToUFM_C UniqFM.alterUFM UniqFM.delFromUFM UniqFM.delListFromUFM
     UniqFM.elemUFM UniqFM.eltsUFM UniqFM.emptyUFM UniqFM.filterUFM UniqFM.foldUFM
     UniqFM.listToUFM UniqFM.lookupUFM UniqFM.mapUFM UniqFM.plusUFM UniqFM.plusUFM_C
     UniqFM.unitUFM UniqSet.UniqSet UniqSet.addListToUniqSet UniqSet.addOneToUniqSet
     UniqSet.elementOfUniqSet UniqSet.emptyUniqSet UniqSet.filterUniqSet
     UniqSet.foldUniqSet UniqSet.intersectUniqSets UniqSet.isEmptyUniqSet
     UniqSet.minusUniqSet UniqSet.mkUniqSet UniqSet.unionManyUniqSets
     UniqSet.unionUniqSets UniqSet.uniqSetToList UniqSet.unitUniqSet Util.thenCmp
*)
