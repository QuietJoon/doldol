Plans
====

# Handles `Enum` in `Traversable`

`doldol-0.*` will handle `Enum a => [a]` only.
`doldol-1.*` will handle `Enum a => Traversable a`.

# Handle `a` in `Traversable`

I'm not sure how to represent abstract `a`, but it will expanded from `Enum` to `a`.
`doldol-2.*` may handle it.
This mode will be presented not for practical purpose. But this may use SIMD or something.
