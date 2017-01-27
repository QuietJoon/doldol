module Main where


import Data.Flag
import Data.Int
import Test.TestEnv
import Test.QuickCheck

quicks = do
  -- Should not fail at test but assertion with `X`, should not fail with `Y`
  quickCheck ((\i -> (encodeFlag . (decodeFlag :: Flag -> [X])) i == i) :: Flag -> Bool)
  quickCheck ((\i -> (encodeFlag . (decodeFlag :: Flag -> [Y])) i == i) :: Flag -> Bool)
  -- Should success
  quickCheck ((\i -> (readFlag . showFlag) i == i) :: Flag -> Bool)
  -- Should fail because input is not limited by -2^15~2^15-1
  quickCheck ((\i -> (readFlag . showFlagBy 16) i == i) :: Flag -> Bool)
  -- Should not fail at test but assertion because input is lemited in Flag representation
  quickCheck ((\i -> (readFlag . showFlagFit X0) i == i) :: Flag -> Bool)
  -- Should not fail
  quickCheck ((\i -> (readFlag . showFlagFit Y1) i == i) :: Flag -> Bool)

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


main = do
  print $ showFlagBy 0 1
  quicks
  print $ isFlaggable A
  print $ isFlaggable X0
  print $ isFlaggable Y1
  print $ encodeFlag [X0,X1]
