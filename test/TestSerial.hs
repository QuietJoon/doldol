module Main where


import Data.Flag
import Data.Int
import Test.TestEnv
import Test.QuickCheck
import Control.DeepSeq


a = ["00","01","10","11"]
b = [(x,y) | x <- a, y <- a]
c f = map (\(x,y) -> (x,y,f (readFlag x) (readFlag y))) b

d = [0..255] :: [Int64]
e = [(x,y) | x <- d, y <- d]
g f = map (\(x,y) -> (x,y,f x y)) e

prints :: (Show a) => [a] -> IO ()
prints = mapM_ print

main = do
  prints $ c include
