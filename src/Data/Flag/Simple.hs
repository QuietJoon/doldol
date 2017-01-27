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


encodeFlag :: (Bounded a, Enum a) => [a] -> Flag
encodeFlag [] = zeroBits
encodeFlag anEnumList =
  #ifdef DEBUG
  assert (isFlaggable . head $ anEnumList) $
  #endif
    encodeFlagSub anEnumList zeroBits
  where
    encodeFlagSub [] b = b
    encodeFlagSub (x:xs) b = encodeFlagSub xs $ setBit b (fromEnum x)

decodeFlag :: Enum a => Flag -> [a]
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

showFlagFit :: (Bounded a, Enum a) => a -> Flag -> String
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

readEnum :: (Enum a) => String -> [a]
readEnum = decodeFlag . readFlag

include f1 f2 = ((complement f1) .&. (f1 .|. f2)) == zeroBits
exclude f1 f2 = (f1 .&. f2) == zeroBits

about :: (Flag -> Flag -> b) -> Flag -> Flag -> Flag -> b
about f fb f1 f2 = f (fb .&. f1) (fb .&. f2)
--eqAbout fb f1 f2 = (fb .&. f1) == (fb .&. f2)
eqAbout = about (==)
includeAbout = about include
-- Should be tested that this really works properly!
excludeAbout = about exclude
