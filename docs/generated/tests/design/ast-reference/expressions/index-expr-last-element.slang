//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#nodes
//META: purpose=Verifies an IndexExpr at the upper-edge index N-1 (here, 3 for a 4-element array) reads the last stored element.
//META: intent=boundary
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Upper-edge boundary for IndexExpr on a fixed-size array. The
// final element (index N-1) must read back as written.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int arr[4] = {11, 22, 33, 44};
    // CHECK: v=44
    printf("v=%d\n", arr[3]);
}
