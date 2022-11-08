use std::rc::Rc;

type RExpr = Rc<Box<Expr>>;
type REnv = Rc<Box<Env>>;

enum Expr {
    Type,
    Var(usize),
    Let(RExpr, RExpr),
    FnType(RExpr, RExpr),
    FnConstruct(RExpr, RExpr),
    FnDestruct(RExpr, RExpr),
}

enum Env {
    NType(RExpr, Option<REnv>),
    NSubst(SExpr, Option<REnv>),
}

impl Env {
    fn depth(&self) -> usize {
        match self {
            Env::NType(_, t) => 1 + t.as_ref().map(|t| t.depth()).unwrap_or(0),
            Env::NSubst(_, t) => 1 + t.as_ref().map(|t| t.depth()).unwrap_or(0),
        }
    }

    fn parent(&self) -> &Option<REnv> {
        match self {
            Env::NType(_, t) => t,
            Env::NSubst(_, t) => t,
        }
    }
}

fn s_put_type(s: REnv, e: RExpr) -> REnv {
    Rc::new(Box::new(Env::NType(e, Some(s))))
}

fn s_put_subst(s: REnv, e: SExpr) -> REnv {
    Rc::new(Box::new(Env::NSubst(e, Some(s))))
}

#[derive(Clone)]
struct SExpr(REnv, RExpr);

fn bhr(e_orig: SExpr) -> SExpr {
    let mut e = e_orig.clone();
    let mut stack: Vec<SExpr> = Vec::new();

    loop {
        match e.1.as_ref().as_ref() {
            Expr::Type => break,
            Expr::Var(mut i) => {
                let mut env = &e.0;
                while i > 0 {
                    env = env.parent().as_ref().unwrap();
                    i -= 1;
                }
                match &***env {
                    Env::NType(_, _) => break,
                    Env::NSubst(se, _) => e = se.clone(),
                }
            }
            Expr::Let(v, b) => {
                e = SExpr(
                    s_put_subst(e.0.clone(), SExpr(e.0, v.clone())),
                    b.clone(),
                )
            }
            Expr::FnType(_, _) => break,
            Expr::FnConstruct(_, _) if stack.len() == 0 => break,
            Expr::FnConstruct(_, b) => {
                e.0 = s_put_subst(e.0, stack.pop().unwrap());
                e.1 = b.clone();
            }
            Expr::FnDestruct(f, a) => {
                stack.push(SExpr(e.0.clone(), a.clone()));
                e.1 = f.clone();
            }
        }
    }

    if !stack.is_empty() {
        e_orig
    } else {
        e
    }
}

fn tp_check(e: SExpr) -> Expr {
    match e.1.as_ref().as_ref() {
        Expr::Type => Expr::Type,
        Expr::Var(i) => {}
        Expr::Let(_, _) => {}
        Expr::FnType(_, _) => {}
        Expr::FnConstruct(_, _) => {}
        Expr::FnDestruct(_, _) => {}
    }
}


fn main() {
    println!("Hello, world!");
}
