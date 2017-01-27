{-# LANGUAGE RankNTypes #-}

module Data.Flag.Phantom (
    module Data.Flag.Phantom
  , module Data.Flag.Internal
  ) where


import Data.Flag.Internal
import qualified Data.Flag.Simple as SF


newtype PhantomFlag t = PhFlag Flag deriving (Show, Eq)

getFlag (PhFlag f) = f

encodeFlag :: (Bounded a, Enum a) => [a] -> PhantomFlag t
encodeFlag = PhFlag . SF.encodeFlag

decodeFlag :: Enum a => PhantomFlag t -> [a]
decodeFlag = SF.decodeFlag . getFlag

showFlag :: PhantomFlag t -> String
showFlag = SF.showFlag . getFlag

showFlagFit :: (Bounded a, Enum a) => a -> PhantomFlag t -> String
showFlagFit a = SF.showFlagFit a . getFlag

showFlagBy :: Int -> PhantomFlag t -> String
showFlagBy l = SF.showFlagBy l . getFlag

readFlag :: String -> PhantomFlag t
readFlag = PhFlag . SF.readFlag

readEnum :: (Enum a) => String -> [a]
readEnum = SF.readEnum

include :: PhantomFlag t -> PhantomFlag t -> Bool
include pf1 pf2 = SF.include (getFlag pf1) (getFlag pf2)
exclude :: PhantomFlag t -> PhantomFlag t -> Bool
exclude pf1 pf2 = SF.exclude (getFlag pf1) (getFlag pf2)

about :: (Flag -> Flag -> b) -> PhantomFlag t -> PhantomFlag t -> PhantomFlag t -> b
about f pfb pf1 pf2 = SF.about f (getFlag pfb) (getFlag pf1) (getFlag pf2)

eqAbout = about (==)

includeAbout = about SF.include
-- Should be tested that this really works properly!
excludeAbout = about SF.exclude
