{-# LANGUAGE TemplateHaskell #-}

module Test.Flag.DeepSeq where


import Control.DeepSeq

import Data.Flag.Phantom
import qualified Data.Flag.Simple as S
import Data.Word

import Test.Framework
import Test.Framework.Providers.HUnit
import Test.Framework.TH
import Test.HUnit.Base
import Test.QuickCheck

import Test.Flag.Env


tests = $(testGroupGenerator)

x1 = PhFlag 1 :: PhantomFlag X
x2 = PhFlag 2 :: PhantomFlag X
y1 = PhFlag 1 :: PhantomFlag Y
y2 = PhFlag 2 :: PhantomFlag Y
z1 = 12 :: S.Flag

-- print $ deepseq x1 $ deepseq x2 $ deepseq y1 $ deepseq y2 $ deepseq z1 $ y2

test_showFlagBy =
  [ testCase "showFlagBy  0 x1 == \"\"" c_sFB01
  , testCase "showFlagBy  1 x2 == \"0\"" c_sFB02
  , testCase "showFlagBy  2 x2 == \"10\"" c_sFB03
  , testCase "showFlagBy 10 y1 == \"0000000001\"" c_sFB04
  , testCase "showFlagBy 10 y2 == \"0000000010\"" c_sFB05
  ]

c_sFB01 = showFlagBy 0 x1 @?= ""
c_sFB02 = showFlagBy 1 x2 @?= "0"
c_sFB03 = showFlagBy 2 x2 @?= "10"
c_sFB04 = showFlagBy 10 y1 @?= "0000000001"
c_sFB05 = showFlagBy 10 y2 @?= "0000000010"

test_isFlaggable =
  [ testCase "isFlaggable A  == True"  c_if01
  , testCase "isFlaggable X0 == False" c_if02
  , testCase "isFlaggable Y1 == True"  c_if03
  ]

c_if01 = assertBool "" (isFlaggable $ A)
c_if02 = assertBool "" (not . isFlaggable $ X0)
c_if03 = assertBool "" (isFlaggable $ Y1)

test_encodeFlag =
  [ testCase "encodeFlag [X0,X1] == PhFlag 3" c_eF01
  ]

c_eF01 = PhFlag 3 @=? encodeFlag [X0,X1]

{-
  Can't test because of type error

_test_equal =
  [ testCase "x1 /= x2" c_eq01
  , testCase "x1 == y1" c_eq02
  ]

c_eq01 = x1 @?= x2
c_eq02 = x1 @?= y1

_test_include =
  [ testCase "include x1 y1" c_incl01
  , testCase "include x1 x2" c_incl02
  ]

c_incl01 = assertBool "" (include x1 y1)
c_incl02 = assertBool "" (include x1 x2)
-}
