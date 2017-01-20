{-# LANGUAGE MagicHash, BangPatterns #-}
{-# LANGUAGE CPP #-}

module Data.FlagManager where


import Data.Bits
-- import Data.Traversable

#ifdef DEBUG
import Control.Exception
#endif

import GHC.Base
import GHC.Prim

import Debug.Trace


type Flag = Int
bitLen = 64 -- Just for 64bit Int. Not so good code.

isFlaggable :: (Bounded a, Enum a) => a -> Bool
isFlaggable x = fromEnum (maxBound `asTypeOf` x) < bitLen

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
    decodeFlagSub idx# =
      if testBit aFlag (I# idx#)
        then toEnum (I# idx#) : decodeFlagSub (idx# -# 1#)
        else                    decodeFlagSub (idx# -# 1#)

showFlag :: Flag -> String
showFlag = showFlagSub (bitLen-1)
showFlagSub aFlag (-1) = ""
showFlagSub aFlag num =
  if testBit aFlag num
    then '1' : showFlagSub aFlag (num-1)
    else '0' : showFlagSub aFlag (num-1)

-- eq f1 f2 = xor f1 f2 == zeroBits
include f1 f2 = ((complement f1) .&. (f1 .|. f2)) == zeroBits
exclude f1 f2 = (f1 .&. f2) == zeroBits
