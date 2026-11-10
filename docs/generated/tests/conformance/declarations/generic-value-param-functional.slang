//META: generated=true
//META: doc_ref=docs/language-reference/declarations.md#generics
//META: purpose=A generic value parameter `let N : int` can be used at compile time to size arrays or bound loops.
//META: intent=functional
//META: pipeline_stage=runtime
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that a `let N : int` generic value parameter is usable as a compile-time array size and loop bound.
// `sumArray<3>` sums a 3-element array using N in the loop; 6 confirms the
// value parameter resolved correctly to size the iteration.

//TEST:INTERPRET(filecheck=CHECK):

float sumArray<let N : int>(float arr[N])
{
    float s = 0.0;
    for (int i = 0; i < N; i++) s += arr[i];
    return s;
}

void main()
{
    float arr[3] = { 1.0, 2.0, 3.0 };
    // CHECK: 6
    printf("%g\n", sumArray(arr));
}
