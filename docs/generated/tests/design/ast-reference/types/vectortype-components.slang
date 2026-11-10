//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/types.md#basicexpressiontype-vectorexpressiontype-matrixexpressiontype
//META: purpose=A VectorExpressionType carries an element type and an element count; a float4 value's four components are independently readable by swizzle.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the (element-type, count) shape of the vector arithmetic
// leaf: a float4 exposes exactly four float components addressable as
// .x/.y/.z/.w. Each is printed with a distinct value; CHECK asserts all
// four, which only holds if the count-4 shape survived checking.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    float4 v = float4(10.0, 20.0, 30.0, 40.0);
    // CHECK: v=10,20,30,40
    printf("v=%d,%d,%d,%d\n", int(v.x), int(v.y), int(v.z), int(v.w));
}
