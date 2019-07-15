{-# LANGUAGE TemplateHaskell #-}

module Test.Flag.Serial where


import Control.DeepSeq

import Data.Flag
import Data.Word

import Test.Framework
import Test.Framework.Providers.HUnit
import Test.Framework.TH
import Test.HUnit.Base
import Test.QuickCheck

import Test.Flag.Env


tests = $(testGroupGenerator)

a = ["00","01","10","11"]
b = [(x,y) | x <- a, y <- a]
c f = map (\(x,y) -> (x,y,f (readFlag x) (readFlag y))) b

d = [0..255] :: [Word64]
e = [(x,y) | x <- d, y <- d]
g f = map (\(x,y) -> (x,y,f x y)) e

prints :: (Show a) => [a] -> IO ()
prints = mapM_ print

{-
main = do
  prints $ c include
-}
