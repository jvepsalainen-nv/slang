//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#memberexpr--staticmemberexpr--derefmemberexpr
//META: purpose=Verifies that a `.` member access on a vector base reaches the numbered component rather than being looked up as a struct field.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// A dot access is resolved against the base's type, and on a vector the base
// has no declared members, so the access has to be reinterpreted as a
// component selection. Each of the three components is read individually; the
// CHECKs assert the distinct values, so a component selection that resolved to
// the wrong index fails.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    float3 v = float3(1.0f, 2.0f, 3.0f);
    // CHECK: x=1 y=2 z=3
    printf("x=%d y=%d z=%d\n", int(v.x), int(v.y), int(v.z));
}
