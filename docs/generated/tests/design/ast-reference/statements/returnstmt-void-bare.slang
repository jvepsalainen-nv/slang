//META: generated=true
//META: doc_ref=docs/generated/design/ast-reference/statements.md#returnstmt
//META: purpose=A ReturnStmt in a void function is allowed to omit its expression (`return;`); the function halts and statements after the bare return do not execute on the early-return path.
//META: intent=boundary
//META: pipeline_stage=check
//META: warning=Auto-generated. May drift from source. Do not edit by hand.

// Verifies the returned expression may be omitted when the enclosing
// function returns `void`, and that the bare `return` still halts the
// function. The CHECKs assert the post-return print fires only on the
// path that did not take the early return.

//TEST:INTERPRET(filecheck=CHECK):

void worker(int n)
{
    printf("entry n=%d\n", n);
    if (n < 0) { return; }
    printf("post-return n=%d\n", n);
}

void main()
{
    worker(5);
    worker(-1);
    // CHECK: entry n=5
    // CHECK-NEXT: post-return n=5
    // CHECK-NEXT: entry n=-1
}
