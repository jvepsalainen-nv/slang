//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#nodes
//META: purpose=Verifies that a single-element SwizzleExpr (`v.y`) carries a one-entry elementIndices ShortList and extracts the corresponding scalar component.
//META: intent=boundary
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Lower-edge boundary for SwizzleExpr.elementIndices: a single
// index. `v.y` on (1,2,3) selects the scalar 2.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    float3 v = float3(1.0f, 2.0f, 3.0f);
    float y = v.y;
    // CHECK: y=2
    printf("y=%d\n", int(y));
}
