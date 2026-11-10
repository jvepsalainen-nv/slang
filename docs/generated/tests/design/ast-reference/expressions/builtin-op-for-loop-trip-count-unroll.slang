//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#builtinoperatorexpr
//META: purpose=For-loop trip-count inference reads the resolved builtin operation kind: a [ForceUnroll] loop bounded by `i < (7 % 5)` unrolls into per-iteration stores.
//META: intent=functional
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that trip-count inference consumes the resolved operation kind
// of the builtin comparison in a loop condition. A [ForceUnroll] loop
// whose bound is the builtin-operator expression `7 % 5` (== 2) must have
// an inferable trip count; a failed inference would reject the unroll.
// After unrolling, the second iteration's store constant 41 exists in the
// emitted HLSL (a preserved loop would only contain the `40 + i` form).

//TEST:SIMPLE(filecheck=CHECK):-target hlsl -entry computeMain -stage compute

RWStructuredBuffer<int> outputBuffer;

[numthreads(1, 1, 1)]
void computeMain()
{
    [ForceUnroll]
    for (int i = 0; i < (7 % 5); i++)
        outputBuffer[i] = 40 + i;
    // CHECK-DAG: 40
    // CHECK-DAG: 41
}
