module Main where


import Data.Flag.Phantom
import Data.Word
import Test.TestEnv
import Test.QuickCheck

quicks = do
  -- Should not fail at test but assertion with `X`, should not fail with `Y`
  quickCheck ((\i -> (getFlag . encodeFlag . (decodeFlag :: PhantomFlag X -> [X]) . PhFlag) i == i) :: Flag -> Bool)
  quickCheck ((\i -> (getFlag . encodeFlag . (decodeFlag :: PhantomFlag Y -> [Y]) . PhFlag) i == i) :: Flag -> Bool)
  -- Should success
  quickCheck ((\i -> (getFlag . readFlag . showFlag . PhFlag) i == i) :: Flag -> Bool)
  -- Should fail because input is not limited by -2^15~2^15-1
  quickCheck ((\i -> (getFlag . readFlag . showFlagBy 16 . PhFlag) i == i) :: Flag -> Bool)
  -- Should not fail at test but assertion because input is lemited in Flag representation
  quickCheck ((\i -> (getFlag . readFlag . showFlagFit X0 . PhFlag) i == i) :: Flag -> Bool)
  -- Should not fail
  quickCheck ((\i -> (getFlag . readFlag . showFlagFit Y1 . PhFlag) i == i) :: Flag -> Bool)

{-
*Main> mapM_ (putStrLn . showFlag) [73,125,203,207,329]
000001001001
000001111101
000011001011
000011001111
000101001001
*Main> eqAbout 125 203 329
True
*Main> eqAbout 125 207 329
False
-}

x1 = PhFlag 1 :: PhantomFlag X
x2 = PhFlag 2 :: PhantomFlag X
y1 = PhFlag 1 :: PhantomFlag Y
y2 = PhFlag 2 :: PhantomFlag Y

main = do
  print $ showFlagBy 0 (PhFlag 1)
  print $ showFlagBy 10 (PhFlag 1)
  quicks
  print $ isFlaggable A
  print $ isFlaggable X0
  print $ isFlaggable Y1
  print $ encodeFlag [X0,X1]
  print $ x1 == x2
  -- print $ x1 == y1
  -- print $ include x1 y1

