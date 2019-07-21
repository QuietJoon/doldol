{-# LANGUAGE TemplateHaskell #-}

module Test.Flag where


import Data.Flag.Simple
import Data.Word

import Test.Framework
import Test.Framework.Providers.HUnit
import Test.Framework.TH
import Test.HUnit.Base
import Test.QuickCheck

import Test.Flag.Env


tests = $(testGroupGenerator)

test_showFlag =
  [ testCase "\"0000000000000000000000000000000000000000000000000000000001001001\" == showFlag  73" c_sF01
  , testCase "\"0000000000000000000000000000000000000000000000000000000001111101\" == showFlag 125" c_sF02
  , testCase "\"0000000000000000000000000000000000000000000000000000000011001011\" == showFlag 203" c_sF03
  , testCase "\"0000000000000000000000000000000000000000000000000000000011001111\" == showFlag 207" c_sF04
  , testCase "\"0000000000000000000000000000000000000000000000000000000101001001\" == showFlag 329" c_sF05
  ]

c_sF01 = "0000000000000000000000000000000000000000000000000000000001001001" @=? showFlag  73
c_sF02 = "0000000000000000000000000000000000000000000000000000000001111101" @=? showFlag 125
c_sF03 = "0000000000000000000000000000000000000000000000000000000011001011" @=? showFlag 203
c_sF04 = "0000000000000000000000000000000000000000000000000000000011001111" @=? showFlag 207
c_sF05 = "0000000000000000000000000000000000000000000000000000000101001001" @=? showFlag 329

test_eqAbout =
  [ testCase "eqAbout 125 203 329 == True" c_eA01
  , testCase "eqAbout 125 207 329 == False" c_eA02
  ]

c_eA01 = assertBool "" (eqAbout 125 203 329)
c_eA02 = assertBool "" (not $ eqAbout 125 207 329)
