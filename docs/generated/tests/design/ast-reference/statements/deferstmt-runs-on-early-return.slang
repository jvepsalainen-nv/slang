//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/statements.md#deferstmt
//META: purpose=A DeferStmt's inner statement still runs when the enclosing scope exits via an early `return`, not only when the scope falls through its end.
//META: intent=functional
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies a deferred statement still runs when the function exits via
// an early `return`, not only on fall-through. The CHECK asserts the
// deferred print lands between the function body's print and the
// caller's next print.

//TEST:INTERPRET(filecheck=CHECK):

void inner()
{
    defer printf("inner-defer\n");
    printf("inner-body\n");
    return;
}

void main()
{
    inner();
    printf("after-call\n");
    // CHECK: inner-body
    // CHECK-NEXT: inner-defer
    // CHECK-NEXT: after-call
}
