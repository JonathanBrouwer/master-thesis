// Represents a term of sort, so this term is a type in the embedded language.
constant symbol TmSort : TYPE;

// Rerpesents a term of type `a`. 
symbol TmType : Π (a : TmSort), TYPE;

// This is `Type` in the embedded language
constant symbol Type : TmSort;
rule TmType Type ↪ TmSort;

// This is `FnType` in the embedded language
constant symbol FnType :
  // And an argument type of sort s1
  Π (A : TmSort), 
  // And a body type of sort s2 (that may depend on the argument value)
  Π (B : TmType A → TmSort), 
  // And this type is of sort `TmSort (cmb s1 s2)`
  TmSort;
rule TmType (FnType $A $B) ↪ Π (x : TmType $A), TmType ($B x);

// This is `FnConstruct` in the embedded language
symbol FnConstruct :
  // And an argument type of sort s1
  Π (A : TmSort), 
  // And an body type of sort s2
  Π (B : TmType A → TmSort), 
  // What is the function itself?
  Π (f : Π (x : TmType A), TmType (B x)), 
  // Function type
  TmType (FnType A B);
rule FnConstruct _ _ $f ↪ $f;

// This is `FnDestruct` in the embedded language
symbol FnDestruct :
  // And an argument type of sort s1
  Π (A : TmSort), 
  // And an body type of sort s2
  Π (B : TmType A → TmSort), 
  // Function value
  Π (f : TmType (FnType A B)),
  // Argument value
  Π (a : TmType A),
  // Expression has type B
  TmType (B a);
rule FnDestruct _ _ $f $a ↪ $f $a;

// // This is `Let` in the embedded language
// // The semantics of let are different than in the other implementations, discussed in thesis
symbol Let : 
  Π (A : TmSort), 
  Π (B : TmType A → TmSort), 
  Π (v : TmType A),
  Π (b : TmType A → TmType (B v)),
  TmType (B v);
rule Let _ _ $v $b ↪ $b $v;

// // Example extra declarations from Agda
constant symbol Nat : TmSort;
symbol zero : TmType Nat;
symbol suc : TmType (FnType Nat (λ _, Nat));
symbol pred : TmType (FnType Nat (λ _, Nat));
rule pred zero ↪ zero;
rule pred (suc $m) ↪ $m;


// Test 1
assert ⊢ Type 
  : TmType Type;
// Test 2
assert ⊢ FnConstruct Type (λ _, Type) (λ _, Type) 
  : TmType (FnType Type (λ _, Type));
// Test 3
assert ⊢ FnType Type (λ _, Type) 
  : TmType Type;
// Test 4
assert ⊢ FnConstruct Type (λ T, FnType T (λ _, Type)) (λ T, FnConstruct T (λ _, Type) (λ x, T))
  : TmType (FnType Type (λ T, FnType T (λ _, Type)));

// Test 5
assert ⊢ Let (FnType Type (λ _, Type)) (λ _, (FnType Type (λ _, Type))) (FnConstruct Type (λ _, Type) (λ _, Type)) (λ v, v)
  : TmType (FnType Type (λ _, Type));

// Test 6
assert ⊢ Let Type (λ _, FnType Type (λ _, Type)) Type (λ s, FnConstruct Type (λ _, Type) (λ _, s)) 
  : TmType (FnType Type (λ _, Type));

// Test 8
assert ⊢ FnConstruct Type (λ T, FnType T (λ _, T)) (λ T, FnConstruct T (λ _, T) (λ x, x))
  : TmType (FnType Type (λ T, FnType T (λ _, T)));
// Test 9
assert ⊢ FnConstruct Type (λ T, Type) (λ T, FnDestruct Type (λ _, Type) (FnConstruct Type (λ _, Type) (λ x, x)) T)
  : TmType (FnType Type (λ _, Type));
// Test 10
assert ⊢ FnConstruct Type (λ T, Type) (λ T, FnDestruct Type (λ _, Type) (FnConstruct Type (λ _, Type) (λ x, T)) T)
  : TmType (FnType Type (λ _, Type));
// Test 11
assert ⊢ FnConstruct Type (λ T, FnType T (λ _, T)) (λ T, FnConstruct T (λ _, T) (λ x, x))
  : TmType (FnType Type (λ T, FnType T (λ _, T)));
// Test 12
assert ⊢ FnDestruct Type (λ T, FnType Type (λ _, Type)) (FnConstruct Type (λ T, FnType Type (λ _, Type)) (λ T, FnConstruct Type (λ _, Type) (λ _, T))) Type
  : TmType (FnType Type (λ _, Type));

