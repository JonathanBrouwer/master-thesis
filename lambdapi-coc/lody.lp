symbol ty : TYPE;
symbol tm : ty → TYPE;

symbol Type : ty;
rule tm Type ↪ ty;

symbol FnType : Π (x : ty), Π (y : tm x → ty), ty;
symbol FnConstruct : Π (x : ty), Π (y : tm x → ty), Π (f : (Π (k : tm x), tm (y k))), tm (FnType x y);
symbol FnDestruct : Π (x : ty), Π (y : tm x → ty),  Π (f : tm (FnType x y)), Π (a : tm x), tm (y a);
rule FnDestruct $x $y (FnConstruct $x $y $u) $v ↪ $u $v;

// This is not correct?
symbol Let : Π (x : ty), Π (y : ty), Π (a : tm x), Π (b : tm x → tm y), tm y;
rule Let $x $y $a $b ↪ $b $a;
