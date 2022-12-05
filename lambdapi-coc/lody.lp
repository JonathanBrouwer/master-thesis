// Sort is all types that a type may have
// In our language, this is always `Type`
constant symbol Sort : TYPE;

// We need a way to combine sorts
// sort1 and sort2 are the inputs to this function. 
// This function calculates (for any type1 type2):
//    and type1 : sort1, type2 : sort2,
//    what is the sort of `type1 -> type2`?
symbol sort_cmb : Sort → Sort → Sort;

// Represents a term of sort `s`, so this term is a type in the embedded language.
constant symbol TmSort : Π (s : Sort), TYPE;

// Rerpesents a term of type `a`, which has sort `s`. 
symbol TmType : Π (s : Sort), Π (a : TmSort s), TYPE;

// This is `Type` in the embedded language
symbol Type : Sort;
type TmSort Type;

// Combining `Type` with `Type` results in `Type`
rule sort_cmb Type Type ↪ Type;

// This is `FnType` in the embedded language
constant symbol FnType :
  // Given two sorts
  Π (s1 : Sort), Π (s2 : Sort),
  // And an argument type of sort s1
  Π (A : TmSort s1), 
  // And a body type of sort s2 (that may depend on the argument value)
  Π (B : TmType s1 A → TmSort s2), 
  // And this type is of sort `TmSort (cmb s1 s2)`
  TmSort (sort_cmb s1 s2);
rule TmType _ (FnType $s1 $s2 $A $B) ↪ Π (x : TmType $s1 $A), TmType $s2 ($B x);

// This is `FnConstruct` in the embedded language
symbol FnConstruct :
  // Given two sorts
  Π (s1 : Sort), Π (s2 : Sort),
  // And an argument type of sort s1
  Π (A : TmSort s1), 
  // And an body type of sort s2
  Π (B : TmType s1 A → TmSort s2), 
  // What is the function itself?
  Π (f : Π (x : TmType s1 A), TmType s2 (B x)), 
  // Function type
  TmType _ (FnType s1 s2 A B);
rule FnConstruct _ _ _ _ $f ↪ $f;

// This is `FnDestruct` in the embedded language
symbol FnDestruct :
  // Given two sorts
  Π (s1 : Sort), Π (s2 : Sort),
  // And an argument type of sort s1
  Π (A : TmSort s1), 
  // And an body type of sort s2
  Π (B : TmType s1 A → TmSort s2), 
  // Function value
  Π (f : TmType _ (FnType _ _ A B)),
  // Argument value
  Π (a : TmType _ A),
  // Expression has type B
  TmType _ (B a);
rule FnDestruct _ _ _ _ $f $a ↪ $f $a;

// This is `Let` in the embedded language
// The semantics of let are different than in the other implementations, discussed in report



// Example extra declarations
constant symbol Nat : TmSort Type;




// Tests
assert ⊢ Type : Sort;

type TmSort Type;


// type FnConstruct Type Type Type;


// assert ⊢