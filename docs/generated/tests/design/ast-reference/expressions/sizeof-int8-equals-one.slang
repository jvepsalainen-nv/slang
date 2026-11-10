//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#nodes
//META: purpose=Verifies the lower-edge boundary of SizeOfExpr: `sizeof(int8_t)` is the documented value 1.
//META: intent=boundary
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Lower-edge boundary for SizeOfExpr: the smallest documented
// numeric type is 1 byte wide.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int s = int(sizeof(int8_t));
    // CHECK: s=1
    printf("s=%d\n", s);
}
