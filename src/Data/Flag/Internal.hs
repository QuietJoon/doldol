module Data.Flag.Internal where


import Data.Word


type Flag = Word64
bitLen = 64 -- Just for Word64. Not so good code.

isFlaggable :: (Bounded a, Enum a) => a -> Bool
isFlaggable x = fromEnum (maxBound `asTypeOf` x) < bitLen
