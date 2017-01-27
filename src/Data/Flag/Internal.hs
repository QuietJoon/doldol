module Data.Flag.Internal where


import Data.Int
-- import Data.Traversable

import GHC.Base


type Flag = Int64
bitLen = 64 -- Just for Int64. Not so good code.

isFlaggable :: (Bounded a, Enum a) => a -> Bool
isFlaggable x = fromEnum (maxBound `asTypeOf` x) < bitLen
