//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#nodes
//META: purpose=Verifies an IndexExpr at the lower-edge index 0 reads the first stored element.
//META: intent=boundary
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Lower-edge boundary for IndexExpr.indexExprs[0]. Reading `arr[0]`
// from a 4-element array must yield the documented first element.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int arr[4] = {11, 22, 33, 44};
    // CHECK: v=11
    printf("v=%d\n", arr[0]);
}
