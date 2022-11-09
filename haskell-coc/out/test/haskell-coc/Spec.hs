-- file Spec.hs
import Test.Hspec
import Lib

main :: IO ()
main = hspec $ do
  describe "Type checking" $ do
    it "1" $ Type `hasType` Type
    it "2" $ FnConstruct Type Type `hasType` FnType Type Type
    it "3" $ FnType Type Type `hasType` Type
    it "4" $ FnConstruct Type (FnConstruct (Var 0) (Var 1)) `hasType` FnType Type (FnType (Var 0) Type)
    it "5" $ Let (FnConstruct Type Type) (Var 0) `hasType` FnType Type Type
    it "6" $ Let Type (Let (FnConstruct (Var 0) (Var 1)) (Var 0)) `hasType` FnType Type Type
    it "7" $ FnConstruct Type (Let (FnConstruct (Var 0) (Var 0)) (Var 0)) `hasType` FnType Type (FnType (Var 0) (Var 1))
    it "8" $ FnConstruct Type (FnConstruct (Var 0) (Var 0)) `hasType` FnType Type (FnType (Var 0) (Var 1))
    it "9" $ FnConstruct Type (FnDestruct (FnConstruct Type (Var 0)) (Var 0)) `hasType` FnType Type Type
    it "10" $ FnConstruct Type (FnDestruct (FnConstruct Type (Var 1)) (Var 0)) `hasType` FnType Type Type
    it "11" $ FnConstruct Type (FnConstruct (Var 0) (Var 0)) `hasType` FnType Type (FnType (Var 0) (Var 1))
    it "12" $ FnDestruct (FnConstruct Type (FnConstruct (Var 0) (Var 0))) Type `hasType` FnType Type Type

hasType :: Expr -> Expr -> Expectation
hasType e t = tc ([], e) `shouldBe` Right t