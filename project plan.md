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


TODO:
[x] Steal tests from pi for all
[x] change / to \
[ ] read "Scopes as types" -> how do system f
    -> My approach of substitution is the same as section 2.5

Most interesting:
[ ] Language-parametric services exploration (few weeks?)
    - Code completion + Renaming
    - renaming not in spoofax 3?
    - code completion -> contact daniel pelsmaeker
        - What is Plhdr? -> Placeholder

[ ] Implicit arguments (not sure?)
    - when using _ variable
    - to ensure no free metavars, make rule that matches everything
    - add meta variable during typechecking
    - unif sigma paper http://www.cse.chalmers.se/~abela/unif-sigma-long.pdf
    - https://kilthub.cmu.edu/articles/journal_contribution/Optimizing_Higher-Order_Pattern_Unification/6608198/1

[ ] Inductive data types with positivity + coverage checking (1-4 weeks?)
    - Start with bools+nats, vecs?
[ ] Adding synctactic sugar (1 week)
[ ] Fixpoints and termination checking (1-4 weeks?)
[ ] Universe support (1-4 weeks?)



