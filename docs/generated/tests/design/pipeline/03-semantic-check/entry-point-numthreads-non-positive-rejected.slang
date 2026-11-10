//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/03-semantic-check.md#shader-specific-checks
//META: purpose=Entry-point attribute-value checking rejects a non-positive thread-group extent in `[numthreads(...)]` (E31102).
//META: intent=boundary
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the lower boundary of the `numthreads` extents: zero threads is
// not a degenerate-but-legal group, it is rejected during checking. CHECK
// pins E31102, whose message repeats the offending value.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive): -target hlsl

[shader("compute")]
[numthreads(0, 1, 1)]
void main()
{
}
//CHECK: E31102
