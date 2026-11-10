//META: generated=true
//META: doc_ref=docs/generated/design/ir-reference/decorations.md#entry-point-and-stage
//META: purpose=Negative - [numthreads(-1,1,1)] is rejected with E31102, confirming the positive-integer validator also catches signed underflow.
//META: intent=negative
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the value validation on the workgroup dimensions from below.
// A negative leading dimension is rejected with the same diagnostic as
// zero, and the caret annotations pin both the short and the long form of
// the message so a rewording or renumbering is caught.

//DIAGNOSTIC_TEST:SIMPLE(diag=CHECK):-target spirv -stage compute -entry main
uniform RWStructuredBuffer<int> buf;

[numthreads(-1, 1, 1)]
/*CHECK:
 ^^^^^^^^^^ invalid 'numthreads' value
 ^^^^^^^^^^ expected a positive integer in 'numthreads' attribute, got '-1'
*/
// CHECK: E31102
void main(uint3 tid : SV_DispatchThreadID)
{
    buf[0] = int(tid.x);
}
