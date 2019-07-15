{-# LANGUAGE TemplateHaskell #-}

module Test.Flag.Phantom where


import Data.Flag.Phantom
import Data.Word

import Test.Framework
import Test.Framework.Providers.HUnit
import Test.Framework.Providers.QuickCheck2
import Test.Framework.TH
import Test.HUnit.Base
import Test.QuickCheck

import Test.Flag.Env


tests = $(testGroupGenerator)

x1 = PhFlag 1 :: PhantomFlag X
x2 = PhFlag 2 :: PhantomFlag X
y1 = PhFlag 1 :: PhantomFlag Y
y2 = PhFlag 2 :: PhantomFlag Y

test_encDec =
  [ testProperty "(getFlag . encodeFlag . (decodeFlag :: PhantomFlag X -> [X]) . PhFlag) i == i" prop_ged01
  , testProperty "(getFlag . encodeFlag . (decodeFlag :: PhantomFlag Y -> [Y]) . PhFlag) i == i" prop_ged02
  ]

prop_ged01 i = (getFlag . encodeFlag . (decodeFlag :: PhantomFlag X -> [X]) . PhFlag) i == i
  where types = (i :: Flag)
prop_ged02 i = (getFlag . encodeFlag . (decodeFlag :: PhantomFlag Y -> [Y]) . PhFlag) i == i
  where types = (i :: Flag)

test_readShow =
  [ testProperty "(getFlag . readFlag . showFlag . PhFlag) i == i" prop_rs01
  , testProperty "(getFlag . readFlag . showFlagBy 16 . PhFlag) i == i" prop_rs02
  , testProperty "(getFlag . readFlag . showFlagFit X0 . PhFlag) i == i" prop_rs03
  , testProperty "(getFlag . readFlag . showFlagFit Y1 . PhFlag) i == i" prop_rs04
  ]

prop_rs01 i = (getFlag . readFlag . showFlag . PhFlag) i == i
  where types = (i :: Flag)
prop_rs02 i = (getFlag . readFlag . showFlagBy 16 . PhFlag) i == i
  where types = (i :: Flag)
prop_rs03 i = (getFlag . readFlag . showFlagFit X0 . PhFlag) i == i
  where types = (i :: Flag)
prop_rs04 i = (getFlag . readFlag . showFlagFit Y1 . PhFlag) i == i
  where types = (i :: Flag)

test_showFlagBy =
  [ testCase "showFlagBy 0 (PhFlag 1) == \"\"" c_sFB01
  , testCase "showFlagBy 1 (PhFlag 1) == \"1\"" c_sFB02
  , testCase "showFlagBy 9 (PhFlag 1) == \"000000001\"" c_sFB03
  ]

c_sFB01 = showFlagBy 0 (PhFlag 1) @?= ""
c_sFB02 = showFlagBy 1 (PhFlag 1) @?= "1"
c_sFB03 = showFlagBy 9 (PhFlag 1) @?= "000000001"
