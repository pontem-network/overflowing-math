spec overflowing_math::overflowing_u128 {
    spec module {
        pragma verify = false;
    }

    spec wrapping_add {
        aborts_if false;
        ensures result <= MAX_U128;
        ensures a + b <= MAX_U128 ==> result == a + b;
        ensures a + b > MAX_U128 ==> result != a + b;
        ensures a + b > MAX_U128 && a < (MAX_U128 - b) ==> result == a - (MAX_U128 - b) - 1;
        ensures a + b > MAX_U128 && b < (MAX_U128 - a) ==> result == b - (MAX_U128 - a) - 1;
        ensures a + b <= MAX_U128 ==> result == a + b;
    }

    spec wrapping_sub {
        aborts_if false;
        ensures result >= 0;
        ensures a - b >= 0 ==> result == a - b;
        ensures a - b < 0 ==> result == MAX_U128 - (b - a) + 1;
    }
}