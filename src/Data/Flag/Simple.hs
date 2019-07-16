{-# LANGUAGE MagicHash, BangPatterns #-}
{-# LANGUAGE CPP #-}

module Data.Flag.Simple
  ( module Data.Flag.Simple
  , module Flag
  ) where


import Data.Flag.Internal as Flag


#ifdef DEBUG
import Control.Exception
#endif

import Data.Bits

import GHC.Base


encodeFlag :: (Foldable f, Bounded e, Enum e) => f e -> Flag
encodeFlag = Prelude.foldr (\x b -> setBit b (fromEnum x)) zeroBits

decodeFlag :: Enum e => Flag -> [e]
decodeFlag aFlag = decodeFlagSub (bitLen# -# 1#)
  where
    !(I# bitLen#) = bitLen
    decodeFlagSub (-1#) = []
    decodeFlagSub  idx# =
      if testBit aFlag (I# idx#)
        then toEnum (I# idx#) : decodeFlagSub (idx# -# 1#)
        else                    decodeFlagSub (idx# -# 1#)

showFlag :: Flag -> String
showFlag aFlag = showFlagSub (bitLen#-#1#)
  where
    !(I# bitLen#) = bitLen
    showFlagSub (-1#) = ""
    showFlagSub  idx# =
      if testBit aFlag (I# idx#)
        then '1' : showFlagSub (idx#-#1#)
        else '0' : showFlagSub (idx#-#1#)

showFlagFit :: (Bounded e, Enum e) => e -> Flag -> String
showFlagFit a aFlag =
#ifdef DEBUG
    -- Assertion for `Flag` according to `a`. This is not needed for `showFlag`.
  assert (isFlaggable a) $
#endif
    showFlagSub bitLen#
  where
    !(I# bitLen#) = fromEnum (maxBound `asTypeOf` a)
    showFlagSub (-1#) = ""
    showFlagSub  idx# =
      if testBit aFlag (I# idx#)
        then '1' : showFlagSub (idx#-#1#)
        else '0' : showFlagSub (idx#-#1#)

showFlagBy :: Int -> Flag -> String
showFlagBy l@(I# bitLen#) aFlag =
#ifdef DEBUG
    -- Assertion for Flag. This is not needed for showFlag
  assert (l <= bitLen && l > 0) $
#endif
    showFlagSub (bitLen#-#1#)
  where
    showFlagSub (-1#) = ""
    showFlagSub  idx# =
      if testBit aFlag (I# idx#)
        then '1' : showFlagSub (idx#-#1#)
        else '0' : showFlagSub (idx#-#1#)

readFlag :: String -> Flag
readFlag aFlagString = readFlagSub aFlagString zeroBits
readFlagSub [] acc = acc
readFlagSub (x:xs) acc =
  if x == '0'
    then readFlagSub xs next
    else readFlagSub xs (setBit next 0)
  where
    next = shiftL acc 1

readEnum :: (Enum e) => String -> [e]
readEnum = decodeFlag . readFlag

-- This implementations implies that when f2 == zeroBits then the results of `include` is same as `exclude`
include f1 f2 = (f1 .&. f2) == f2
exclude f1 f2 = (f1 .&. f2) == zeroBits

about :: (Flag -> Flag -> b) -> Flag -> Flag -> Flag -> b
about f fb f1 f2 = f (fb .&. f1) (fb .&. f2)
--eqAbout fb f1 f2 = (fb .&. f1) == (fb .&. f2)
eqAbout = about (==)
includeAbout = about include
-- Should be tested that this really works properly!
excludeAbout = about exclude

anyReq obj req = (req == zeroBits) || (obj .&. req) /= zeroBits
-- Same as `eqAbout req obj req` or `include`, but `eqAbout` has redundant step `req .&. req`.
-- allReq obj req = (obj .&. req) == req
