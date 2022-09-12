/// Overflowing math for u128 numbers.
module overflowing_math::overflowing_u128 {
    /// Max u128 value.
    const MAX_U128: u128 = 340282366920938463463374607431768211455;

    /// Adds two u128 numbers with overflow (a + b).
    /// Returns sum of two numbers and boolean which determines overflow happened.
    public fun add(a: u128, b: u128): (u128, bool) {
        let r = MAX_U128 - b;
        if (r < a) {
            return (a - r - 1, true)
        };
        r = MAX_U128 - a;
        if (r < b) {
            return (b - r - 1, true)
        };

        (a + b, false)
    }

    /// Subtracts two u128 numbers with overflow (a - b).
    /// Returns subtraction of two numbers and boolean which determines overflow happened.
    public fun sub(a: u128, b: u128): (u128, bool) {
        if (a < b) {
            return (MAX_U128 - (b - a) + 1, true)
        };

        (a - b, false)
    }

    /// Multiplies two u128 numbers with overflow (a * b).
    /// Returns the result of multiplying two numbers, carry, and boolean determines overflow happened.
    public fun mul(a: u128, b: u128): (u128, u128, bool) {
        if (b != 0 && a > MAX_U128 / b) {
            let x = lo(a) * lo(b);
            let s0 = lo(x);

            let x = hi(a) * lo(b) + hi(x);
            let s1 = lo(x);
            let s2 = hi(x);
            x = s1 + lo(a) * hi(b);
            let s1 = lo(x);

            let x = s2 + hi(a) * hi(b) + hi(x);
            let s2  = lo(x);
            let s3 = hi(x);

            let result = s1 << 64 | s0;
            let carry = s3 << 64 | s2;

            (result, carry, true)
        } else {
            (a * b, 0, false)
        }
    }

    /// Adds two u128 numbers with overflow (a + b).
    public fun wrapping_add(a: u128, b: u128): u128 {
        let (r, _) = add(a, b);
        r
    }

    /// Subtracts two u128 numbers with overflow (a - b).
    public fun wrapping_sub(a: u128, b: u128): u128 {
        let (r, _) = sub(a, b);
        r
    }

    /// Multiplies two u128 numbers with overflow (a * b).
    public fun wrapping_mul(a: u128, b: u128): u128 {
        let (r, _, _) = mul(a, b);
        r
    }

    /// Multiplies two u128 numbers with overflow (a * b) and returns a result and carry.
    public fun wrapping_mul_with_carry(a: u128, b: u128): (u128, u128) {
        let (r, c, _) = mul(a, b);
        (r, c)
    }

    /// Swift 64 bits to get highest bits only.
    fun hi(x: u128): u128 {
        x >> 64
    }

    /// It's like bitwise AND to get only lowest bits only.
    fun lo(x: u128): u128 {
        ((x % (0xFFFFFFFFFFFFFFFF + 1)))
    }

    #[test]
    fun add_test() {
        let (a, f) = add(100, 200);
        assert!(a == 300, 0);
        assert!(!f, 1);

        let (a, f) = add(MAX_U128, 1);
        assert!(a == 0, 2);
        assert!(f, 3);

        let (a, f) = add(MAX_U128, 100);
        assert!(a == 99, 4);
        assert!(f, 5);

        let (a, f) = add(0, 100);
        assert!(a == 100, 6);
        assert!(!f, 7);

        let (a, f) = add(MAX_U128, 0);
        assert!(a == MAX_U128, 8);
        assert!(!f, 9);
    }

    #[test]
    fun sub_test() {
        let (a, f)  = sub(100, 100);
        assert!(a == 0, 0);
        assert!(!f, 1);

        let (a, f) = sub(100, 101);
        assert!(a == MAX_U128, 2);
        assert!(f, 3);

        let (a, f) = sub(0, 100);
        assert!(a == MAX_U128 - 99, 4);
        assert!(f, 5);

        let (a, f) = sub(0, MAX_U128);
        assert!(a == 1, 6);
        assert!(f, 7);

        let (a, f) = sub(0, 0);
        assert!(a == 0, 8);
        assert!(!f, 9);

        let (a, f) = sub(0, 1);
        assert!(a == MAX_U128, 10);
        assert!(f, 11);

        let (a, f) = sub(MAX_U128, MAX_U128);
        assert!(a == 0, 12);
        assert!(!f, 13);
    }

