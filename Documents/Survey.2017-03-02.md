Surveys on 2017/03/02
====

# Notes

After making a commit of 0.2.0.0, I started to survey similar libraries.
There should be, and there are.

# Sample code of http://stackoverflow.com/questions/15910363/represent-a-list-of-enums-bitwise-as-an-int

This gives very good monadic implementation example.
This implementation is related the main issue which I want to solve (Handles `Enum` in `Traversable`) more generally.

# enumset

Have many dependency footprint compare to current version(doldol-0.2.0.0); `data-accessor`, `storable-record` and its dependencies.

## Implements

Also, the package concern about to using C libraries via FFI and Ordering.
Therefore it uses extensible type `T word index`, instead of `Word64`.
Also, it requires `index` as default, which `doldol` requires it only for `Data.Flag.Phantom`.

This is better than my implement, but may hard to understand for beginner who wants to describe type signatures.

Name conflicting with Prelude is another problem. Of courses it can be solved by many ways like `qualified` and redefine.
But why not avoid it?

## Who uses it?
Some packages which seems to be important like `llvm-ffi` and `llvm-th` uses it.

## Comment for `doldol`

`doldol` may direct to smaller dependency footprint.
It may loose functionality, but may not needed for near future.
Also, the package has lack of monadic interface which `doldol` also not have it yet.

# EdisonCore

Have not so many dependency footprint(many of them is very common libraries).
Only EdisonAPI and itself, which gives very many data structures.
