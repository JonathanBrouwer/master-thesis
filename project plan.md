Research Question: Can a dependently typed language be made in spoofax?
Preliminary Answer: Yes.

Projects:
[x] Research how dependent type checking works (4 weeks)
[x] Implement CoC in sdf3+statix (2 weeks)
[x] Using krivine-inspired architecture to improve performance (1 week)
    - Needed to change a rule?
[x] Fixing name collisions (See "Tricky Types" tests, 2 weeks???)
    - Statix does not support string concat :c
    - Very complex
    -> .ref property and stratego pass to generate new names
    - do scope graphs help fixing this? -> Result

    Things that were tried:
    - Using spoofax things, would really like support for checking .ref properties
    - Using uniquify stages, at the end was implemented but too late. At the start breaks spoofax

Most interesting:
[ ] Language-parametric services exploration (few weeks?)
    - Code completion + Renaming
    - renaming not in spoofax 3?
    - code completion -> contact daniel pelsmaeker
        - What is Plhdr? -> Placeholder

[x] Implicit arguments (not sure?)
    - when using _ variable
    - to ensure no free metavars, make rule that matches everything
    - add meta variable during typechecking
    - unif sigma paper http://www.cse.chalmers.se/~abela/unif-sigma-long.pdf
    - https://kilthub.cmu.edu/articles/journal_contribution/Optimizing_Higher-Order_Pattern_Unification/6608198/1

[ ] Inductive data types with positivity + coverage checking
    - Start with bools+nats, vecs?
    -  natural number eliminator
    
    elimNat : (P : Nat -> Type) (pzero : P zero) (psuc : (n : Nat) -> P n -> P (suc n)) -> (n : Nat) -> P n
    elimBool : (P : Bool -> Type) (pfalse : P false) (ptrue : P true) -> (b : Bool) -> P b
    
    elimBool : (Pfalse : Type) (Ptrue : Type) (pfalse : Pfalse) (ptrue : Ptrue) -> (b : Bool) -> P b
    
    elimVec : ???
    
[ ] Adding synctactic sugar
[ ] Fixpoints and termination checking
[ ] Universe support


- Add postulates

FIX:
```
\f : (_: Type -> Type).
\g : (_: f Bool -> f Bool).
g
```


- Type elaboration in statix -> Add to paper
- Msg daniel
