//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/expressions.md#nodes
//META: purpose=Verifies that a PostfixExpr `a[i]++` increments the indexed array element (not the index): the IndexExpr is the operand of the PostfixExpr.
//META: intent=boundary
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Boundary on postfix-vs-index parser precedence. `a[i]++` must
// bind `++` to the IndexExpr, not to `i`. After the operation,
// `a[1]` should be one greater than the original.

//TEST:INTERPRET(filecheck=CHECK):

void main()
{
    int a[4] = {10, 20, 30, 40};
    int prev = a[1]++;
    // CHECK: prev=20
    printf("prev=%d\n", prev);
    // CHECK: now=21
    printf("now=%d\n", a[1]);
}
