module Main where


import Data.Flag.Phantom
import qualified Data.Flag.Simple as S
import Data.Int
import Test.TestEnv
import Test.QuickCheck
import Control.DeepSeq

x1 = PhFlag 1 :: PhantomFlag X
x2 = PhFlag 2 :: PhantomFlag X
y1 = PhFlag 1 :: PhantomFlag Y
y2 = PhFlag 2 :: PhantomFlag Y
z1 = 12 :: S.Flag

main = do
  print $ deepseq x1 $ deepseq x2 $ deepseq y1 $ deepseq y2 $ deepseq z1 $ y2
  print $ showFlagBy 0 x1
  print $ showFlagBy 10 y1

  print $ isFlaggable A
  print $ isFlaggable X0
  print $ isFlaggable Y1
  print $ encodeFlag [X0,X1]
  print $ x1 == x2
  -- print $ x1 == y1
  -- print $ include x1 y1

