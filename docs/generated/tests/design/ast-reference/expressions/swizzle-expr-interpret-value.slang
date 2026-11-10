//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#nodes
//META: purpose=A SwizzleExpr `v.zyx` reorders components by the listed indices; the resulting vector's components match the swizzle.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Beyond emit-text checks (covered in the multi-target sibling), the
// VALUE of a swizzle expression is the chosen-index sequence. We
// confirm v.zyx of (1,2,3) is (3,2,1).

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    float3 v = float3(1.0f, 2.0f, 3.0f);
    float3 s = v.zyx;
    // CHECK: x=3
    printf("x=%d\n", int(s.x));
    // CHECK: y=2
    printf("y=%d\n", int(s.y));
    // CHECK: z=1
    printf("z=%d\n", int(s.z));
}
