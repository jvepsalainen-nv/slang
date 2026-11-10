//META: generated=true
//META: doc_ref=docs/generated/design/pipeline/05-ir-passes.md#ssa-construction-and-basic-cleanup
//META: purpose=Negative: the missing-return pass fires on an entirely empty non-void function body — the empty-body shape is a distinct input from the partial-branch shape.
//META: intent=negative
//META: pipeline_stage=ir-pass
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Alternative input shape for missing-return: the function body is
// empty (no statements at all). The same `E41010` diagnostic fires
// and attaches to the function name.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):-target hlsl -stage compute -entry main

uniform RWStructuredBuffer<int> buf;
uniform int x;

int empty(int n)
/*CHECK:
    ^^^^^ non-void function does not return in all cases
*/
// CHECK: W41010
{
}

[numthreads(1, 1, 1)]
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = empty(x);
}
