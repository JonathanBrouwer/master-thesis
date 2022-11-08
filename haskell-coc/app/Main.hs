module Main (main) where

import Data.Maybe (fromMaybe)


data Expr =
  Type
  | Let Expr Expr
  | Var Int
  | FnType Expr Expr
  | FnConstruct Expr Expr
  | FnDestruct Expr Expr
  deriving Show

type SExpr = (Env, Expr)

type Env = [EnvEntry]

data EnvEntry = NType Expr | NSubst SExpr
  deriving Show

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


main :: IO ()
main = putStr ""
