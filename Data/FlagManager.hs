{-# LANGUAGE CPP #-}

module Data.FlagManager where


import Data.Bits
-- import Data.Traversable

#ifdef DEBUG
import Control.Exception
#endif

type Flag = Int

isFlaggable :: (Bounded a, Enum a) => a -> Bool
isFlaggable x = fromEnum (maxBound `asTypeOf` x) < 64

makeFlag :: (Bounded a, Enum a) => [a] -> Flag
makeFlag [] = zeroBits
makeFlag anEnumList =
  #ifdef DEBUG
  assert (isFlaggable . head $ anEnumList) $
  #endif
    makeFlagSub anEnumList zeroBits
makeFlagSub [] b = b
makeFlagSub (x:xs) b = makeFlagSub xs $ setBit b (fromEnum x)

-- eq f1 f2 = xor f1 f2 == zeroBits
include f1 f2 = ((complement f1) .&. (f1 .|. f2)) == zeroBits
exclude f1 f2 = (f1 .&. f2) == zeroBits
