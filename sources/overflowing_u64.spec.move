spec overflowing_math::overflowing_u64 {
    spec module {
        pragma verify = false;
    }

    spec wrapping_add {
        aborts_if false;
        ensures result <= MAX_U64;
        ensures a + b <= MAX_U64 ==> result == a + b;
        ensures a + b > MAX_U64 ==> result != a + b;
        ensures a + b > MAX_U64 && a < (MAX_U64 - b) ==> result == a - (MAX_U64 - b) - 1;
        ensures a + b > MAX_U64 && b < (MAX_U64 - a) ==> result == b - (MAX_U64 - a) - 1;
        ensures a + b <= MAX_U64 ==> result == a + b;
    }

    spec wrapping_sub {
        aborts_if false;
        ensures result >= 0;
        ensures a - b >= 0 ==> result == a - b;
        ensures a - b < 0 ==> result == MAX_U64 - (b - a) + 1;
    }
}