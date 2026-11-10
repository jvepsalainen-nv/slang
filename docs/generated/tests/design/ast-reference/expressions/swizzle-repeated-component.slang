//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#nodes
//META: purpose=Stresses SwizzleExpr by repeating the same source component across the result: `v.xxxx` on (5,_,_,_) builds a vector of four 5s.
//META: intent=stress
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Stress on SwizzleExpr.elementIndices uniqueness: repeated indices
// are legal and must replicate the chosen component.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    float4 v = float4(5.0f, 6.0f, 7.0f, 8.0f);
    float4 s = v.xxxx;
    // CHECK: c=5 5 5 5
    printf("c=%d %d %d %d\n", int(s.x), int(s.y), int(s.z), int(s.w));
}
