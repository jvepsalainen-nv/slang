//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/decorations.md#entry-point-and-stage
//META: purpose=Negative - [numthreads(0,1,1)] is rejected with E31102 "expected a positive integer", the lower-edge invalid input.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies that zero is outside the legal workgroup-dimension range even
// though it is a syntactically valid integer literal. The caret annotations
// pin the diagnostic at the attribute and the code CHECK pins E31102, so
// the boundary between the accepted minimum (1) and the rejected 0 is
// asserted from both sides across this test and `num-threads-min`.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):-target spirv -stage compute -entry main
uniform RWStructuredBuffer<int> buf;

[numthreads(0, 1, 1)]
/*CHECK:
 ^^^^^^^^^^ invalid 'numthreads' value
 ^^^^^^^^^^ expected a positive integer in 'numthreads' attribute, got '0'
*/
// CHECK: E31102
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = int(tid.x);
}