    #[test]
    fun mul_test() {
        let (a, c, f) = mul(100, 200);
        assert!(a == 100 * 200, 0);
        assert!(c == 0, 1);
        assert!(!f, 2);

        let (a, c, f) = mul(MAX_U128, 2);
        assert!(a == 340282366920938463463374607431768211454, 3);
        assert!(c == 1, 4);
        assert!(f, 5);

        let (a, c, f) = mul(0, 0);
        assert!(a == 0, 6);
        assert!(c == 0, 7);
        assert!(!f, 8);

        let (a, c, f) = mul(1, 0);
        assert!(a == 0, 9);
        assert!(c == 0, 10);
        assert!(!f, 11);

        let (a, c, f) = mul(0, 1);
        assert!(a == 0, 12);
        assert!(c == 0, 13);
        assert!(!f, 14);

        let (a, c, f) = mul(MAX_U128, 100);
        assert!(a == 340282366920938463463374607431768211356, 15);
        assert!(c == 99, 16);
        assert!(f, 17);

         let (a, c, f) = mul(MAX_U128, 5);
        assert!(a == 340282366920938463463374607431768211451, 18);
        assert!(c == 4, 19);
        assert!(f, 20);

        let (a, c, f) = mul(MAX_U128, MAX_U128);
        assert!(a == 1, 21);
        assert!(c == MAX_U128 - 1, 22);
        assert!(f, 23);
    }

    #[test]
    fun wrapping_add_test() {
        let a = wrapping_add(100, 200);
        assert!(a == 300, 0);

        let a = wrapping_add(MAX_U128, 1);
        assert!(a == 0, 1);

        let a = wrapping_add(MAX_U128, 100);
        assert!(a == 99, 2);

        let a = wrapping_add(0, 100);
        assert!(a == 100, 3);

        let a = wrapping_add(MAX_U128, 0);
        assert!(a == MAX_U128, 4);
    }

    #[test]
    fun wrapping_sub_test() {
        let a = wrapping_sub(100, 100);
        assert!(a == 0, 0);

        let a = wrapping_sub(100, 101);
        assert!(a == MAX_U128, 1);

        let a = wrapping_sub(0, 100);
        assert!(a == MAX_U128 - 99, 2);

        let a = wrapping_sub(0, MAX_U128);
        assert!(a == 1, 3);

        let a = wrapping_sub(0, 0);
        assert!(a == 0, 4);

        let a = wrapping_sub(0, 1);
        assert!(a == MAX_U128, 5);

        let a = wrapping_sub(MAX_U128, MAX_U128);
        assert!(a == 0, 6);
    }

    #[test]
    fun wrapping_mul_test() {
        let a = wrapping_mul(100, 200);
        assert!(a == 100 * 200, 0);

        let a = wrapping_mul(MAX_U128, 2);
        assert!(a == 340282366920938463463374607431768211454, 1);

        let a= wrapping_mul(0, 0);
        assert!(a == 0, 2);

        let a = wrapping_mul(1, 0);
        assert!(a == 0, 3);

        let a = wrapping_mul(0, 1);
        assert!(a == 0, 4);

        let a = wrapping_mul(MAX_U128, 100);
        assert!(a == 340282366920938463463374607431768211356, 5);

         let a = wrapping_mul(MAX_U128, 5);
        assert!(a == 340282366920938463463374607431768211451, 6);

        let a = wrapping_mul(MAX_U128, MAX_U128);
        assert!(a == 1, 7);
    }

    #[test]
    fun wrapping_mul_test_with_carry() {
        let (a, c) = wrapping_mul_with_carry(100, 200);
        assert!(a == 100 * 200, 0);
        assert!(c == 0, 1);

        let (a, c) = wrapping_mul_with_carry(MAX_U128, 2);
        assert!(a == 340282366920938463463374607431768211454, 2);
        assert!(c == 1, 3);

        let (a, c) = wrapping_mul_with_carry(0, 0);
        assert!(a == 0, 4);
        assert!(c == 0, 5);

        let (a, c) = wrapping_mul_with_carry(1, 0);
        assert!(a == 0, 6);
        assert!(c == 0, 7);

        let (a, c) = wrapping_mul_with_carry(0, 1);
        assert!(a == 0, 8);
        assert!(c == 0, 9);

        let (a, c) = wrapping_mul_with_carry(MAX_U128, 100);
        assert!(a == 340282366920938463463374607431768211356, 10);
        assert!(c == 99, 11);

         let (a, c) = wrapping_mul_with_carry(MAX_U128, 5);
        assert!(a == 340282366920938463463374607431768211451, 12);
        assert!(c == 4, 13);

        let (a, c) = wrapping_mul_with_carry(MAX_U128, MAX_U128);
        assert!(a == 1, 14);
        assert!(c == MAX_U128 - 1, 15);
    }
}
