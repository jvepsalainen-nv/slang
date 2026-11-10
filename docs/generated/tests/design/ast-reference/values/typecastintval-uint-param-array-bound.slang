//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/values.md#intval-family
//META: purpose=An integer cast to a different integer type is itself a compile-time integer, so a uint generic value parameter cast to int is usable as an array bound and folds after substitution.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a cast between integer types survives as a compile-time
// value rather than forcing the bound to become non-constant. The
// parameter type `int[int(N)]` is built over a `uint` generic value
// parameter; the call `sumCast<3>(aa)` with an `int[3]` argument only
// type-checks if the cast value substituted and folded to 3, and CHECK
// asserts the resulting sum.

//TEST:INTERPRET(filecheck=CHECK):

int sumCast<let N : uint>(int a[int(N)])
{
    int total = 0;
    for (int i = 0; i < int(N); ++i) { total += a[i]; }
    return total;
}

void main()
{
    int aa[3] = { 1, 2, 3 };
    // CHECK: cast=6
    printf("cast=%d\n", sumCast<3>(aa));
}
