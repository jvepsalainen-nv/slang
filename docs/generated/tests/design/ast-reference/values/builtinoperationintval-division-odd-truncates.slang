//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/values.md#builtinoperationintval-and-the-single-representation-invariant
//META: purpose=Folding a symbolic division truncates like integer division, so N / 2 with an odd N = 9 substitutes to an array bound of 4, not 5.
//META: intent=boundary
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the boundary where the folded quotient is inexact: with an
// odd N the compile-time division must truncate. sumHalf<9> makes the
// parameter type int[9 / 2]; passing an int[4] argument type-checks
// only if the fold produced 4 (truncation), and CHECK asserts the
// four-element sum.

//TEST:INTERPRET(filecheck=CHECK):

int sumHalf<let N : int>(int a[N / 2])
{
    int total = 0;
    for (int i = 0; i < N / 2; ++i) { total += a[i]; }
    return total;
}

void main()
{
    // 9 / 2 truncates to 4, so int[4] matches the substituted type.
    int aa[4] = { 2, 4, 6, 8 };
    // CHECK: oddhalf=20
    printf("oddhalf=%d\n", sumHalf<9>(aa));
}
