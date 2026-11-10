//META: generated=true
//META: doc_ref=docs/generated/design/target-pipelines/wgsl.md#phase-d-wgsl-emit-and-downstream-tools
//META: purpose=[numthreads(0,1,1)] is rejected with diagnostic E31102 ('invalid numthreads value') because the @workgroup_size axis cannot be zero
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Below-the-lower-edge of the @workgroup_size axis: a zero
// dimension is rejected at semantic-check time. The caret column
// of the offending token is 2 ('[' is column 1), so we use the
// block-comment CHECK form to attach annotations to that column.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK,non-exhaustive):-target wgsl -entry main -stage compute

RWStructuredBuffer<uint> outBuf;

[shader("compute")]
[numthreads(0,1,1)]
/*CHECK:
 ^^^^^^^^^^ expected a positive integer in 'numthreads' attribute, got '0'
*/
// CHECK: E31102
void main(uint3 tid : SV_DispatchThreadID)
{
    outBuf[tid.x] = tid.x;
}
