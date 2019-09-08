Problem with `Traversable`
====

# To implement `isFlaggable`

To implement `isFlaggable`, the type of data is needed.

In previous implement, it is like as

````
isFlaggable :: (Bounded a, Enum a) => a -> Bool
isFlaggable x = fromEnum (maxBound `asTypeOf` x) < bitLen
````

This implementation is depended on `GHC.Base`

## Implement without using `asTypeOf`

However, by using type variable, I tried to implement like as

````
isFlaggable _ = fromEnum (maxBound :: a) < bitLen :: (Bounded a, Enum a) => a -> Bool
````

But I get error message like

````
    • Couldn't match expected type ‘a1 -> Bool’ with actual type ‘Bool’
    • Possible cause: ‘(<)’ is applied to too many arguments
      In the expression:
          (fromEnum (maxBound :: a) < 16) :: (Bounded a, Enum a) => a -> Bool
      In an equation for ‘isFlaggable’:
          isFlaggable _
            = (fromEnum (maxBound :: a) < 16) ::
                (Bounded a, Enum a) => a -> Bool

````

This message is hard to understand for me.

Not defining on ghci, I tried code on the file.

````
typeVariable.hs:3:17: error:
    • Could not deduce (Enum a0) arising from a use of ‘fromEnum’
      from the context: (Bounded a, Enum a)
        bound by the type signature for:
                   isFlaggable :: (Bounded a, Enum a) => a -> Bool
        at typeVariable.hs:2:1-47
      The type variable ‘a0’ is ambiguous
      These potential instances exist:
        instance Enum Ordering -- Defined in ‘GHC.Enum’
        instance Enum Integer -- Defined in ‘GHC.Enum’
        instance Enum () -- Defined in ‘GHC.Enum’
        ...plus six others
        (use -fprint-potential-instances to see them all)
    • In the first argument of ‘(<)’, namely ‘fromEnum (maxBound :: a)’
      In the expression: fromEnum (maxBound :: a) < bitLen
      In an equation for ‘isFlaggable’:
          isFlaggable _ = fromEnum (maxBound :: a) < bitLen

typeVariable.hs:3:27: error:
    • Could not deduce (Bounded a1) arising from a use of ‘maxBound’
      from the context: (Bounded a, Enum a)
        bound by the type signature for:
                   isFlaggable :: (Bounded a, Enum a) => a -> Bool
        at typeVariable.hs:2:1-47
      Possible fix:
        add (Bounded a1) to the context of
          an expression type signature:
            a1
    • In the first argument of ‘fromEnum’, namely ‘(maxBound :: a)’
      In the first argument of ‘(<)’, namely ‘fromEnum (maxBound :: a)’
      In the expression: fromEnum (maxBound :: a) < bitLen
Failed, modules loaded: none.
````

This makes sense, but also cannot be understand for me.

# With using `asTypeOf`

Even using `asTypeOf`, there still exist another problem.
The problem is that how to get a element of the `Traversable a`.
To apply something to `asTypeOf`, The function should pick a element from the `Traversable a`.
However, there are no good class method for `Traversable a` like `head`. Therefore, I stucked in the point.

Moreover, `head` is also very dangerous! There could be empty `Traversable a`. Therefore, the approach depends on type variable is better then this. Of course, there could be trick like using `fromEnum 0`
