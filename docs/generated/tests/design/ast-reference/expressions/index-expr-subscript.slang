//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#nodes
//META: purpose=An IndexExpr `a[i]` reads the i-th element of an indexed value; with a baseExpression and one index expression.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// IndexExpr is documented as `a[i]` with baseExpression and
// indexExprs. Indexing a fixed-size array returns the stored element.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int arr[4] = {10, 20, 30, 40};
    // CHECK: a0=10
    printf("a0=%d\n", arr[0]);
    // CHECK: a3=40
    printf("a3=%d\n", arr[3]);
}
