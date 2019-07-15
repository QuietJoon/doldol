import qualified Test.Framework as Test
import qualified Test.Framework.Providers.HUnit as Test
import qualified Test.Framework.Providers.QuickCheck2 as Test
import Test.HUnit
import Test.QuickCheck

import Test.Flag
import Test.Flag.Env
import Test.Flag.DeepSeq
import Test.Flag.Phantom
import Test.Flag.Serial

import Data.Flag
import Data.Word


main =
  Test.defaultMain
    [ Test.Flag.tests
    , Test.Flag.DeepSeq.tests
    , Test.Flag.Phantom.tests
    , Test.Flag.Serial.tests
    ]
