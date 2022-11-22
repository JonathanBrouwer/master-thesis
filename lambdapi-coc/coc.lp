constant symbol Utype : TYPE;
constant symbol Ukind : TYPE;
symbol etype : Utype → TYPE;
symbol ekind : Ukind → TYPE;
constant symbol dottype : Ukind;
constant symbol dotpi1 : Π (x : Utype), Π (y : etype x → Utype), Utype;
constant symbol dotpi2 : Π (x : Utype), Π (y : etype x → Ukind), Ukind;
constant symbol dotpi3 : Π (x : Ukind), Π (y : ekind x → Utype), Utype;
constant symbol dotpi4 : Π (x : Ukind), Π (y : ekind x → Ukind), Ukind;
rule etype (dotpi1 $x $y) ↪ Π (w : etype $x), etype ($y w)
with etype (dotpi3 $x $y) ↪ Π (w : ekind $x), etype ($y w);
rule ekind dottype ↪ Utype
with ekind (dotpi2 $x $y) ↪ Π (w : etype $x), ekind ($y w)
with ekind (dotpi4 $x $y) ↪ Π (w : ekind $x), ekind ($y w);
symbol a : Π (x : Utype), Π (y : etype x), etype x;
rule a ↪ λ (x : Utype), λ (y : etype x), y;
constant symbol False : Utype;
constant symbol True : Utype;
constant symbol I : etype True;
symbol eq : Π (t : Utype), etype t → etype t → TYPE;
constant symbol eq_ : Π (t : Utype), etype t → etype t → Utype;
rule eq $t $x $y ↪ etype (eq_ $t $x $y);
constant symbol refl_equal : Π (t : Utype), Π (x : etype t), eq t x x;
constant symbol eq_rec
  : Π (t : Utype),
      Π (x : etype t),
        Π (p : etype t → Utype),
          Π (g : etype (p x)),
            Π (y : etype t), Π (h : eq t x y), etype (p y);
symbol f_equal
  : Π (A : Utype),
      Π (B : Utype),
        Π (f : etype A → etype B),
          Π (x : etype A),
            Π (y : etype A), Π (H : eq A x y), eq B (f x) (f y);
rule f_equal ↪ λ (A : Utype),
                   λ (B : Utype),
                     λ (f : etype A → etype B),
                       λ (x : etype A),
                         λ (y : etype A),
                           λ (H : eq A x y),
                             eq_rec A x (λ (z : etype A), eq_ B (f x) (f z))
                             (refl_equal B (f x)) y H;
constant symbol nat_ : Utype;
symbol nat : TYPE;
rule nat ↪ etype nat_;
constant symbol Z : nat;
constant symbol S : nat → nat;
symbol nat_rec
  : Π (t : Utype),
      etype t → (nat → etype t → etype t) → nat → etype t;
rule nat_rec $t $a $f Z ↪ $a
with nat_rec $t $a $f (S $n) ↪ $f $n (nat_rec $t $a $f $n);
symbol plus : nat → nat → nat;
rule plus ↪ λ (x : nat),
                λ (y : nat),
                  nat_rec nat_ Z (λ (x : nat), λ (y : nat), y) x;
symbol plus2 : nat → nat → nat;
rule plus2 $x Z ↪ $x
with plus2 Z $x ↪ $x
with plus2 $x (S $y) ↪ S (plus2 $x $y)
with plus2 (S $x) $y ↪ S (plus2 $x $y);
symbol eq_S : Π (x : nat), Π (y : nat), eq nat_ x y → eq nat_ (S x) (S y);
rule eq_S ↪ f_equal nat_ nat_ S;
symbol eq_S2
  : etype
    (dotpi1 nat_
     (λ (x : nat),
        dotpi1 nat_
        (λ (y : nat),
           dotpi1 (eq_ nat_ x y) (λ (h : eq nat_ x y), eq_ nat_ (S x) (S y)))));
rule eq_S2 ↪ eq_S;
symbol pred : nat → nat;
rule pred ↪ nat_rec nat_ Z (λ (x : nat), λ (dummy : nat), x);
symbol pred2 : nat → nat;
rule pred2 Z ↪ Z
with pred2 (S $x) ↪ $x;
symbol pred_Sn : Π (n : nat), eq nat_ n (pred (S n));
rule pred_Sn ↪ λ (n : nat), refl_equal nat_ n;
