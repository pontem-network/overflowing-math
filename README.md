# Overflowing Math Library

The overflowing math library implements basic math (add, mul, sub) for `u128` and `u64` types, which by default don't
overflow in Move language.

While many blockchain projects (like Uniswap v2 or Uniswap v3) done their math utilizing numbers overflow 
(by default in `solidity < 0.8`), but the Move language itself prevents any overflows of number types as it aborts
in that case.

The [Liquidswap](https://liquidswap.com) and [U256](https://github.com/pontem-network/u256) are utilizing 
overflow math, and it needs overflowing `u128` and `u64` too.

So we think it could be useful for other projects, especially that one migrates from Solidity database to Move one.

The lib has similar to Rust wrapping math functions and more complex low-level functions.

### Build

    aptos move build

### Test

    aptos move test

### Specs

    aptos move prove

## Add as dependency

Add to `Move.toml`:

```toml
[dependencies.OverflowingMath]
git = "https://github.com/pontem-network/overflowing-math.git"
rev = "v0.1.0"
```

And then use in code:

```move
use overflowing_math::overflowing_u128;
...
let a = overflowing_u128::wrapping_add(340282366920938463463374607431768211455, 340282366920938463463374607431768211455);
...
let c = overflowing_u128::wrapping_sub(0, 100);
...
// Or more detailed.
let (a, is_overflow) = overflowing_u128::add(340282366920938463463374607431768211455, 340282366920938463463374607431768211455);
assert!(is_overflow, 1);
```

## License

GPL v3.0
