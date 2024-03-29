module Lib (Expr (..), Env, EnvEntry (..), SExpr, tc, brh) where

import Data.Maybe (fromMaybe)


data Expr =
  Type
  | Let Expr Expr
  | Var Int
  | FnType Expr Expr
  | FnConstruct Expr Expr
  | FnDestruct Expr Expr
  deriving (Show, Eq)

type SExpr = (Env, Expr)

type Env = [EnvEntry]

data EnvEntry = NType Expr | NSubst SExpr
  deriving (Show, Eq)

sPutSubst :: Env -> SExpr -> Env
sPutSubst env v = NSubst v : env

sPutType :: Env -> Expr -> Env
sPutType env v = NType v : env

brh :: SExpr -> SExpr
brh e = fromMaybe e (brh_ e [])

brh_ :: SExpr -> [SExpr] -> Maybe SExpr
brh_ (s, Type) [] = Just (s, Type)
brh_ (s, Let v b) tt = brh_ (sPutSubst s (s, v), b) tt
brh_ (s, Var i) tt = case s !! i of
  NType _ -> if null tt then Just (s, Var i) else Nothing
  NSubst se -> brh_ se tt
brh_ (s, FnType a b) [] = Just (s, FnType a b)
brh_ (s, FnConstruct a b) [] = Just (s, FnConstruct a b)
brh_ (s, FnConstruct _ b) (t : tt) = brh_ (sPutSubst s t, b) tt
brh_ (s, FnDestruct f a) tt = brh_ (s, f) ((s, a) : tt)

br :: SExpr -> Expr
br se = case brh se of
  (_, Type) -> Type
  (_, Var i) -> Var i
  (s, FnType a b) -> FnType (br (s, a)) (br (sPutType s a, b))
  (s, FnConstruct a b) -> FnConstruct (br (s, a)) (br (sPutType s a, b))
  (s, FnDestruct a b) -> FnDestruct (br (s, a)) (br (s, b))

beq :: SExpr -> SExpr -> Either String ()
beq e1 e2 = case (brh e1, brh e2) of
  ((_, Type), (_, Type)) -> pure ()
  ((_, Var i), (_, Var j)) -> if i == j then pure () else Left $ "Expected variable " ++ show j ++ ", but got variable " ++ show i
  ((s1, FnType a1 b1), (s2, FnType a2 b2)) -> do
     beq (s1, a1) (s2, a2)
     beq (sPutType s1 a1, b1) (sPutType s2 a2, b2)
  ((s1, FnConstruct a1 b1), (s2, FnConstruct a2 b2)) -> do
     beq (s1, a1) (s2, a2)
     beq (s1, b1) (s2, b2)
  ((s1, FnDestruct a1 b1), (s2, FnDestruct a2 b2)) -> do
    beq (s1, a1) (s2, a2)
    beq (s1, b1) (s2, b2)
  _ -> Left $ "Expected " ++ show e2 ++ ", but got " ++ show e1

tc :: SExpr -> Either String Expr
tc (_, Type) = pure Type
tc (s, Var i) = do
  vt <- case s !! i of
    NType t -> pure t
    NSubst es -> tc es
  pure (shift (i + 1) 0 vt)
tc (s, Let v b) = do
  _ <- tc (s, v)
  bt <- tc (sPutSubst s (s, v), b)
  pure (shift (-1) 0 bt)
tc (s, FnType a b) = do
  at <- tc (s, a)
  beq ([], at) ([], Type)
  let at' = br (s, a)
  bt <- tc (sPutType s at', b)
  beq ([], bt) ([], Type)
  pure Type
tc (s, FnConstruct a b) = do
  at <- tc (s, a)
  beq ([], at) ([], Type)
  let at' = br (s, a)
  bt <- tc (sPutType s at', b)
  pure $ FnType at' bt
tc (s, FnDestruct f a) = do
  ft <- tc (s, f)
  at <- tc (s, a)
  (sf, dt, db) <- case brh ([], ft) of
    (sf, FnType dt db) -> pure (sf, dt, db)
    _ -> Left $ "Expected function, but got " ++ show (brh ([], ft))
  beq ([], at) (sf, dt)
  pure $ br (sPutSubst sf (s, a), db)

-- shift indices with `m` if >= than cutoff `c` in the term
shift :: Int -> Int -> Expr -> Expr
shift _ _ Type = Type
shift k c (Var i) | i >= c = Var (i + k)
shift _ _ (Var i) = Var i
shift k c (Let v b) = Let (shift k c v) (shift k (c + 1) b)
shift k c (FnType a b) = FnType (shift k c a) (shift k (c + 1) b)
shift k c (FnConstruct a b) = FnConstruct (shift k c a) (shift k (c + 1) b)
shift k c (FnDestruct a b) = FnDestruct (shift k c a) (shift k c b)