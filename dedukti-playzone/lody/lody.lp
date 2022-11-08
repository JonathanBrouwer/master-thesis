symbol Expr : TYPE;
symbol etype : Expr → TYPE;

symbol Type : Expr;
constant symbol FnType : Π (x : Expr), Π (y : etype x → Expr), Expr;
constant symbol FnConstruct : Π (x : Expr), Π (y : etype x → Expr), Expr;
constant symbol FnDestruct : Π (x : Expr), Π (y : Expr), Expr;

