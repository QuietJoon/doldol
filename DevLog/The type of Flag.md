The type of `Flag`
====

At first, I select `Int64` which is fast in 64-bit machine.
But I wasn't sure that the difference between `Int64` and `Word64`.
Moreover, I forget to concern about unboxed data.

# `Word64`?

Yes, it should be `Word64`, instead of `Int64`.
There could be various standard for ordering Enum data, but `Word64` is more instinctive.

# Unboxed data?

I'm not sure that convenience to generate `Flag` easily.
When the `Flag` is `Int64`, I does not need to convert `Int` value to `Flag` value. I just can use it.
Moreover, I does not define any new data structure, so I may not need to concern about unboxed data.
