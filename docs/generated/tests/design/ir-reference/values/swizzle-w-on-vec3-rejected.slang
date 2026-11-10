//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/values.md#swizzle-swizzleset-swizzledstore
//META: purpose=Negative boundary: accessing the `.w` component of a `float3` (one past the N=3 edge) is rejected with "'w' is not a member of 'vector<float,3>'." — confirms the index-range check at every documented vector width.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Out-of-range swizzle, taken at the N=3 size. The diagnostic
// message names the source vector type and the missing component
// name, demonstrating the per-width range check.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):-target hlsl -stage compute -entry main

uniform float3 v;
uniform RWStructuredBuffer<float> buf;

[numthreads(1, 1, 1)]
void main()
{
    buf[0] = v.w;
//CHECK:       ^ member not found
//CHECK:       ^ 'w' is not a member of 'vector<float,3>'.
// CHECK: E30027
}
