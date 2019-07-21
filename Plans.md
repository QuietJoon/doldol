Plans
====

# Related with `Traversable`

## Handles `Enum` in `Traversable`

Currently, `doldol-0.*` handles `Enum e => Flag -> [e]` or `(Enum e, Foldable f) => f e -> Flag`.
`doldol-1.*` will handle `Enum e => Traversable e`.

## Handle `e` in `Traversable`

I'm not sure how to represent abstract `e`, but it will expanded from `Enum` to `e`.
`doldol-2.*` may handle it.
This mode will be presented not for practical purpose. But this may use SIMD or something.
